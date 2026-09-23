-- Insert Members
INSERT INTO MEMBER
(Member_Name, Phone, Email, Membership_Type, Is_Active)
VALUES
('Anushka Sharma', '9876543210', 'anushka@gmail.com', 'Monthly', 1),
('Riya Patil', '9876543211', 'riya@gmail.com', 'Annual', 1),
('Aarav Mehta', '9876543212', 'aarav@gmail.com', 'Daily', 1);
GO

-- Insert Books
INSERT INTO BOOK
(Title, Author, Genre, Price, Total_Copies, Available_Copies)
VALUES
('The Alchemist', 'Paulo Coelho', 'Fiction', 399.00, 5, 5),
('Atomic Habits', 'James Clear', 'Self Help', 499.00, 4, 4),
('Harry Potter', 'J.K. Rowling', 'Fantasy', 599.00, 3, 3);
GO

-- Insert Staff
INSERT INTO STAFF
(Staff_Name, Designation, Phone)
VALUES
('Rahul Joshi', 'Librarian', '9876543220'),
('Sneha Kulkarni', 'Library Assistant', '9876543221');
GO

SELECT * FROM MEMBER;
SELECT * FROM BOOK;
SELECT * FROM STAFF;

INSERT INTO ISSUE
(Member_ID, Book_ID, Staff_ID, Issue_Date, Due_Date, Fine_Amount)
VALUES
(1, 1, 1, CAST(GETDATE() AS DATE),
 DATEADD(DAY, 14, CAST(GETDATE() AS DATE)),
 0.00);
GO

SELECT * FROM ISSUE;

USE library_db;
GO

SELECT COUNT(*) AS Member_Count
FROM MEMBER;

SELECT COUNT(*) AS Book_Count
FROM BOOK;

SELECT COUNT(*) AS Staff_Count
FROM STAFF;

SELECT COUNT(*) AS Issue_Count
FROM ISSUE;

USE library_db;
GO

;WITH Numbers AS
(
    SELECT TOP (117)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO MEMBER
(
    Member_Name,
    Phone,
    Email,
    Membership_Type,
    Is_Active
)
SELECT
    CONCAT(
        CASE (n % 10)
            WHEN 0 THEN 'Aarav'
            WHEN 1 THEN 'Ananya'
            WHEN 2 THEN 'Rohan'
            WHEN 3 THEN 'Priya'
            WHEN 4 THEN 'Rahul'
            WHEN 5 THEN 'Sneha'
            WHEN 6 THEN 'Arjun'
            WHEN 7 THEN 'Kavya'
            WHEN 8 THEN 'Aditya'
            ELSE 'Ishita'
        END,
        ' ',
        CASE (n % 10)
            WHEN 0 THEN 'Sharma'
            WHEN 1 THEN 'Patil'
            WHEN 2 THEN 'Deshmukh'
            WHEN 3 THEN 'Kulkarni'
            WHEN 4 THEN 'Joshi'
            WHEN 5 THEN 'Mehta'
            WHEN 6 THEN 'Nair'
            WHEN 7 THEN 'Pawar'
            WHEN 8 THEN 'Verma'
            ELSE 'Rao'
        END,
        ' ',
        n
    ),

    CONCAT('90000', RIGHT('00000' + CAST(n + 100 AS VARCHAR(5)), 5)),

    CONCAT('member', n + 3, '@library.com'),

    CASE
        WHEN n % 3 = 0 THEN 'Daily'
        WHEN n % 3 = 1 THEN 'Monthly'
        ELSE 'Annual'
    END,

    1
FROM Numbers;
GO

SELECT COUNT(*) AS Member_Count
FROM MEMBER;
;WITH Numbers AS
(
    SELECT TOP (117)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO BOOK
(
    Title,
    Author,
    Genre,
    Price,
    Total_Copies,
    Available_Copies
)
SELECT
    CONCAT(
        CASE (n % 12)
            WHEN 0 THEN 'The Silent'
            WHEN 1 THEN 'Digital'
            WHEN 2 THEN 'Beyond'
            WHEN 3 THEN 'The Last'
            WHEN 4 THEN 'Modern'
            WHEN 5 THEN 'Hidden'
            WHEN 6 THEN 'The Art of'
            WHEN 7 THEN 'Learning'
            WHEN 8 THEN 'Journey to'
            WHEN 9 THEN 'Understanding'
            WHEN 10 THEN 'The Power of'
            ELSE 'Inside'
        END,
        ' ',
        CASE (n % 10)
            WHEN 0 THEN 'Data'
            WHEN 1 THEN 'Technology'
            WHEN 2 THEN 'Success'
            WHEN 3 THEN 'Innovation'
            WHEN 4 THEN 'Python'
            WHEN 5 THEN 'Leadership'
            WHEN 6 THEN 'Science'
            WHEN 7 THEN 'Business'
            WHEN 8 THEN 'Algorithms'
            ELSE 'Knowledge'
        END,
        ' ',
        n
    ),

    CASE (n % 10)
        WHEN 0 THEN 'James Clear'
        WHEN 1 THEN 'Paulo Coelho'
        WHEN 2 THEN 'George Orwell'
        WHEN 3 THEN 'Yuval Noah Harari'
        WHEN 4 THEN 'Robert Martin'
        WHEN 5 THEN 'Chetan Bhagat'
        WHEN 6 THEN 'J.K. Rowling'
        WHEN 7 THEN 'R.K. Narayan'
        WHEN 8 THEN 'Stephen Hawking'
        ELSE 'A.P.J. Abdul Kalam'
    END,

    CASE (n % 8)
        WHEN 0 THEN 'Fiction'
        WHEN 1 THEN 'Technology'
        WHEN 2 THEN 'Science'
        WHEN 3 THEN 'Self Help'
        WHEN 4 THEN 'Biography'
        WHEN 5 THEN 'Business'
        WHEN 6 THEN 'Fantasy'
        ELSE 'Education'
    END,

    CAST(199 + (n % 30) * 20 AS DECIMAL(6,2)),

    3 + (n % 8),

    3 + (n % 8)
FROM Numbers;
GO

SELECT COUNT(*) AS Book_Count
FROM BOOK;

;WITH Numbers AS
(
    SELECT TOP (98)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO STAFF
(
    Staff_Name,
    Designation,
    Phone
)
SELECT
    CONCAT(
        CASE (n % 10)
            WHEN 0 THEN 'Vikram'
            WHEN 1 THEN 'Neha'
            WHEN 2 THEN 'Karan'
            WHEN 3 THEN 'Pooja'
            WHEN 4 THEN 'Amit'
            WHEN 5 THEN 'Snehal'
            WHEN 6 THEN 'Nikhil'
            WHEN 7 THEN 'Tanvi'
            WHEN 8 THEN 'Siddharth'
            ELSE 'Meera'
        END,
        ' Staff ',
        n
    ),

    CASE
        WHEN n % 4 = 0 THEN 'Librarian'
        WHEN n % 4 = 1 THEN 'Library Assistant'
        WHEN n % 4 = 2 THEN 'Senior Librarian'
        ELSE 'Library Clerk'
    END,

    CONCAT('91000', RIGHT('00000' + CAST(n + 100 AS VARCHAR(5)), 5))
FROM Numbers;
GO

SELECT COUNT(*) AS Staff_Count
FROM STAFF;

SELECT COUNT(*) AS Member_Count FROM MEMBER;

SELECT COUNT(*) AS Book_Count FROM BOOK;

SELECT COUNT(*) AS Staff_Count FROM STAFF;

SELECT COUNT(*) AS Issue_Count FROM ISSUE;

USE library_db;
GO

;WITH Numbers AS
(
    SELECT TOP (249)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
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
SELECT
    ((n - 1) % 120) + 1 AS Member_ID,

    ((n - 1) % 120) + 1 AS Book_ID,

    ((n - 1) % 100) + 1 AS Staff_ID,

    DATEADD(
        DAY,
        -(n % 180),
        CAST(GETDATE() AS DATE)
    ) AS Issue_Date,

    DATEADD(
        DAY,
        -(n % 180) + 14,
        CAST(GETDATE() AS DATE)
    ) AS Due_Date,

    CASE
        -- Every 5th record is still active/not returned
        WHEN n % 5 = 0
            THEN NULL

        -- Other records have been returned
        ELSE DATEADD(
            DAY,
            -(n % 180) + 14 + (n % 8),
            CAST(GETDATE() AS DATE)
        )
    END AS Return_Date,

    CASE
        -- No fine for currently issued books
        WHEN n % 5 = 0
            THEN 0.00

        -- Fine based on number of days late
        WHEN n % 8 = 0
            THEN CAST((n % 7) * 5.00 AS DECIMAL(6,2))

        ELSE 0.00
    END AS Fine_Amount

FROM Numbers;
GO

SELECT COUNT(*) AS Member_Count
FROM MEMBER;

SELECT COUNT(*) AS Book_Count
FROM BOOK;

SELECT COUNT(*) AS Staff_Count
FROM STAFF;

SELECT COUNT(*) AS Issue_Count
FROM ISSUE;

SELECT TOP 10 *
FROM ISSUE
ORDER BY Issue_ID DESC;
