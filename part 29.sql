use tips;
CREATE TABLE city_distance 
( distance INT, source VARCHAR(512), destination VARCHAR(512) ); 
-- delete from city_distance; 
INSERT INTO city_distance(distance, source, destination) VALUES ('100', 'New Delhi', 'Panipat'); 
INSERT INTO city_distance(distance, source, destination) VALUES ('200', 'Ambala', 'New Delhi'); 
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Bangalore', 'Mysore'); 
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Mysore', 'Bangalore'); 
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Mumbai', 'Pune'); 
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Pune', 'Mumbai'); 
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Chennai', 'Bhopal'); 
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Bhopal', 'Chennai'); 
INSERT INTO city_distance(distance, source, destination) VALUES ('60', 'Tirupati', 'Tirumala'); 
INSERT INTO city_distance(distance, source, destination) VALUES ('80', 'Tirumala', 'Tirupati');
SELECT * FROM city_distance;
-- remove duplicate. in case of source, destination, distance are same then keep the first value only
-- method 1
SELECT c1.* -- , c2.*
FROM city_distance c1
LEFT JOIN city_distance c2 ON c1.source = c2.destination 
							AND c1.destination = c2.source
WHERE c2.distance IS NULL OR 
	c1.distance != c2.distance OR 
    c1.source < c1.destination;

-- method 2
WITH cte AS (
	SELECT *,
	CASE WHEN source<destination THEN source ELSE destination END AS city1,
	CASE WHEN source<destination THEN destination ELSE source END AS city2
	FROM city_distance
),
cte2 AS (
	SELECT *,
	COUNT(*) OVER(PARTITION BY city1, city2, distance) AS cunt
	FROM cte
)
SELECT distance, source, destination
FROM cte2
WHERE cunt=1 OR (source < destination);

-- method 3
WITH cte AS (
SELECT *,
ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rno
FROM city_distance
)
SELECT c1.*
FROM cte c1
LEFT JOIN cte c2 ON c1.source = c2.destination AND c1.destination = c2.source
WHERE  c2.distance IS NULL OR 
 c1.distance != c2.distance OR
 c1.rno < c2.rno;













