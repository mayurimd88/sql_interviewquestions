use tips;

create table source(ID int, Name VARCHAR(10));
insert into source values
(1, 'A'),(2,'B'),(3,'C'),(4,'D');

create table target(ID int, Name VARCHAR(10));
insert into target values
(1, 'A'),(2,'B'),(4,'X'),(5,'F');

-- METHOD 1
SELECT COALESCE(S.ID, T.ID), -- S.Name, T.Name,
CASE WHEN T.Name IS NULL THEN "New In Source" 
		WHEN S.Name IS NULL THEN "New In Target" 
		ELSE "Mismatched" END AS comments
FROM SOURCE S
FULL JOIN TARGET T ON S.ID = T.ID
WHERE S.Name != T.Name OR S.Name IS NULL OR T.Name IS NULL

-- METHOD 2
WITH cte AS(
SELECT *, "source" AS table_name FROM source
UNION ALL
SELECT *, "target" AS table_name FROM target
)
SELECT ID,-- count(*) AS cmt, MIN(Name) AS min_name, MAX(Name) AS max_name, 
		-- MIN(table_name) AS min_tablename, MAX(table_name) AS max_table_name,
CASE WHEN MIN(Name) != MAX(Name) THEN "Mismatched" 
	WHEN MIN(table_name)= "source" THEN "new in source"
    ELSE "new in target" END AS comment
FROM cte
GROUP BY ID
HAVING count(*) = 1 OR (count(*) = 2 AND MIN(Name) != MAX(Name))

WITH cte AS (
SELECT * FROM 
sources s
FULL OUTER JOIN target t ON s.id = t.id
)
cte1 AS (
SELECT sid, tid
CASE 
WHEN sid IS NOT NULL AND tid IS NULL THEN 'new in source',
WHEN sid IS NULL AND tid IS NOT NULL THEN 'new in target',
WHEN sid = tid AND sname <> tname THEN 'Mismatched'
else 'ok'
END AS comment
)
SELECT COALESCE(sid, tid) AS id, comment
FROM cte1
WHERE comment <> 'ok'















