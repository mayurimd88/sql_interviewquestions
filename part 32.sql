use tips;

create table students ( student_id int, skill varchar(20) ); -- delete from students; 
insert into students values 
(1,'sql'),(1,'python'),(1,'tableau'),(2,'sql'),(3,'sql'),(3,'python'),(4,'tableau'),(5,'python'),(5,'tableau');

-- find student who knows only sql and python
-- method 1
WITH cte AS (
SELECT student_id, COUNT(*) AS total_skills,
COUNT(CASE WHEN skill IN ('sql','python') THEN skill ELSE null END) AS st_skills
FROM students
GROUP BY student_id
)
SELECT * FROM cte 
WHERE total_skills = 2 AND st_skills = 2;

-- method 2
SELECT student_id, COUNT(*) AS total_skills,
COUNT(CASE WHEN skill IN ('sql','python') THEN skill ELSE null END) AS st_skills
FROM students
GROUP BY student_id
HAVING COUNT(*) = 2 AND COUNT(CASE WHEN skill IN ('sql','python') THEN skill ELSE null END) = 2;

-- method 3
SELECT student_id, COUNT(*) AS total_skills,
COUNT(CASE WHEN skill IN ('sql','python') THEN skill ELSE null END) AS st_skills,
COUNT(CASE WHEN skill NOT IN ('sql','python') THEN skill ELSE null END) AS stn_skills
FROM students
GROUP BY student_id
HAVING COUNT(*) = 2 AND COUNT(CASE WHEN skill NOT IN ('sql','python') THEN skill ELSE null END) = 0;

-- method 4
SELECT student_id, COUNT(*) AS total_skills
FROM students
WHERE student_id NOT IN (SELECT student_id FROM students WHERE skill NOT IN ('sql','python'))
GROUP BY student_id
HAVING COUNT(*) = 2;

-- method 5
SELECT student_id
FROM students
GROUP BY student_id
HAVING COUNT(*) = 2
EXCEPT -- /MINUS
SELECT student_id
FROM students
WHERE skill NOT IN ('sql','python');

-- method 6
SELECT student_id, COUNT(*) AS total_skills
FROM students s1
WHERE NOT EXISTS (SELECT 1 FROM students s2 WHERE s2.skill NOT IN ('sql','python') AND
													s1.student_id=s2.student_id)
GROUP BY student_id
HAVING COUNT(*) = 2;

-- method 7
WITH ctesql AS (SELECT * FROM students WHERE skill = 'sql'),
python AS (SELECT * FROM students WHERE skill = 'python'),
other AS (SELECT * FROM students WHERE skill NOT IN ('sql', 'python'))
SELECT s.*,o.*
FROM ctesql s
INNER JOIN python p ON s.student_id = p.student_id
LEFT JOIN other o ON s.student_id = o.student_id
WHERE o.student_id IS null;

-- method 8
SELECT s.*,o.*
FROM students s
INNER JOIN students p ON s.student_id = p.student_id
LEFT JOIN students o ON s.student_id = o.student_id AND 
						o.skill NOT IN ('sql','python')
WHERE s.skill = 'sql' AND p.skill = 'python' AND  o.student_id IS null;

-- method 9
WITH ctesql AS (SELECT * FROM students WHERE skill = 'sql'),
python AS (SELECT * FROM students WHERE skill = 'python'),
other AS (SELECT * FROM students WHERE skill NOT IN ('sql', 'python'))
SELECT student_id
FROM ctesql 
INTERSECT 
SELECT student_id
FROM python
EXCEPT
SELECT student_id FROM other;

-- method 10
WITH cte AS (
SELECT student_id,
SUM(CASE WHEN skill IN ('sql','python') THEN 1 ELSE 5 END) AS st_skills
FROM students
GROUP BY student_id
)
SELECT * FROM cte 
WHERE st_skills = 2;




