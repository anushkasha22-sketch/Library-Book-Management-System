-- ============================================================
-- TAE 2 - LIBRARY BOOK ISSUE & RETURN MANAGEMENT SYSTEM
-- Name: Anushka Sharma
-- Roll No: P09
-- ============================================================

USE library_db;
GO


-- ============================================================
-- QUERY 1: FOUR-TABLE INNER JOIN
-- ============================================================

SELECT
    I.Issue_ID,
    M.Member_Name,
    B.Title AS Book_Title,
    B.Author,
    S.Staff_Name,
    I.Issue_Date,
    I.Due_Date,
    I.Return_Date,
    I.Fine_Amount
FROM ISSUE I
INNER JOIN MEMBER M
    ON I.Member_ID = M.Member_ID
INNER JOIN BOOK B
    ON I.Book_ID = B.Book_ID
INNER JOIN STAFF S
    ON I.Staff_ID = S.Staff_ID
ORDER BY I.Issue_ID;


-- ============================================================
-- QUERY 2: LEFT OUTER JOIN
-- ============================================================

SELECT
    M.Member_ID,
    M.Member_Name,
    M.Membership_Type,
    B.Title AS Book_Title,
    I.Issue_Date,
    I.Return_Date
FROM MEMBER M
LEFT JOIN ISSUE I
    ON M.Member_ID = I.Member_ID
LEFT JOIN BOOK B
    ON I.Book_ID = B.Book_ID
ORDER BY M.Member_ID;


-- ============================================================
-- QUERY 3: SELF JOIN
-- ============================================================

SELECT
    S1.Staff_Name AS Staff_1,
    S2.Staff_Name AS Staff_2,
    S1.Designation
FROM STAFF S1
INNER JOIN STAFF S2
    ON S1.Designation = S2.Designation
    AND S1.Staff_ID < S2.Staff_ID
ORDER BY S1.Designation;

-- ============================================================
-- QUERY 4 : COUNT + GROUP BY
-- ============================================================

SELECT
    M.Member_ID,
    M.Member_Name,
    COUNT(I.Issue_ID) AS Books_Borrowed
FROM MEMBER M
LEFT JOIN ISSUE I
    ON M.Member_ID = I.Member_ID
GROUP BY
    M.Member_ID,
    M.Member_Name
ORDER BY Books_Borrowed DESC;

-- ============================================================
-- QUERY 5 : Multiple Aggregate Functions
-- ============================================================

SELECT
    B.Book_ID,
    B.Title,
    COUNT(I.Issue_ID) AS Times_Issued,
    AVG(I.Fine_Amount) AS Average_Fine,
    MAX(I.Fine_Amount) AS Maximum_Fine,
    MIN(I.Fine_Amount) AS Minimum_Fine
FROM BOOK B
LEFT JOIN ISSUE I
    ON B.Book_ID = I.Book_ID
GROUP BY
    B.Book_ID,
    B.Title
ORDER BY Times_Issued DESC;

-- ============================================================
-- QUERY 6 : GROUP BY + HAVING
-- ============================================================

SELECT
    M.Member_ID,
    M.Member_Name,
    COUNT(I.Issue_ID) AS Books_Borrowed
FROM MEMBER M
INNER JOIN ISSUE I
    ON M.Member_ID = I.Member_ID
GROUP BY
    M.Member_ID,
    M.Member_Name
HAVING COUNT(I.Issue_ID) >= 3
ORDER BY Books_Borrowed DESC;

-- ============================================================
-- QUERY 7 : Normal Subquery
-- ============================================================

SELECT
    M.Member_ID,
    M.Member_Name,
    COUNT(I.Issue_ID) AS Books_Borrowed
FROM MEMBER M
INNER JOIN ISSUE I
    ON M.Member_ID = I.Member_ID
GROUP BY
    M.Member_ID,
    M.Member_Name
HAVING COUNT(I.Issue_ID) >
(
    SELECT AVG(Book_Count)
    FROM
    (
        SELECT COUNT(Issue_ID) AS Book_Count
        FROM ISSUE
        GROUP BY Member_ID
    ) AS Member_Borrowing
)
ORDER BY Books_Borrowed DESC;

-- ============================================================
-- QUERY 8 : Correlated Subquery
-- ============================================================

SELECT
    M.Member_ID,
    M.Member_Name,
    M.Membership_Type,
    COUNT(I.Issue_ID) AS Books_Borrowed
FROM MEMBER M
INNER JOIN ISSUE I
    ON M.Member_ID = I.Member_ID
GROUP BY
    M.Member_ID,
    M.Member_Name,
    M.Membership_Type
HAVING COUNT(I.Issue_ID) >=
(
    SELECT AVG(Member_Count * 1.0)
    FROM
    (
        SELECT
            M2.Member_ID,
            COUNT(I2.Issue_ID) AS Member_Count
        FROM MEMBER M2
        LEFT JOIN ISSUE I2
            ON M2.Member_ID = I2.Member_ID
        WHERE M2.Membership_Type = M.Membership_Type
        GROUP BY M2.Member_ID
    ) AS Membership_Average
)
ORDER BY
    M.Membership_Type,
    Books_Borrowed DESC;USE library_db;
GO

DROP VIEW IF EXISTS vw_CurrentlyIssuedBooks;
GO

-- ============================================================
-- View 1 - Operational report 
-- ============================================================

CREATE VIEW vw_CurrentlyIssuedBooks
AS
SELECT
    I.Issue_ID,
    M.Member_ID,
    M.Member_Name,
    B.Book_ID,
    B.Title AS Book_Title,
    S.Staff_ID,
    S.Staff_Name,
    I.Issue_Date,
    I.Due_Date,
    I.Return_Date,
    I.Fine_Amount
FROM ISSUE I
INNER JOIN MEMBER M
    ON I.Member_ID = M.Member_ID
INNER JOIN BOOK B
    ON I.Book_ID = B.Book_ID
INNER JOIN STAFF S
    ON I.Staff_ID = S.Staff_ID
WHERE I.Return_Date IS NULL;
GO

SELECT *
FROM vw_CurrentlyIssuedBooks;
USE library_db;
GO

DROP VIEW IF EXISTS vw_MemberBorrowingSummary;
GO

CREATE VIEW vw_MemberBorrowingSummary
AS
SELECT
    M.Member_ID,
    M.Member_Name,
    M.Membership_Type,
    COUNT(I.Issue_ID) AS Total_Books_Borrowed,
    COALESCE(SUM(I.Fine_Amount), 0) AS Total_Fine,
    COALESCE(AVG(I.Fine_Amount), 0) AS Average_Fine
FROM MEMBER M
LEFT JOIN ISSUE I
    ON M.Member_ID = I.Member_ID
GROUP BY
    M.Member_ID,
    M.Member_Name,
    M.Membership_Type;
GO

USE library_db;
GO

SELECT *
FROM vw_MemberBorrowingSummary
ORDER BY Total_Books_Borrowed DESC;USE library_db;
GO

DROP PROCEDURE IF EXISTS sp_IssueBook;
GO

CREATE PROCEDURE sp_IssueBook
    @Member_ID INT,
    @Book_ID INT,
    @Staff_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check whether the book exists and has an available copy
    IF NOT EXISTS (
        SELECT 1
        FROM BOOK
        WHERE Book_ID = @Book_ID
          AND Available_Copies > 0
    )
    BEGIN
        PRINT 'Book is not available.';
        RETURN;
    END;

    -- Insert the issue record
    INSERT INTO ISSUE
    (
        Member_ID,
        Book_ID,
        Staff_ID,
        Issue_Date,
        Due_Date,
        Return_Date,
        Fine_Amount
    )
    VALUES
    (
        @Member_ID,
        @Book_ID,
        @Staff_ID,
        CAST(GETDATE() AS DATE),
        DATEADD(DAY, 14, CAST(GETDATE() AS DATE)),
        NULL,
        0.00
    );

    -- Reduce available copies by 1
    UPDATE BOOK
    SET Available_Copies = Available_Copies - 1
    WHERE Book_ID = @Book_ID;

    PRINT 'Book issued successfully.';
END;
GOUSE library_db;
GO

DROP TRIGGER IF EXISTS trg_BookReturn;
GO

CREATE TRIGGER trg_BookReturn
ON ISSUE
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Increase available copies when a book is returned
    UPDATE B
    SET B.Available_Copies = B.Available_Copies + 1
    FROM BOOK B
    INNER JOIN inserted I
        ON B.Book_ID = I.Book_ID
    INNER JOIN deleted D
        ON I.Issue_ID = D.Issue_ID
    WHERE D.Return_Date IS NULL
      AND I.Return_Date IS NOT NULL;
END;
GO

SELECT
    Book_ID,
    Title,
    Available_Copies
FROM BOOK
WHERE Book_ID = 8;

UPDATE ISSUE
SET Return_Date = CAST(GETDATE() AS DATE)
WHERE Issue_ID = 253;

SELECT
    Book_ID,
    Title,
    Available_Copies
FROM BOOK
WHERE Book_ID = 8;USE library_db;
GO

SELECT
    t.name AS Table_Name,
    i.name AS Index_Name,
    i.type_desc AS Index_Type
FROM sys.indexes i
INNER JOIN sys.tables t
    ON i.object_id = t.object_id
WHERE t.name IN ('MEMBER', 'BOOK', 'STAFF', 'ISSUE')
ORDER BY t.name, i.name;USE library_db;
GO

SELECT
    t.name AS Table_Name,
    i.name AS Index_Name,
    i.type_desc AS Index_Type
FROM sys.indexes i
INNER JOIN sys.tables t
    ON i.object_id = t.object_id
WHERE t.name = 'ISSUE'
ORDER BY i.name;USE library_db;
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    I.Issue_ID,
    I.Member_ID,
    I.Book_ID,
    I.Staff_ID,
    I.Issue_Date,
    I.Due_Date,
    I.Return_Date,
    I.Fine_Amount
FROM ISSUE I
WHERE I.Book_ID = 8;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

USE library_db;
GO

SELECT
    I.Issue_ID,
    I.Member_ID,
    I.Book_ID,
    I.Staff_ID,
    I.Issue_Date,
    I.Due_Date,
    I.Return_Date,
    I.Fine_Amount
FROM ISSUE AS I
WHERE I.Book_ID = 8;

USE library_db;
GO

SELECT
    Book_ID
FROM ISSUE
WHERE Book_ID = 8;USE library_db;
GO

SELECT
    Book_ID,
    Title,
    Total_Copies,
    Available_Copies
FROM BOOK
WHERE Available_Copies > 0;

SELECT TOP 5
    Member_ID,
    Member_Name
FROM MEMBER
ORDER BY Member_ID;

SELECT TOP 5
    Staff_ID,
    Staff_Name
FROM STAFF
ORDER BY Staff_ID;USE library_db;
GO

EXEC sp_IssueBook
    @Member_ID = 1,
    @Book_ID = 8,
    @Staff_ID = 1;

SELECT TOP 1
    I.Issue_ID,
    M.Member_Name,
    B.Title AS Book_Title,
    S.Staff_Name,
    I.Issue_Date,
    I.Due_Date,
    I.Return_Date,
    I.Fine_Amount
FROM ISSUE I
JOIN MEMBER M
    ON I.Member_ID = M.Member_ID
JOIN BOOK B
    ON I.Book_ID = B.Book_ID
JOIN STAFF S
    ON I.Staff_ID = S.Staff_ID
WHERE I.Member_ID = 1
  AND I.Book_ID = 8
ORDER BY I.Issue_ID DESC;

SELECT
    Book_ID,
    Title,
    Total_Copies,
    Available_Copies
FROM BOOK
WHERE Book_ID = 8;