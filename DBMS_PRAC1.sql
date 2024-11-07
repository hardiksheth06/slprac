create database DBMS1;
use DBMS1;

create table branch(branch_name varchar(20) primary key, branch_city varchar(20), assets  int(20)); 
insert into branch values('Akurdi','Pune',200000); 
insert into branch values('Nigdi','PCMC',300000); 
insert into branch values('Wakad','Pune',100000); 
insert into branch values('Chinchwad','PCMC',400000); 
insert into branch values('Sangvi','Pune',230000); 
select * from branch; 

create table account(acc_no int(10) primary key, branch_name varchar(20), balance int(20),  constraint FK_5 foreign key(branch_name) references branch(branch_name) on delete cascade);  
insert into account values(1001,'Akurdi',15000); 
insert into account values(1002,'Nigdi',11000); 
insert into account values(1003,'Chinchwad',20000); 
insert into account values(1004,'Wakad',10000); 
insert into account values(1005,'Akurdi',14000); 
insert into account values(1006,'Nigdi',17000); 
select * from account; 

create table loan(loan_no int(20) primary key, branch_name varchar(20), amount int(20),  CONSTRAINT FK_6 FOREIGN KEY (branch_name) REFERENCES branch(branch_name)  ON DELETE CASCADE); 
insert into loan values(2001,'Akurdi',2000); 
insert into loan values(2002,'Nigdi',1200); 
insert into loan values(2003,'Akurdi',1400); 
insert into loan values(2004,'Wakad',1350); 
insert into loan values(2005,'Chinchwad',1490); 
insert into loan values(2006,'Akurdi',12300); 
insert into loan values(2007,'Akurdi',14000);
select * from loan; 

create table customer(cust_name varchar(20) primary key, cust_street varchar(20), cust_city  varchar(20)); 
insert into customer values('Rutuja','JM road','Pune'); 
insert into customer values('Alka','Senapati road','Pune'); 
insert into customer values('Samiksha','Savedi road','PCMC'); 
insert into customer values('Trupti','JLakshmi road','Pune'); 
insert into customer values('Mahima','Pipeline road','PCMC'); 
insert into customer values('Ayushi','FC road','Pune'); 
insert into customer values('Priti','Camp road','PCMC'); 
select * from customer; 

create table depositor (cust_name varchar(20), acc_no integer(10),  
CONSTRAINT FK_1 FOREIGN KEY (cust_name) REFERENCES customer(cust_name) ON  DELETE CASCADE,  
CONSTRAINT FK_2 FOREIGN KEY (acc_no) REFERENCES account(acc_no) ON DELETE  CASCADE); 
insert into depositor values ('Rutuja',1005); 
insert into depositor values ('Trupti',1002); 
insert into depositor values ('Samiksha',1004); 
select * from depositor; 

create table borrower (cust_name varchar(20), loan_no integer(10) , CONSTRAINT FK_3  FOREIGN KEY (cust_name) REFERENCES customer(cust_name) ON DELETE CASCADE,  CONSTRAINT FK_4 FOREIGN KEY (loan_no) REFERENCES loan(loan_no) ON DELETE  CASCADE); 
insert into borrower values('Mahima',2005); 
insert into borrower values('Trupti',2002); 
insert into borrower values('Rutuja',2004); 
insert into borrower values('Ayushi',2006); 
insert into borrower values('Priti',2007); 
select * from borrower; 

/* Q1 */
select distinct(branch_name) from loan; 

/* Q2 */
select loan_no,amount from loan where branch_name='Akurdi' and amount>12000;

/* Q3 */
select l.loan_no,b.cust_name,l.amount from loan l,borrower b where l.loan_no=b.loan_no; 

/* Q4 */
select b.cust_name from borrower b, loan l where l.loan_no=b.loan_no and l.branch_name='Akurdi' order by b.cust_name ASC;

/* Q5 */
(select cust_name from depositor ) union (select cust_name from borrower);

/* Q6 */
select cust_name from depositor where cust_name in (select cust_name from borrower) ; 

/* Q7 */
select cust_name from depositor where cust_name not in (select cust_name from borrower) ; 

/* Q8 */
select avg(balance) from Account where branch_name='Akurdi';

/* Q9 */
SELECT avg(balance) AS branchAverage, branch_name FROM account group by branch_name; 

/* Q10 */
select a.branch_name,count(distinct(d.cust_name)) from account a,depositor d where a.acc_no=d.acc_no group by branch_name;

/* Q11 */
SELECT avg(balance) AS branchAverage, branch_name FROM account group by branch_name having branchAverage > 12000;

/* Q12 */
select count(*) from customer;

/* Q13 */
select sum(amount) from loan;

/* Q14 */
delete from loan where amount between 1300 and 1500;

/* Q15 */
delete from Account where branch_name='Nigdi';
