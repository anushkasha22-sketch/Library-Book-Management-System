-- ============================================================
-- TAE 2 - LIBRARY BOOK ISSUE & RETURN MANAGEMENT SYSTEM
-- Name: Anushka Sharma
-- Roll No: P09
-- ============================================================

USE master;
GO

ALTER DATABASE library_db SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE library_db;
GO

CREATE DATABASE library_db;
GO

USE library_db;
GO

CREATE TABLE MEMBER (
    Member_ID INT IDENTITY(1,1) PRIMARY KEY,
    Member_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    Email VARCHAR(120) UNIQUE,
    Membership_Type VARCHAR(10) NOT NULL DEFAULT 'Monthly',
    Join_Date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Is_Active TINYINT NOT NULL DEFAULT 1,

    CONSTRAINT CK_Member_Membership
        CHECK (Membership_Type IN ('Daily', 'Monthly', 'Annual'))
);
GO

CREATE TABLE BOOK (
    Book_ID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(150) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Genre VARCHAR(50) NOT NULL,
    Price DECIMAL(6,2) NOT NULL DEFAULT 0.00,
    Total_Copies INT NOT NULL DEFAULT 1,
    Available_Copies INT NOT NULL DEFAULT 1,

    CONSTRAINT CK_Book_Price
        CHECK (Price >= 0),

    CONSTRAINT CK_Book_TotalCopies
        CHECK (Total_Copies >= 0),

    CONSTRAINT CK_Book_AvailableCopies
        CHECK (Available_Copies >= 0),

    CONSTRAINT CK_Book_AvailableLETotal
        CHECK (Available_Copies <= Total_Copies)
);
GO

CREATE TABLE STAFF (
    Staff_ID INT IDENTITY(1,1) PRIMARY KEY,
    Staff_Name VARCHAR(100) NOT NULL,
    Designation VARCHAR(50) NOT NULL DEFAULT 'Library Assistant',
    Phone VARCHAR(15) UNIQUE,
    Date_Joined DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE)
);
GO

CREATE TABLE ISSUE (
    Issue_ID INT IDENTITY(1,1) PRIMARY KEY,

    Member_ID INT NOT NULL,
    Book_ID INT NOT NULL,
    Staff_ID INT NOT NULL,

    Issue_Date DATE NOT NULL,
    Due_Date DATE NOT NULL,
    Return_Date DATE NULL,

    Fine_Amount DECIMAL(6,2) NOT NULL DEFAULT 0.00,

    CONSTRAINT fk_issue_member
        FOREIGN KEY (Member_ID)
        REFERENCES MEMBER(Member_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_issue_book
        FOREIGN KEY (Book_ID)
        REFERENCES BOOK(Book_ID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,

    CONSTRAINT fk_issue_staff
        FOREIGN KEY (Staff_ID)
        REFERENCES STAFF(Staff_ID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,

    CONSTRAINT chk_due_after_issue
        CHECK (Due_Date >= Issue_Date),

    CONSTRAINT chk_return_after_issue
        CHECK (
            Return_Date IS NULL
            OR Return_Date >= Issue_Date
        ),

    CONSTRAINT chk_fine_amount
        CHECK (Fine_Amount >= 0)
);
GO

USE library_db;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

USE library_db;
