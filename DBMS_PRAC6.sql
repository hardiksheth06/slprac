-- Q1
CREATE TABLE bank_accounts (
    account_id INT PRIMARY KEY,
    account_holder_name varchar(100),
    status varchar(10),
    last_txn_date DATE
);

INSERT INTO bank_accounts VALUES (1, 'Amit Sharma', 'inactive',   CURDATE() - INTERVAL 400 DAY); 
INSERT INTO bank_accounts VALUES (2, 'Priya Singh', 'active',   CURDATE() - INTERVAL 200 DAY); 
INSERT INTO bank_accounts VALUES (3, 'Rahul Gupta', 'inactive',   CURDATE() - INTERVAL 370 DAY); 
INSERT INTO bank_accounts VALUES (4, 'Neha Desai', 'inactive',   CURDATE() - INTERVAL 300 DAY); 
INSERT INTO bank_accounts VALUES (5, 'Vikram Reddy', 'inactive',   CURDATE() - INTERVAL 800 DAY); 

DELIMITER //
CREATE PROCEDURE activate_inactive_accounts()
BEGIN
  DECLARE v_affected_row INT DEFAULT 0;
  
  UPDATE bank_accounts set status = "active" WHERE last_txn_date < CURDATE() - INTERVAL 365 DAY;
  
  SET v_affected_row = ROW_COUNT();
  
  IF v_affected_row > 0 THEN
  	SELECT CONCAT(v_affected_row, " accounts have been activated") as message;
  ELSE
  	SELECT "No accounts have been activated" as message;
  END IF;
END //
DELIMITER ;
CALL activate_inactive_accounts();

-- Q2
CREATE TABLE EMP (
    E_no INT PRIMARY KEY,
    Salary DECIMAL(10,2)
);
CREATE TABLE increment_salary (
    E_no INT,
    Salary DECIMAL(10,2),
    FOREIGN KEY (E_no) REFERENCES EMP(E_no) ON DELETE CASCADE
);
INSERT INTO EMP (E_no, Salary) VALUES
(101, 25000.00),
(102, 30000.00),
(103, 18000.00),
(104, 45000.00),
(105, 22000.00),
(106, 50000.00),
(107, 16000.00);
SELECT * FROM EMP;
DELIMITER $$
CREATE PROCEDURE Update_Salary_Increment()
BEGIN
    DECLARE v_E_no INT;
    DECLARE v_Salary DECIMAL(10,2);
    DECLARE avg_salary DECIMAL(10,2);
    DECLARE done INT DEFAULT 0;
    DECLARE emp_cursor CURSOR FOR
        SELECT E_no, Salary FROM EMP WHERE Salary < avg_salary;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    SELECT AVG(Salary) INTO avg_salary FROM EMP;
    
    OPEN emp_cursor;
    
    read_loop: LOOP
        FETCH emp_cursor INTO v_E_no, v_Salary;
        
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        
        UPDATE EMP
        SET Salary = v_Salary * 1.10
        WHERE E_no = v_E_no;
        
        INSERT INTO increment_salary (E_no, Salary)
        VALUES (v_E_no, v_Salary * 1.10);
    END LOOP;
    
    CLOSE emp_cursor;
END$$
DELIMITER ;

CALL Update_Salary_Increment();

SELECT * FROM EMP;

SELECT * FROM increment_salary;

-- Q3
CREATE TABLE stud21 (
    roll INT(4) PRIMARY KEY,
    att INT(4),
    status VARCHAR(1)
);

CREATE TABLE d_stud (
    roll INT(4),
    att INT(4),
    FOREIGN KEY (roll) REFERENCES stud21(roll)
);
INSERT INTO stud21 (roll, att, status) VALUES
(1001, 80, 'P'),
(1002, 65, 'P'),
(1003, 72, 'P'),
(1004, 85, 'P'),
(1005, 60, 'P'),
(1006, 90, 'P'),
(1007, 74, 'P');

SELECT * FROM stud21;
DELIMITER $$
CREATE PROCEDURE Update_Detained_Students()
BEGIN
    DECLARE v_roll INT;
    DECLARE v_att INT;
    DECLARE done INT DEFAULT 0;
    
    DECLARE stud_cursor CURSOR FOR
        SELECT roll, att FROM stud21 WHERE att < 75;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN stud_cursor;
    
    read_loop: LOOP
        FETCH stud_cursor INTO v_roll, v_att;
        
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        
        UPDATE stud21
        SET status = 'D'
        WHERE roll = v_roll;
        
        INSERT INTO d_stud (roll, att)
        VALUES (v_roll, v_att);
    END LOOP;
    
    CLOSE stud_cursor;
END$$
DELIMITER ;

CALL Update_Detained_Students();

SELECT * FROM stud21;

SELECT * FROM d_stud;

-- Q4
CREATE TABLE O_RollCall (
    roll INT PRIMARY KEY,
    name VARCHAR(50),
    attendance INT
);

CREATE TABLE N_RollCall (
    roll INT PRIMARY KEY,
    name VARCHAR(50),
    attendance INT
);
INSERT INTO O_RollCall (roll, name, attendance) VALUES
(1001, 'Amit Sharma', 85),
(1002, 'Ravi Patel', 90),
(1003, 'Sunita Verma', 78),
(1004, 'Kavita Mehra', 80);

INSERT INTO N_RollCall (roll, name, attendance) VALUES
(1002, 'Ravi Patel', 90),    
(1005, 'Manish Singh', 82),  
(1006, 'Pooja Raj', 88),     
(1001, 'Amit Sharma', 85);   

SELECT * FROM O_RollCall;
SELECT * FROM N_RollCall;
DELIMITER $$
CREATE PROCEDURE Merge_RollCall_Data()
BEGIN
    DECLARE v_roll INT;
    DECLARE v_name VARCHAR(50);
    DECLARE v_attendance INT;
    DECLARE done INT DEFAULT 0;
    
    DECLARE rollcall_cursor CURSOR FOR
        SELECT roll, name, attendance FROM N_RollCall;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN rollcall_cursor;
    
    read_loop: LOOP
        FETCH rollcall_cursor INTO v_roll, v_name, v_attendance;
        
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        
        IF NOT EXISTS (SELECT 1 FROM O_RollCall WHERE roll = v_roll) THEN
            
            INSERT INTO O_RollCall (roll, name, attendance)
            VALUES (v_roll, v_name, v_attendance);
        END IF;
    END LOOP;
    
    CLOSE rollcall_cursor;
END$$
DELIMITER ;

CALL Merge_RollCall_Data();

SELECT * FROM O_RollCall;

-- Q5
drop table increment_salary;
drop table EMP;

CREATE TABLE EMP (
    e_no INT PRIMARY KEY,
    d_no INT,
    Salary DECIMAL(10,2)
);

CREATE TABLE dept_salary (
    d_no INT PRIMARY KEY,
    Avg_salary DECIMAL(10,2)
);

INSERT INTO EMP (e_no, d_no, Salary) VALUES
(101, 1, 25000.00),
(102, 1, 30000.00),
(103, 2, 20000.00),
(104, 2, 22000.00),
(105, 3, 45000.00),
(106, 3, 40000.00),
(107, 1, 28000.00),
(108, 2, 24000.00),
(109, 3, 35000.00);

SELECT * FROM EMP;

INSERT INTO EMP (e_no, d_no, Salary) VALUES
(101, 1, 25000.00),
(102, 1, 30000.00),
(103, 2, 20000.00),
(104, 2, 22000.00),
(105, 3, 45000.00),
(106, 3, 40000.00),
(107, 1, 28000.00),
(108, 2, 24000.00),
(109, 3, 35000.00);

SELECT * FROM EMP;
DELIMITER $$
CREATE PROCEDURE Insert_Dept_Avg_Salary()
BEGIN
    DECLARE v_d_no INT;
    DECLARE v_avg_salary DECIMAL(10,2);
    DECLARE done INT DEFAULT 0;
    
    DECLARE dept_cursor CURSOR FOR
        SELECT DISTINCT d_no FROM EMP;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN dept_cursor;
    
    read_loop: LOOP
        FETCH dept_cursor INTO v_d_no;
        
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        
        SELECT AVG(Salary) INTO v_avg_salary
        FROM EMP
        WHERE d_no = v_d_no;
        
        INSERT INTO dept_salary (d_no, Avg_salary)
        VALUES (v_d_no, v_avg_salary);
    END LOOP;
    
    CLOSE dept_cursor;
END$$
DELIMITER ;

CALL Insert_Dept_Avg_Salary();

SELECT * FROM dept_salary;

-- Q6
drop table d_stud;
drop table stud21;

CREATE TABLE stud21 (
    roll INT(4) PRIMARY KEY,
    att INT(4),
    status VARCHAR(1)
);

CREATE TABLE d_stud (
    roll INT(4),
    att INT(4),
    FOREIGN KEY (roll) REFERENCES stud21(roll)
);

INSERT INTO stud21 (roll, att, status) VALUES
(1001, 80, 'P'),  
(1002, 65, 'P'),  
(1003, 72, 'P'),  
(1004, 85, 'P'),  
(1005, 60, 'P'),  
(1006, 90, 'P'),  
(1007, 74, 'P');  

SELECT * FROM stud21;
DELIMITER $$
CREATE PROCEDURE Update_Detained_Students()
BEGIN
    DECLARE v_roll INT;
    DECLARE v_att INT;
    DECLARE done INT DEFAULT 0;
    
    DECLARE stud_cursor CURSOR FOR
        SELECT roll, att FROM stud21 WHERE att < 75;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN stud_cursor;
    
    read_loop: LOOP
        FETCH stud_cursor INTO v_roll, v_att;
        
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;
        
        UPDATE stud21
        SET status = 'D'
        WHERE roll = v_roll;
        
        INSERT INTO d_stud (roll, att)
        VALUES (v_roll, v_att);
    END LOOP;
    
    CLOSE stud_cursor;
END$$
DELIMITER ;

CALL Update_Detained_Students();

SELECT * FROM stud21;	

SELECT * FROM d_stud;
