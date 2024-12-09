# 1..fetch domain 
create table customer_tbl (id int, email varchar(50));
insert into customer_tbl values (1,'abc@gmail.com'),(2,'xyz@hotmail.com'),
(3,'pqr@outlook.com');
select substring_index(email,'@',-1) as domain from customer_tbl;

# 2..Get Employee Name whose salary is greater than Manager Salary.

CREATE TABLE employees_tbl (empid INT,ename VARCHAR(50),salary INT,managerid INT);
INSERT INTO employees_tbl VALUES (1, 'John', 50000, NULL), (2, 'Alice', 40000, 1),(3, 'Bob', 70000, 1), (4, 'Emily', 55000, NULL), (5, 'Charlie', 65000, 4),
(6, 'David', 50000, 4);

select e2.ename from employees_tbl as e1 left join
employees_tbl as e2 on e1.empid = e2.managerid
where e1.salary <  e2.salary;

#3.We need to Find the Currency Exchange rate at beginning and ending of month.
CREATE TABLE exchange_rates (
    currency_code VARCHAR(3),
    date DATE,
    currency_exchange_rate DECIMAL(10, 2)
);
INSERT INTO exchange_rates (currency_code, date, currency_exchange_rate) VALUES
('USD', '2024-06-01', 1.20),
('USD', '2024-06-02', 1.21),
('USD', '2024-06-03', 1.22),
('USD', '2024-06-04', 1.23),
('USD', '2024-07-01', 1.25),
('USD', '2024-07-02', 1.26),
('USD', '2024-07-03', 1.27),
('EUR', '2024-06-01', 1.40),
('EUR', '2024-06-02', 1.41),
('EUR', '2024-06-03', 1.42),
('EUR', '2024-06-04', 1.43),
('EUR', '2024-07-01', 1.45),
('EUR', '2024-07-02', 1.46),
('EUR', '2024-07-03', 1.47);

select * from exchange_rates;
select currency_code,monthname(date) ,min(currency_exchange_rate) as minimum_rate,
max(currency_exchange_rate) as maximum_rate
from exchange_rates group by currency_code,monthname(date) ;

# 4..2nd max salary
CREATE TABLE department (deptid INT, deptname VARCHAR(50));
INSERT INTO department VALUES (101, 'HR'), (102, 'Finance'), (103, 'Marketing');

CREATE TABLE employee (empid INT, salary INT, deptid INT);
INSERT INTO employee VALUES (1, 70000, 101),(2, 50000, 101),(3, 60000, 101),(4, 65000, 102),(5, 65000, 102),(6, 55000, 102),(7, 60000, 103),(8, 70000, 103),(9, 80000, 103);

with t1 as (
select *,dense_rank() over(partition by deptname order by salary desc) as output from department as d1 join
employee as e1 using(deptid))
select * from t1 where output=2;

#5..We need to Find the percentage of Genders.

CREATE TABLE employees_tbl (eid INT, ename VARCHAR(50), gender VARCHAR(10));

INSERT INTO employees_tbl VALUES (1, 'John Doe', 'Male'),(2, 'Jane Smith', 'Female'),
(3, 'Michael Johnson', 'Male'),(4, 'Emily Davis', 'Female'),(5, 'Robert Brown', 'Male'),
(6, 'Sophia Wilson', 'Female'),(7, 'David Lee', 'Male'),(8, 'Emma White', 'Female'),
(9, 'James Taylor', 'Male'),(10, 'William Clark', 'Male');
select * from employees_tbl;
SELECT 
    ROUND(SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS male_perc,
    ROUND(SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fem_perc
FROM 
    employees_tbl;
    
    
# 6...We need to Find product wise total amount, including products with no sales.
create table products (pid int, pname varchar(50), price int);
insert into products values (1, 'A', 1000),(2, 'B', 400),(3, 'C', 500);

create table transcations (pid int, sold_date DATE, qty int, amount int);
insert into transcations values (1, '2024-02-01', 2, 2000),(1, '2024-03-01', 4, 4000),
(1, '2024-03-15', 2, 2000),(3, '2024-04-24', 3, 1500),(3, '2024-05-16', 5, 2500);


select * from products;
select * from transcations;

select p1.pid,p1.pname,month(sold_date) as month,sum(amount)as total_sales from products as p1  join transcations as t1 using(pid)
group by p1.pid,p1.pname,month(sold_date);

#7..get 2nd wed of current date
select date_add((last_day(date((curdate()- interval 1 month)))),interval 11 day) as 2nd_wed_of_dec_2024;

#8..trasnform rows into columns
CREATE TABLE sales_data (
    month varchar(10),
    category varchar(20),
    amount numeric
);

-- Insert data
INSERT INTO sales_data (month, category, amount) VALUES
    ('January', 'Electronics', 1500),
    ('January', 'Clothing', 1200),
    ('February', 'Electronics', 1800),
    ('February', 'Clothing', 1300),
    ('March', 'Electronics', 1600),
    ('March', 'Clothing', 1100),
    ('April', 'Electronics', 1700),
    ('April', 'Clothing', 1400);
select * from sales_data;

select month, sum(case when category='electronics' then amount else 0 end) as electronics,
 sum(case when category='Clothing' then amount else 0 end) AS CLOTH
 from sales_data group by month order by FIELD(month, 'January', 'February', 'March', 'April');
 
 #9..new customer acquisiotion 
 CREATE TABLE orders 
(
    orderDate date,
    customer VARCHAR(512),
    amount INT
);

INSERT INTO orders (orderDate, customer, amount) VALUES ('2024-01-01', 'Customer_1', '200');
INSERT INTO orders (orderDate, customer, amount) VALUES ('2024-01-01', 'Customer_2', '300');
INSERT INTO orders (orderDate, customer, amount) VALUES ('2024-02-01', 'Customer_1', '100');
INSERT INTO orders (orderDate, customer, amount) VALUES ('2024-02-01', 'Customer_3', '105');
INSERT INTO orders (orderDate, customer, amount) VALUES ('2024-03-01', 'Customer_5', '109');
INSERT INTO orders (orderDate, customer, amount) VALUES ('2024-03-01', 'Customer_4', '100');
INSERT INTO orders (orderDate, customer, amount) VALUES ('2024-04-01', 'Customer_3', '103');
INSERT INTO orders (orderDate, customer, amount) VALUES ('2024-04-01', 'Customer_5', '105');
INSERT INTO orders (orderDate, customer, amount) VALUES ('2024-04-01', 'Customer_6', '100');
select * from orders;

select orderDate,count(distinct customer) as new_cust
from orders as o 
where o.orderDate = ( select 
min(orderDate) from Orders where customer = o.customer
)
 group by orderDate
 order by orderDate;
 
 # 10...total shipments between two countrie
 
 CREATE TABLE Shipments
(
 A varchar(10),
 B varchar(10),
 Shipments int
);

INSERT INTO Shipments
VALUES
('India','Japan',200),
('Japan','India',150),
('India','UAE',300),
('UAE','India',200),
('India','US',1000),
('US','India',800);

select * from Shipments;

SELECT 
    LEAST(A, B) AS A,
    GREATEST(A, B) AS B,
    SUM(Shipments) AS Total_Shipments
FROM shipments
GROUP BY 
    LEAST(A, B),
    GREATEST(A, B);
    
# 11... Find unique combination of records in output
CREATE TABLE routes (Origin VARCHAR(50), Destination VARCHAR(50));

INSERT INTO routes VALUES ('Bangalore', 'Chennai'), ('Chennai', 'Bangalore'), ('Pune', 'Chennai'), ('Delhi', 'Pune');
select * from routes;

SELECT 
    LEAST(Origin, Destination) AS Place1,
    GREATEST(Origin, Destination) AS Place2
FROM routes
GROUP BY 
    LEAST(Origin, Destination),
    GREATEST(Origin, Destination);
    
#12....We need to Find department wise minimum salary empname and maximum salary empname .
CREATE TABLE emps_tbl (emp_name VARCHAR(50), dept_id INT, salary INT);

INSERT INTO emps_tbl VALUES ('Siva', 1, 30000), ('Ravi', 2, 40000), ('Prasad', 1, 50000), ('Sai', 2, 20000), ('Anna', 2, 10000);
with cte as (
select *,row_number() over(partition by dept_id order by salary asc) as ranking ,
row_number() over(partition by dept_id order by salary desc) as max_ranking 
from emps_tbl)
select emp_name as min_sal_empname
 from cte where ranking=1
 union all
select emp_name as max_sal_empname
 from cte where max_ranking=1;


#13...
CREATE TABLE cards (card_number BIGINT);
INSERT INTO cards VALUES (1234567812345678),(2345678923456789),(3456789034567890);

select concat(repeat('*',12),right(card_number,4)) as card_num from cards;

#14...find out names of emp whose salary are same


CREATE TABLE Employee (employee_id INT,ename VARCHAR(50),salary INT);
INSERT INTO Employee VALUES (3, 'Bob', 60000),(4, 'Diana', 70000),(5, 'Eve', 60000),(6, 'Frank', 80000),(7, 'Grace', 70000),(8, 'Henry', 90000);

SELECT 
    ename
FROM 
    employee
WHERE 
    salary IN (
        SELECT 
            salary
        FROM 
            employee
        GROUP BY 
            salary
        HAVING 
            COUNT(*) > 1
    );
    
#15..We need to find running total

CREATE TABLE transactions_1308 (transaction_id BIGINT, type VARCHAR(50), amount INT,transaction_date DATE);
INSERT INTO transactions_1308 VALUES (53151, 'deposit', 178, '2022-07-08'), (29776, 'withdrawal', 25, '2022-07-08'),(16461, 'withdrawal', 45, '2022-07-08'),(19153, 'deposit', 65, '2022-07-10'),(77134, 'deposit', 32, '2022-07-10');

WITH cte AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY transaction_date ORDER BY (SELECT NULL)) AS rn
    FROM transactions_1308
)
SELECT *,
       SUM(CASE WHEN type = 'deposit' THEN amount ELSE -amount END) OVER (ORDER BY transaction_date, rn) AS total
FROM cte;
