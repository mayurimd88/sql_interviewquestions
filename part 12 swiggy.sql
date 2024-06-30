use tips;

CREATE TABLE stock (
 supplier_id INT,
 product_id INT,
 stock_quantity INT,
 record_date DATE
);

INSERT INTO stock (supplier_id, product_id, stock_quantity, record_date)
VALUES
 (1, 1, 60, '2022-01-01'),
 (1, 1, 40, '2022-01-02'),
 (1, 1, 35, '2022-01-03'),
 (1, 1, 45, '2022-01-04'),
 (1, 1, 51, '2022-01-06'),
 (1, 1, 55, '2022-01-09'),
 (1, 1, 25, '2022-01-10'),
 (1, 1, 48, '2022-01-11'),
 (1, 1, 45, '2022-01-15'),
 (1, 1, 38, '2022-01-16'),
 (1, 2, 45, '2022-01-08'),
 (1, 2, 40, '2022-01-09'),
 (2, 1, 45, '2022-01-06'),
 (2, 1, 55, '2022-01-07'),
 (2, 2, 45, '2022-01-08'),
 (2, 2, 48, '2022-01-09'),
 (2, 2, 35, '2022-01-10'),
 (2, 2, 52, '2022-01-15'),
 (2, 2, 23, '2022-01-16');
 SELECT * FROM stock;
 
 /* Write a SQL query to find out supplier_id, product_id, 
 and starting date of record_date for which stock quantity 
 is less than 50 for two or more consecutive days. */
 
WITH cte1 AS(
SELECT supplier_id, product_id, record_date,
LAG(record_date,1) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date) AS prev_recrddate,
DATEDIFF(DAY, LAG(record_date,1, record_date) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date), record_date) AS daysdiff
FROM stock
WHERE stock_quantity < 50) ,
cte2 AS(
SELECT *, 
CASE WHEN daysdiff <=1 THEN 0 ELSE 1 END AS group_flag,
SUM(CASE WHEN daysdiff <=1 THEN 0 ELSE 1 END) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date) AS group_id
FROM cte1
)
SELECT supplier_id, product_id, COUNT(*) AS no_of_records, MIN(record_date) AS first_date
FROM cte2
GROUP BY supplier_id, product_id, group_id
HAVING count(*) >= 2
;

Error Code: 1582. Incorrect parameter count in the call to native function 'DATEDIFF'





WITH cte1 AS (
    SELECT 
		supplier_id, product_id, record_date,
        LAG(record_date, 1) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date) AS prev_recrddate,
        DATEDIFF(record_date, LAG(record_date, 1, record_date)
				OVER (PARTITION BY supplier_id, product_id ORDER BY record_date)) AS daysdiff
    FROM stock
    WHERE stock_quantity < 50
), 
cte2 AS (
    SELECT *, 
        CASE WHEN daysdiff <= 1 THEN 0 ELSE 1 
        END AS group_flag,
        SUM(CASE WHEN daysdiff <= 1 THEN 0 ELSE 1 END) OVER (PARTITION BY supplier_id, product_id ORDER BY record_date) AS group_id
    FROM cte1
)
SELECT 
    supplier_id, product_id, COUNT(*) AS no_of_records, MIN(record_date) AS first_date
FROM cte2
GROUP BY supplier_id, product_id, group_id
HAVING count(*) >= 2;



 
 
 
 
 
 
 
 
 