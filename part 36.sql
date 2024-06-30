use tips;

create table emp4(
emp_id int, emp_name varchar(20),
department_id int, salary int,
manager_id int, emp_age int);
insert into emp4 values (1, 'Ankit', 100,10000, 4, 39);
insert into emp4 values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp4 values (3, 'Vikas', 100, 10000,4,37);
insert into emp4 values (4, 'Rohit', 100, 5000, 2, 16);
insert into emp4 values (5, 'Mudit', 200, 12000, 6,55);
insert into emp4 values (6, 'Agam', 200, 12000,2, 14);
insert into emp4 values (7, 'Mudit', 200, 12000, 6,55);
insert into emp4 values (8, 'Agam', 200, 12000,2, 14);
insert into emp4 values (9, 'Sanjay', 200, 9000, 2,13);
insert into emp4 values (10, 'Ashish', 200,5000,2,12);
insert into emp4 values (11, 'Mukesh',300,6000,6,51);
insert into emp4 values (12, 'Rakesh',300,7000,6,50);
truncate table emp4;

-- find duplicates
SELECT emp_name, COUNT(1) AS count
FROM emp4
GROUP BY emp_name
HAVING COUNT(1) > 1;

-- delete duplicate
SET SQL_SAFE_UPDATES = 0;
DELETE e1
FROM emp4 e1
JOIN emp4 e2
ON e1.emp_name=e2.emp_name
WHERE e1.emp_id>e2.emp_id;
SELECT * FROM emp4;   
   
/* WITH cte as 
(select *, row_number() over(partition by emp_id order by emp_id) as rn from emp4)
delete from cte where rn >1; */






