#1..perform joins
create table table1(id int);
insert into table1 values (1), (1),(2),(null),(null);
create table table2(id int);
insert into table2 values (1),(3),(null);

select * from table1 join
table2 using(id);

select * from table1 left join
table2 using(id);

select * from table1 right join
table2 using(id);


#2.. find total of top 2 subject marks by each student
create table students(sname varchar(50), sid varchar(50), marks int);
insert into students values('A','X',75),('A','Y',75),('A','Z',80),('B','X',90),('B','Y',91),('B','Z',75);

with cte as (
select *,row_number() over(partition by sname order by marks desc) as total from students)
select sname,sum(marks) from cte
where  total <= 2
group by sname;


#3...display maxid..ignore if maxid has double entries
create table employees (id int);
insert into employees values (2),(5),(6),(6),(7),(8),(8);
with cte as
(
select id,count(*) as times from employees 
group by id
having times=1)
select max(id) from cte;

#4...create table and include lowest salary
create table tablea (empid int, empname varchar(50), salary int);
create table tableb (empid int, empname varchar(50), salary int);

insert into tablea values(1,'AA',1000),(2,'BB',300);
insert into tableb values(2,'BB',400),(3,'CC',100);

with temp as (
select a.empid,a.empname,a.salary from tablea as a left join tableb as b
using(empid)
union all
select b.empid,b.empname,b.salary from tablea as a right join tableb as b
using(empid))
select empid, empname, salary from (
select *,rank() over(partition by empid order by salary) as output from temp
) as ranked
where output=1;


#5..Calculating Periodic Sales from Year-to-Date (YTD) 
create table sales(month varchar(50), ytd_sales int, monthnum int);
insert into sales values('jan',15,1),('feb',22,2),('mar',35,3),('apr',45,4),('may',60,5);
select *,ytd_sales - lag(ytd_sales,1,0) over(order by monthnum) as prev_month from sales;

#6..india and shrilanka should be on top
create table happiness_tbl (ranking int, country varchar(50));
insert into happiness_tbl values (1,'Finland'),(2,'Denmark'),(3,'Iceland'),
(4,'Israel'),(5,'Netherlands'),(6,'Sweden'),(7,'Norway'),(8,'Switzerland'),
(9,'Luxembourg'),(128,'Srilanka'),(126,'India')
;
select country,case when country in('India', 'Srilanka') then 1 
else 2 end as output
from happiness_tbl
order by output;

#7..give grade to students
create table studnts_tbl (sname varchar(50), marks int);
insert into studnts_tbl values ('A', 75),('B', 30),('C', 55),('A', 60),('D', 91),
('B', 19),('G', 36),('S', 65),('K', 49);

select *,case when marks>=70 then 'excellent'
when marks>=50 and marks<70 then 'good'
else 'low' end as grade
from studnts_tbl;


#8..retrieve Seat IDs for consecutive three Free Seats in a Cinema"

create table cinema_tbl (seat_id int, free int);
insert into cinema_tbl values (1,1),(2,0),(3,1),(4,0),(5,1),(6,1),(7,1),(8,0),(9,1),(10,1);

with cet as(
select *,lag(free,1,0) over(order by seat_id) as pre_free,
lead(free,1,0) over(order by seat_id) as nxt_free from cinema_tbl)
select distinct seat_id from cet
where free=1 and pre_free=1 and nxt_free=1;

#9..replace all null values with previous one
create table brands (category varchar(50), brand_name varchar(50));
insert into brands values ('chocolates', '5-star'),(NULL, 'dairy milk'),(NULL, 'perk'),(NULL, 'eclair'),('Biscuits', 'Britania'),(NULL, 'good day'),(NULL, 'boost');
select * from brands;
with t1 as (
select *,row_number() over(order by(select null))as rnum from brands),
 t2 as (
select *,count(category) over(order by rnum) as cnt from t1)
select brand_name,first_value(category) over(partition by cnt) as output from t2;


#10..find total weekend working hours
CREATE TABLE emp_tbl (id datetime, empid int);

INSERT INTO emp_tbl VALUES ('2024-01-13 09:25:00', 10),('2024-01-13 19:35:00', 10),('2024-01-16 09:10:00', 10),
('2024-01-16 18:10:00', 10),('2024-02-11 09:07:00', 10),('2024-02-11 19:20:00', 10),('2024-02-17 08:40:00', 17),
('2024-02-17 18:04:00', 17),('2024-03-23 09:20:00', 10),('2024-03-23 18:30:00', 10);

with t1 as (
select *,dayofweek(id) as day_of_week from emp_tbl),
t2 as (
select empid,id as start_time ,lead(id) over(partition by empid order by id) as end_time,day_of_week
from t1 where day_of_week in (1,7)),
t3 as (
select *,timestampdiff(minute,start_time,end_time)/60.0 as working_hours
from t2 where end_time is not null
)
select empid,avg(working_hours) from t3
group by empid;

# 11 ...city to destination

Create table City(
id int,
CityName varchar(100)
);
insert into City
(id ,CityName)
values
(1,'Delhi'),
(2,'Mumbai'),
(3,'Kolkata'),
(4,'Chennai'),
(5,'Hyderabad');

select src.CityName as source,destination.CityName as destin from city as src
join city destination on
src.id<destination.id;

# 12..split based on comma

Create table Product1(
id int,
tags varchar(500)
);

insert into Product1
(id,tags)
values
(1,'Electronic, Gadgets'),
(2,'Clothing, Fashion, Furniture'),
(3,'Sports, Fitness');

 select * from Product1;
 SELECT 
        id,
        SUBSTRING_INDEX(tags, ', ', 1) AS tag,
        SUBSTRING_INDEX(tags, ', ', -1) AS remaining
    FROM Product1;
    with t1 as(
    select id,substring_index(tags,',',1) as tag from product1),
    t2 as (
    select id,
    substring_index(tags,',',-1) as remaining from product1)
    select * from t1
    union all
    select * from t2;
    
    
# 13..merge rows with delimiteres
    
    CREATE TABLE tbl_orders (
    OrderID INT,
    CustomerID INT,
    ProductName VARCHAR(50)
);

-- Insert sample data into the Orders table
INSERT INTO tbl_orders (OrderID, CustomerID, ProductName) VALUES
(1, 101, 'Product A'),
(2, 102, 'Product B'),
(3, 101, 'Product C'),
(4, 103, 'Product A'),
(5, 102, 'Product D'),
(6, 104, 'Product B'),
(7, 101, 'Product E'),
(8, 104, 'Product F');

select * from tbl_orders;
select CustomerID,group_concat(ProductName) as output
from tbl_orders group by CustomerID;

#14....find ith highest salary
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    salary DECIMAL(10, 2)
);
INSERT INTO employees (employee_id, employee_name, salary) VALUES
(1, 'John', 50000.00),
(2, 'Jane', 60000.00),
(3, 'Alice', 55000.00);
with cte as (
select *,row_number() over(order by salary)  as ith from employees)
select employee_name from cte where ith=1;


# 15..entry and exit time
CREATE TABLE user_activity (
    user_id INT,
    entry_time DATETIME,
    exit_time DATETIME
);
-- Inserting sample data into the user_activity table
INSERT INTO user_activity (user_id, entry_time, exit_time) VALUES
(1, '2024-03-01 08:05:00', '2024-03-01 09:30:00'),
(2, '2024-03-01 08:10:00', '2024-03-01 09:15:00'),
(1, '2024-03-01 10:00:00', '2024-03-01 11:45:00'),
(3, '2024-03-01 08:30:00', '2024-03-01 10:00:00'),
(2, '2024-03-01 09:00:00', '2024-03-01 10:30:00'),
(3, '2024-03-01 10:30:00', '2024-03-01 12:00:00');

select user_id,
min(entry_time) as start_t,
max(exit_time) as end_t
from user_activity group by
user_id;

# 16..missing product id detection
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    price DECIMAL(10, 2)
);
INSERT INTO products (id, name, price) VALUES
(1, 'Product A', 10.99),
(2, 'Product B', 15.49),
(4, 'Product D', 8.79),
(5, 'Product E', 12.99),
(6, 'Product F', 18.99),
(7, 'Product G', 22.49),
(9, 'Product I', 14.29),
(10, 'Product J', 9.99);
select * from products;

select id+1 from products as p1 where not exists
(
select * from products p2
where p2.id = p1.id + 1
) and p1.id < (SELECT MAX(id) FROM products);


# 17...analyzing daily running balance
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    TransactionDate DATE,
    Amount DECIMAL(10, 2),
    TransactionType VARCHAR(10)
);

INSERT INTO Transactions (TransactionID, TransactionDate, Amount, TransactionType)
VALUES 
    (1, '2024-03-01', 100.00, 'Credit'),
    (2, '2024-03-02', 50.00, 'Debit'),
    (3, '2024-03-02', 200.00, 'Credit'),
    (4, '2024-03-02', 75.00, 'Debit'),
    (5, '2024-03-05', 150.00, 'Credit'),
    (6, '2024-03-05', 90.00, 'Debit'),
    (7, '2024-03-09', 200.00, 'Credit'),
    (8, '2024-03-10', 100.00, 'Debit'),
    (9, '2024-03-12', 150.00, 'Credit'),
    (10, '2024-03-12', 90.00, 'Debit'),
    (11, '2024-03-12', 200.00, 'Credit'),
    (12, '2024-03-12', 100.00, 'Debit');

with cte as (
select TransactionDate,
sum(case when TransactionType='Credit' then Amount
    when TransactionType='Debit' then -Amount
else 0 end) as net_amount
 from Transactions
 group by TransactionDate)
 select TransactionDate,sum(net_amount) over(order by TransactionDate) as output from cte;


# 18...top 3 custoemrs who spent the most in nth month
CREATE TABLE Orders (
    OrderID INT ,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2)
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES 
    (1, 101, '2024-01-05', 120.00),
    (2, 102, '2024-01-08', 80.00),
    (3, 103, '2024-01-10', 150.00),
    (4, 104, '2024-01-15', 200.00),
    (5, 105, '2024-01-20', 100.00),
    (6, 101, '2024-02-02', 90.00),
    (7, 102, '2024-02-05', 180.00),
    (8, 103, '2024-02-10', 250.00),
    (9, 104, '2024-02-12', 120.00),
    (10, 105, '2024-02-18', 150.00),
    (11, 101, '2024-03-05', 120.00),
    (12, 102, '2024-03-08', 80.00),
    (13, 103, '2024-03-12', 150.00),
    (14, 104, '2024-03-15', 90.00),
    (15, 105, '2024-03-20', 200.00),
    (16, 101, '2024-03-25', 120.00),
    (17, 102, '2024-03-28', 80.00),
    (18, 103, '2024-03-30', 150.00);
    
select * from Orders;
SET @reference_date = '2024-03-30';


select CustomerID,sum(TotalAmount) as total
from orders
where OrderDate between date_format(@reference_date - interval 1 month,'%y-%m-01')
and  LAST_DAY(@reference_date - INTERVAL 1 MONTH)
group by CustomerID 
order by total desc limit 3;

# 19....analyzing matches played,won,lost
CREATE TABLE Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50)
);
CREATE TABLE Points (
    point_id INT PRIMARY KEY,
    team INT,
    opponent INT,
    winner INT,
    FOREIGN KEY (team) REFERENCES Teams(team_id),
    FOREIGN KEY (opponent) REFERENCES Teams(team_id),
    FOREIGN KEY (winner) REFERENCES Teams(team_id)
);

INSERT INTO Teams (team_id, team_name) VALUES
(1, 'Real Madrid'),
(2, 'Barcelona'),
(3, 'Manchester United'),
(4, 'Liverpool'),
(5, 'Chelsea');

INSERT INTO Points (point_id, team, opponent, winner) VALUES
(1, 1, 2, 1),
(2, 2, 3, 3),
(3, 4, 5, 4),
(4, 3, 1, 1);

with t1 as(
select * from Teams as t1 left join
points as p1 on t1.team_id = p1.team or t1.team_id=p1.opponent)
select 
Team_Name,
	COUNT(*) AS Matches_Played,
    SUM(CASE WHEN winner = team_id THEN 1 ELSE 0 END) AS Matches_Won,
    SUM(CASE WHEN winner != team_id  THEN 1 ELSE 0 END) AS Matches_Lost
from t1 group by Team_Name;

# 20..find max from rows
create table tbl_maxval (col1 varchar(50), col2 int, col3 int);
insert into tbl_maxval values ('a',10,20),('b',50,30);

select * from tbl_maxval;
select col1,greatest(col2,col3) as max_val
from tbl_maxval;

# 21..cumilative percentage
create table salesvar_tbl (dt date, sales int);

insert into salesvar_tbl values ('2023-10-03', 10),('2023-10-04', 20),
('2023-10-05', 60),('2023-10-06', 50),('2023-10-07', 10);

SELECT
    *,
    ROUND(
        ((sales - LAG(sales) OVER (ORDER BY dt)) / LAG(sales) OVER (ORDER BY dt)) * 100,
        2
    ) AS percent_change
FROM
    salesvar_tbl;
    

# 22..count number of items
create table tbl_cnt (col1 int, col2 varchar(50));
insert into tbl_cnt values (1, 'a,b,c'),(2, 'a,b');
select * from tbl_cnt;

select col1,length(col2) - length(replace(col2,',','')) + 1 as output from tbl_cnt;


#23..find names of max salary from each dept
create table emp(empid int, empname varchar(50), salary int, deptid int);
insert into emp values (1,'Nikitha',45000,206),(2,'Ashish',42000,207),(3,'David',40000,206),(4,'Ram',50000,207),(5,'John',35000,208),(6,'Mark',50000,207),(7,'Aravind',39000,208);
create table dept (deptid int, deptname varchar(50));
insert into dept values (206,'HR'),(207,'IT'),(208,'Finance');

with cte as (
select *,rank() over(partition by deptname order by salary desc) as top from emp as e1 join
dept d1 using(deptid) )
select deptname,group_concat(empname) as output from cte where top=1
group by deptname;


# 24..replace all values with maximum of that dept

create table empdept_tbl (eid int, dept varchar(50),scores float);
insert into empdept_tbl values (1, 'd1', 1.0),(2, 'd1', 5.28),(3, 'd1', 4.0),(4,'d2', 8.0),(5, 'd1', 2.5),(6, 'd2', 7.0),(7, 'd3', 9.0),(8, 'd4', 10.2);

with t1 as (
select dept,max(scores) as output from empdept_tbl
group by dept)
select eid,dept,output from empdept_tbl as e1 join
t1 using(dept);


# 25...
CREATE TABLE travels 
(
    id VARCHAR(512),
    tid VARCHAR(512),
    origin VARCHAR(512),
    destination VARCHAR(512)
);

INSERT INTO travels (id, tid, origin, destination) VALUES ('1', 't1', 'New York', 'Los Angeles');
INSERT INTO travels (id, tid, origin, destination) VALUES ('1', 't2', 'Los Angeles', 'San Francisco');
INSERT INTO travels (id, tid, origin, destination) VALUES ('2', 't4', 'Chicago', 'Houston');
INSERT INTO travels (id, tid, origin, destination) VALUES ('2', 't5', 'Houston', 'Miami');
INSERT INTO travels (id, tid, origin, destination) VALUES ('3', 't7', 'London', 'Paris');
INSERT INTO travels (id, tid, origin, destination) VALUES ('3', 't8', 'Paris', 'Rome');

WITH RankedTrips AS (
    SELECT 
        id,
        origin,
        destination,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY tid ASC) AS start_trip,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY tid DESC) AS end_trip
    FROM 
        travels
)
SELECT
    t1.origin AS start_city,
    t2.destination AS final_city
FROM 
    RankedTrips t1
JOIN 
    RankedTrips t2 ON t1.id = t2.id AND t1.start_trip = 1 AND t2.end_trip = 1;
    
    
