create database DBMS4;
use DBMS4;

CREATE TABLE Stud (
    Roll INT PRIMARY KEY,
    Att DECIMAL(5,2),
    Status VARCHAR(2)
);
INSERT INTO Stud (Roll, Att, Status) VALUES
(101, 80.5, 'ND'),
(102, 65.0, 'D'),
(103, 92.3, 'ND'),
(104, 78.9, 'ND'),
(105, 55.7, 'D');

CREATE TABLE account_master (
    account_no INT PRIMARY KEY,
    balance DECIMAL(10,2)
);
INSERT INTO account_master (account_no, balance) VALUES
(1001, 25000.00),
(1002, 15000.50),
(1003, 50000.75),
(1004, 8000.25),
(1005, 100000.00);

CREATE TABLE Borrower (
    Roll_no INT PRIMARY KEY,
    Name VARCHAR(100),
    Date_of_Issue DATE,
    Name_of_Book VARCHAR(100),
    Status CHAR(1)
);

CREATE TABLE Fine (
    Roll_no INT,
    Date DATE,
    Amt DECIMAL(10,2)
);

INSERT INTO Borrower (Roll_no, Name, Date_of_Issue, Name_of_Book, Status) VALUES
(201, 'Rahul Sharma', '2023-08-15', 'Indian History', 'I'),
(202, 'Priya Patel', '2023-08-20', 'Advanced Mathematics', 'I'),
(203, 'Amit Singh', '2023-09-01', 'Computer Science Fundamentals', 'I'),
(204, 'Neha Gupta', '2023-09-10', 'English Literature', 'I'),
(205, 'Vijay Kumar', '2023-09-15', 'Physics for Beginners', 'I');

-- Q1
DELIMITER //
CREATE PROCEDURE check_attendance(IN p_roll INT)
BEGIN
    DECLARE v_attendance DECIMAL(5,2);
    DECLARE v_status VARCHAR(2);
    
    SELECT Att INTO v_attendance
    FROM Stud
    WHERE Roll = p_roll;
  
    IF v_attendance < 75 THEN
        SET v_status = 'D';
        SELECT 'Term not granted' AS message;
    ELSE
        SET v_status = 'ND';
        SELECT 'Term granted' AS message;
    END IF;
    UPDATE Stud SET Status = v_status WHERE Roll = p_roll;
END //
DELIMITER ;

-- Q2
DELIMITER //
CREATE PROCEDURE withdraw_amount(
    IN p_account_no INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE v_balance DECIMAL(10,2);
    
    SELECT balance INTO v_balance
    FROM account_master
    WHERE account_no = p_account_no;
     IF p_amount > v_balance THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient funds';
    ELSE
        UPDATE account_master
        SET balance = balance - p_amount
        WHERE account_no = p_account_no;
        SELECT CONCAT('Withdrawal successful. New balance: ', (v_balance - p_amount)) AS message;
    END IF;
END //
DELIMITER ;

-- Q3
CREATE TABLE Borrower (
    Roll_no INT PRIMARY KEY,
    Name VARCHAR(100),
    Date_of_Issue DATE,
    Name_of_Book VARCHAR(100),
    Status CHAR(1)
);

CREATE TABLE Fine (
    Roll_no INT,
    Date DATE,
    Amt DECIMAL(10,2)
);

DELIMITER //

CREATE PROCEDURE calculate_fine(
    IN p_roll_no INT,
    IN p_book_name VARCHAR(100)
)
BEGIN
    DECLARE v_issue_date DATE;
    DECLARE v_days INT;
    DECLARE v_fine DECIMAL(10,2);
    
    SELECT Date_of_Issue INTO v_issue_date FROM Borrower
    WHERE Roll_no = p_roll_no AND Name_of_Book = p_book_name AND Status = 'I';
    
    SET v_days = DATEDIFF(CURDATE(), v_issue_date);

    IF v_days BETWEEN 15 AND 30 THEN
        SET v_fine = v_days * 5;
    ELSEIF v_days > 30 THEN
        SET v_fine = (30 * 5) + ((v_days - 30) * 50);
    ELSE
        SET v_fine = 0;
    END IF;
    
   UPDATE Borrower SET Status = 'R'
    WHERE Roll_no = p_roll_no AND Name_of_Book = p_book_name;
    
    IF v_fine > 0 THEN
        INSERT INTO Fine (Roll_no, Date, Amt)
        VALUES (p_roll_no, CURDATE(), v_fine);
    END IF;
    
    SELECT CONCAT('Book returned. Fine amount: ', v_fine) AS message;
    
    -- Exception handling
    IF v_issue_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Book not issued or already returned';
    END IF;
END //
DELIMITER ;

