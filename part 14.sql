USE tips;

-- rank the emp according to their highest salary
SELECT emp_id, emp_name, department_id, salary,
RANK() OVER(ORDER BY salary desc)  as salary_rank,
DENSE_RANK() OVER(ORDER BY salary desc)  as salary_denserank,
ROW_NUMBER() OVER(ORDER BY salary desc)  as salary_rowno
FROM emp;

-- rank the emp by department id
SELECT emp_id, emp_name, department_id, salary,
RANK() OVER(PARTITION BY department_id ORDER BY salary desc)  as salary_rank,
DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary desc)  as salary_denserank,
ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary desc)  as salary_rowno
FROM emp;

-- find employee having highest salary department wise
SELECT * FROM (
SELECT emp_id, emp_name, department_id, salary,
RANK() OVER(PARTITION BY department_id ORDER BY salary desc)  as salary_rank
FROM emp
) a
WHERE salary_rank = 1;




