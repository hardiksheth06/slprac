create database DBMS2;
use DBMS2;


-- Q1
CREATE TABLE cust_mstr (
    cust_no INT PRIMARY KEY,
    fname VARCHAR(50),
    lname VARCHAR(50)
);

CREATE TABLE add_dets (
    code_no INT PRIMARY KEY,
    add1 VARCHAR(100),
    add2 VARCHAR(100),
    state VARCHAR(50),
    city VARCHAR(50),
    pincode VARCHAR(10),
    cust_no INT,
    FOREIGN KEY (cust_no) REFERENCES cust_mstr(cust_no)
);

INSERT INTO cust_mstr VALUES
(1, 'Raj', 'Kumar'),
(2, 'Priya', 'Sharma'),
(3, 'Amit', 'Patel');

INSERT INTO add_dets VALUES
(101, '123 MG Road', 'Koramangala', 'Karnataka', 'Bangalore', '560034', 1),
(102, '456 Anna Salai', 'T Nagar', 'Tamil Nadu', 'Chennai', '600017', 2),
(103, '789 SV Road', 'Bandra', 'Maharashtra', 'Mumbai', '400050', 3);

SELECT c.fname, c. Iname, a. * FROM cust mstr c
JOIN add dets a ON c.cust no = a.cust no
WHERE c.fname = 'xyz' AND c.lname = 'pqr' ;

-- Q2
CREATE TABLE acc_fd_cust_dets (
    codeno INT PRIMARY KEY,
    acc_fd_no VARCHAR(20),
    cust_no INT,
    FOREIGN KEY (cust_no) REFERENCES cust_mstr(cust_no)
);

CREATE TABLE fd_dets (
    fd_sr_no VARCHAR(20) PRIMARY KEY,
    amt DECIMAL(10, 2)
);

INSERT INTO acc_fd_cust_dets VALUES
(201, 'FD001', 1),
(202, 'FD002', 2),
(203, 'FD003', 3);

INSERT INTO fd_dets VALUES
('FD001', 10000.00),
('FD002', 4000.00),
('FD003', 7500.00);

SELECT c.cust_no, c.fname, c.lname, fd.amt FROM cust mstr c
JOIN acc fd cust dets afc ON c.cust_no = afc.cust_no
JOIN fd dets fd ON afc.acc_fd_no = fd.fd_sr_no
WHERE fd.amt > 5000;

-- Q3
CREATE TABLE branch_mstr (
    b_no INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE emp_mstr (
    emp_no INT PRIMARY KEY,
    f_name VARCHAR(50),
    l_name VARCHAR(50),
    m_name VARCHAR(50),
    dept VARCHAR(50),
    desg VARCHAR(50),
    branch_no INT,
    FOREIGN KEY (branch_no) REFERENCES branch_mstr(b_no)
);

INSERT INTO branch_mstr VALUES
(1, 'Bangalore Main'),
(2, 'Chennai Central'),
(3, 'Mumbai HQ');

INSERT INTO emp_mstr VALUES
(1001, 'Vikram', 'Singh', 'Kumar', 'Sales', 'Manager', 1),
(1002, 'Neha', 'Gupta', 'Rani', 'HR', 'Executive', 2),
(1003, 'Rahul', 'Desai', 'Mohan', 'IT', 'Developer', 3);

SELECT e.* , b.name AS branch_name FROM emp_mstr e
JOIN branch_mstr b ON e.branch_no = b.b_no;

-- Q4
CREATE TABLE cntc_dets (
    code_no INT PRIMARY KEY,
    cntc_type VARCHAR(20),
    cntc_data VARCHAR(100),
    emp_no INT,
    FOREIGN KEY (emp_no) REFERENCES emp_mstr(emp_no)
);

INSERT INTO cntc_dets VALUES
(301, 'Mobile', '9876543210', 1001),
(302, 'Email', 'neha.gupta@example.com', 1002),
(303, 'Landline', '022-12345678', 1003); 

SELECT e.* , c.cntc_type, c.cntc_data FROM emp_mstr e
LEFT OUTER JOIN cntc_dets c ON e.emp_no = c.emp_no; --Left Outer Join

SELECT e. * , c.cntc_type, c.cntc_data FROM cntc_dets c
RIGHT JOIN emp_mstr e ON c.emp_no = e.emp_no; --Right Join

-- Q5
ALTER TABLE branch_mstr ADD COLUMN pincode VARCHAR(10);
UPDATE branch_mstr SET pincode = '560034' WHERE b_no = 1; -- Update table with some PINCODES
UPDATE branch_mstr SET pincode = '6000171' WHERE b_no = 2;
UPDATE branch_mstr SET pincode = '400051' WHERE b_no = 3;

SELECT * FROM cust_mstr c
JOIN add_dets a ON c.cust_no = a.cust_no
WHERE a.pincode NOT IN (SELECT DISTINCT pincode FROM branch_mstr) ;

-- Q6
Not Done 😜