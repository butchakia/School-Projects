SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'products';

ALTER TABLE products
ADD COLUMN shock_name VARCHAR(25);

UPDATE products
SET shock_name='No shock'
WHERE prod_description='Hardtail Mountain Bike'

SELECT prod_id
	, prod_description
	, shock_name
FROM products
ORDER BY shock_name
LIMIT 100


UPDATE components
	SET comp_name = 'No Part'
	, comp_cost = '0'
	, comp_supplier = '0'
WHERE comp_id = '172';

SELECT prod_id
FROM products
WHERE prod_description = 'Hardtail Mountain Bike'

SELECT build_id
	, prod_id
FROM productbuilds
WHERE prod_id = 37 
OR prod_id = 57 
OR prod_id = 6 
OR prod_id = 63

ALTER TABLE builds
ADD COLUMN prod_id INT

UPDATE builds
SET prod_id = pb.prod_id
FROM productbuilds pb
WHERE builds.build_id = pb.build_id;

SELECT prod_id
	, build_id
FROM builds

SELECT p.prod_name, b.build_name, SUM(o.order_tot) AS total_order
FROM products p
JOIN builds b ON p.prod_id = b.prod_id
JOIN orders o ON p.prod_id = o.prod_id
GROUP BY ROLLUP (p.prod_name, b.build_name)
WHERE p.prod_description='Hardtail Mountain Bike';

WITH cte AS (
    SELECT p.prod_name, b.build_name, SUM(o.order_tot) AS total_order
    FROM products p
    JOIN builds b ON p.prod_id = b.prod_id
    JOIN orders o ON p.prod_id = o.prod_id
    GROUP BY GROUPING SETS ((p.prod_name, b.build_name), ())
)
SELECT prod_name, build_name, total_order
FROM cte;


SELECT p.prod_name, b.build_name, SUM(o.order_tot) AS total_order
FROM products p
JOIN builds b ON p.prod_id = b.prod_id
JOIN orders o ON p.prod_id = o.prod_id
WHERE p.prod_id IN (37, 57, 6, 63)
GROUP BY ROLLUP (p.prod_name, b.build_name);

WITH pb_names AS (
    SELECT p.prod_name, b.build_name, SUM(o.order_tot) AS total_order
    FROM products p
    JOIN builds b ON p.prod_id = b.prod_id
    JOIN orders o ON p.prod_id = o.prod_id
    WHERE p.prod_id IN (37, 57, 6, 63)
    GROUP BY ROLLUP (p.prod_name, b.build_name)
)
SELECT prod_name, build_name, total_order
FROM pb_names;


CREATE TABLE opc_export (
    cus_id INT,
    cus_last_name VARCHAR(50),
    cus_first_name VARCHAR(50),
    cus_join_date DATE,
    cus_app_cd SMALLINT,
    tot_ord_qty SMALLINT,
    tot_ord_value NUMERIC
);



INSERT INTO opc_export (cus_id, cus_last_name, cus_first_name, cus_join_date, cus_app_cd, tot_ord_qty, tot_ord_value)
SELECT cus_id, cus_last_name, cus_first_name,
       CASE WHEN cus_join_date = '2020-12-12' THEN NULL ELSE cus_join_date END AS cus_join_date,
       cus_app_cd, tot_ord_qty, tot_ord_value
FROM customers
WHERE cus_join_date > '2020-01-01';

SELECT *
FROM opc_export

SELECT *
FROM taxes
ORDER BY tax_location

UPDATE taxes
SET tax_rate = 7
WHERE tax_location='RI'

SELECT order_tot
	, prod_id
	, ord_date
FROM orders
WHERE ord_tax_loc='20'
ORDER BY ord_date

SELECT prod_id
	, prod_price
FROM products
WHERE prod_id=43

ALTER TABLE orders
ADD COLUMN pre_tax_price INT

UPDATE orders
SET pre_tax_price = p.prod_price
FROM products p
WHERE orders.prod_id = p.prod_id;

SELECT order_tot
    , ord_id
    , prod_id
    , pre_tax_price
    , pre_tax_price * 1.0575 AS new_tot
	, ord_date
FROM orders
WHERE ord_date >= '2019-01-01' AND ord_tax_loc = '20';

SELECT SUM(cus_phone) AS phone_sum
FROM customers
WHERE cus_state = '4'

SELECT *
FROM taxes
WHERE tax_location = 'WV'

SELECT SUM(cus_zip)
FROM customers
WHERE cus_state='29'

SELECT t.tax_location AS state, COUNT(o.ord_id) AS order_count
FROM orders o
JOIN taxes t ON o.ord_tax_loc::smallint = t.tax_id::smallint
GROUP BY t.tax_location, o.ord_tax_loc
ORDER BY state;

WITH order_counts AS (
   SELECT t.tax_location AS state, o.ord_tax_loc, COUNT(o.ord_id) AS order_count
   FROM orders o
   JOIN taxes t ON o.ord_tax_loc::smallint = t.tax_id::smallint
   GROUP BY t.tax_location, o.ord_tax_loc
)
SELECT state, order_count
FROM order_counts
ORDER BY state;

SELECT *
FROM opc_export

SELECT (random()) * 10000000 + 100 * 195185 / 0.25 AS result
FROM generate_series(1, 40);

SELECT CAST((random()) * 10000000 + 100 * 195185 / 0.25 AS INTEGER) AS result
FROM generate_series(1, 40);

ALTER TABLE opc_export
ALTER COLUMN cus_app_cd TYPE varchar(15);

UPDATE opc_export
SET cus_app_cd = 'OPC' || LPAD(result::text, 8, '0')
FROM (
    SELECT CAST(random() * 10000000 + 100 * 195185 / 0.25 AS INTEGER) AS result
    FROM generate_series(1, 40)
) AS random_numbers;

SELECT *
FROM opc_export

UPDATE opc_export
SET cus_app_cd = 'OPC' || LPAD(random_numbers.result::text, 8, '0')
FROM (
    SELECT cus_id, CAST(random() * 10000000 + 100 * 195185 / 0.25 AS INTEGER) AS result
    FROM opc_export
    WHERE cus_app_cd IS NOT NULL
    LIMIT 10
) AS random_numbers
WHERE opc_export.cus_id = random_numbers.cus_id;

CREATE TABLE nu_table(
	cus_app_cd VARCHAR(15)
	);

SELECT COUNT(cus_id)
	FROM customers
	
INSERT INTO nu_table (cus_app_cd)
SELECT 'OPC' || LPAD((random() * 10000000 + 100 * 195185 / 0.25)::integer::text, 8, '0')
FROM generate_series(1, 2619);

SELECT *
FROM nu_table

--k
UPDATE customers
SET cus_app_num = NULL;

SELECT *
FROM customers

UPDATE customers
SET cus_app_num = nu.cus_app_cd
FROM (
    SELECT cus_app_cd, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS row_num
    FROM nu_table
) AS nu
WHERE customers.cus_id = nu.row_num;