use tips;

CREATE TABLE rooms (
 user_id INT,
 date_searched DATE,
 room_types VARCHAR(50)
);

INSERT INTO rooms
VALUES
 (1, '2022-01-01', "entire home,private room"),
 (2,  '2022-01-02', "entire home, shared room"),
 (3,  '2022-01-02', "private room, shared room"),
 (4, '2022-02-03', "private room");
 SELECT * FROM rooms;
 
 /* find the room types that are searched most of the time.
 output the room type alongside the no of searches for it.
 if the filter for room type has more than one type, consider
 each room type has a separate row.
 sort the result based on the no of searches in descending order */
 
 SELECT value as room_type, COUNT (1) as no_of_searches
 FROM rooms
 CROSS APPLY STRING SPLIT (room_types,',')
 GROUP BY value
 ORDER BY no_of_searches desc;
 
 SELECT value AS room_type, COUNT(1) AS no_of_searches
FROM rooms
CROSS APPLY STRING_SPLIT(room_types, ',')
GROUP BY value
ORDER BY no_of_searches DESC;



WITH RECURSIVE room_types_cte AS (
  SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(room_types, ',', n), ',', -1) AS room_type,
    COUNT(*) AS no_of_searches
  FROM 
    rooms
  JOIN 
    (SELECT 1 AS n UNION ALL SELECT n + 1 FROM room_types_cte WHERE n < LENGTH(room_types) - LENGTH(REPLACE(room_types, ',', '')) + 1) AS numbers
  GROUP BY 
    room_type
)
SELECT 
  room_type, 
  no_of_searches
FROM room_types_cte
ORDER BY no_of_searches DESC;

SELECT 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(room_types, ',', n), ',', -1)) AS room_type,
    COUNT(*) AS no_of_searches
FROM rooms
JOIN 
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) AS numbers
WHERE CHAR_LENGTH(room_types) - CHAR_LENGTH(REPLACE(room_types, ',', '')) >= n - 1
GROUP BY room_type
ORDER BY no_of_searches DESC;

 
 
 