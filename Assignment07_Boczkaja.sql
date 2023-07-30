SELECT EXTRACT(YEAR FROM o.ord_date) AS year_sales
	, s.num_of_sales
FROM orders o
JOIN ( 
	SELECT EXTRACT(YEAR FROM ord_date) AS year
	, COUNT(*) AS num_of_sales
	FROM orders
	WHERE EXTRACT(YEAR FROM ord_date) = 2015
	GROUP BY EXTRACT(YEAR FROM ord_date)
) s ON EXTRACT(YEAR FROM o.ord_date) = s.year
WHERE EXTRACT(YEAR FROM o.ord_date) = 2015
LIMIT 1;

SELECT EXTRACT(YEAR FROM o.ord_date) AS year_sales
	, EXTRACT(MONTH FROM o.ord_date) AS month_sales
    , COUNT(*) AS num_of_sales
FROM orders o
WHERE EXTRACT(YEAR FROM o.ord_date) = 2015
GROUP BY EXTRACT(YEAR FROM o.ord_date)
	, EXTRACT(MONTH FROM o.ord_date)
ORDER BY EXTRACT(MONTH FROM o.ord_date);

SELECT EXTRACT(YEAR FROM o.ord_date) AS year_sales
	, s.num_of_sales
FROM orders o
JOIN (
  SELECT EXTRACT(YEAR FROM ord_date) AS year
	, COUNT(*) AS num_of_sales
  FROM orders
  WHERE EXTRACT(YEAR FROM ord_date) = 2010
  GROUP BY EXTRACT(YEAR FROM ord_date)
) s ON EXTRACT(YEAR FROM o.ord_date) = s.year
WHERE EXTRACT(YEAR FROM o.ord_date) = 2010
LIMIT 1;

SELECT EXTRACT(MONTH FROM cus_join_date) AS month
	, COUNT(*) AS num_of_cus
FROM customers
WHERE EXTRACT(YEAR FROM cus_join_date) = 2018
GROUP BY EXTRACT(MONTH FROM cus_join_date)
ORDER BY EXTRACT(MONTH FROM cus_join_date);
  
SELECT EXTRACT(YEAR FROM cus_join_date) AS year
	, COUNT(*) AS num_of_cus
FROM customers
GROUP BY EXTRACT(YEAR FROM cus_join_date)
ORDER BY EXTRACT(YEAR FROM cus_join_date);
  
SELECT cus_num
  , cus_id
  , cus_last_name
  , TO_CHAR(cus_join_date, 'DAY') AS join_day_of_week
FROM customers
WHERE cus_id = 1800;

SELECT c.cus_id
	, c.cus_join_date
	, o.ord_ship_date
	, o.ord_ship_date - c.cus_join_date AS time_to_order
FROM customers c
JOIN orders o ON c.cus_id = o.cus_id
WHERE EXTRACT(YEAR FROM c.cus_join_date) = 2018
	AND EXTRACT(YEAR FROM o.ord_ship_date) = 2018;
	
--B
SELECT ord_id
	, order_tot
	, warehouse_id
FROM orders
WHERE warehouse_id=2
ORDER BY order_tot

DROP TABLE recall_table



SELECT *
FROM builds
WHERE 66 IN (comp_hbar, comp_brake,	comp_wheels, comp_fork, comp_shock,	comp_shifter, comp_cassette, comp_derail, comp_dropper,	comp_crank, comp_chain_ring
) OR
      214 IN (comp_hbar, comp_brake,	comp_wheels, comp_fork, comp_shock,	comp_shifter, comp_cassette, comp_derail, comp_dropper,	comp_crank, comp_chain_ring) OR
      225 IN (comp_hbar, comp_brake,	comp_wheels, comp_fork, comp_shock,	comp_shifter, comp_cassette, comp_derail, comp_dropper,	comp_crank, comp_chain_ring) OR
      229 IN (comp_hbar, comp_brake,	comp_wheels, comp_fork, comp_shock,	comp_shifter, comp_cassette, comp_derail, comp_dropper,	comp_crank, comp_chain_ring) OR
      279 IN (comp_hbar, comp_brake,	comp_wheels, comp_fork, comp_shock,	comp_shifter, comp_cassette, comp_derail, comp_dropper,	comp_crank, comp_chain_ring);
	  
SELECT *
FROM builds
WHERE '66'::integer IN (comp_hbar::integer, comp_brake::integer, comp_wheels::integer, comp_fork::integer, comp_shock::integer, comp_shifter::integer, comp_cassette::integer, comp_derail::integer, comp_dropper::integer, comp_crank::integer, comp_chain_ring::integer) OR
      '214'::integer IN (comp_hbar::integer, comp_brake::integer, comp_wheels::integer, comp_fork::integer, comp_shock::integer, comp_shifter::integer, comp_cassette::integer, comp_derail::integer, comp_dropper::integer, comp_crank::integer, comp_chain_ring::integer) OR
      '225'::integer IN (comp_hbar::integer, comp_brake::integer, comp_wheels::integer, comp_fork::integer, comp_shock::integer, comp_shifter::integer, comp_cassette::integer, comp_derail::integer, comp_dropper::integer, comp_crank::integer, comp_chain_ring::integer) OR
      '229'::integer IN (comp_hbar::integer, comp_brake::integer, comp_wheels::integer, comp_fork::integer, comp_shock::integer, comp_shifter::integer, comp_cassette::integer, comp_derail::integer, comp_dropper::integer, comp_crank::integer, comp_chain_ring::integer) OR
      '279'::integer IN (comp_hbar::integer, comp_brake::integer, comp_wheels::integer, comp_fork::integer, comp_shock::integer, comp_shifter::integer, comp_cassette::integer, comp_derail::integer, comp_dropper::integer, comp_crank::integer, comp_chain_ring::integer);

SELECT *
FROM customers


SELECT *
FROM recall_table

SELECT *
FROM customers

ALTER TABLE customers
ADD COLUMN build_id INTEGER

UPDATE customers AS c
SET build_id = o.build_id
FROM orders AS o
WHERE c.cus_id = o.cus_id;

CREATE TABLE recall_table(
	cus_id INTEGER
	, cus_last_name VARCHAR(50)
	, cus_first_name VARCHAR(50)
	, cus_state SMALLINT
	, cus_phone BIGINT
);

INSERT INTO recall_table (cus_id, cus_last_name, cus_first_name, cus_state, cus_phone)
SELECT c.cus_id
	, c.cus_last_name
	, c.cus_first_name
	, c.cus_state
	, c.cus_phone
FROM customers c
WHERE c.build_id IN (74, 80, 68, 75, 19, 22, 18, 37, 38, 13, 57, 66, 35, 48, 40, 10, 45, 8);

SELECT *
FROM recall_table

SELECT *
FROM products

UPDATE products
SET sup_id = CAST(prod_manufacturer AS integer);

ALTER TABLE products
ADD COLUMN sup_name VARCHAR(35)

SELECT *
FROM products p
JOIN orders o ON o.prod_id = p.prod_id

--D
SELECT DISTINCT prod_name 
       , FIRST_VALUE(sup_name) OVER (PARTITION BY prod_name) AS sup_name
       , FIRST_VALUE(prod_description) OVER (PARTITION BY prod_name) AS prod_description
       , FIRST_VALUE(sup_ctry) OVER (PARTITION BY prod_name) AS sup_ctry
       , SUM(order_tot) OVER (PARTITION BY prod_name) AS total_sum
FROM products p
JOIN orders o ON o.prod_id = p.prod_id
ORDER BY sup_name;

SELECT sup_name
	, prod_name
	, prod_description
	, sup_ctry
	, SUM(order_tot)
FROM products p
JOIN orders o ON o.prod_id = p.prod_id
GROUP BY sup_name

ALTER TABLE products
ADD COLUMN sup_ctry VARCHAR(30)

UPDATE products
SET sup_name = suppliers.sup_name, sup_ctry = suppliers.sup_ctry
FROM suppliers
WHERE products.sup_id = suppliers.sup_id;

SELECT sup_name, prod_name, prod_description, sup_ctry, SUM(order_tot)
FROM products p
JOIN orders o ON o.prod_id = p.prod_id
GROUP BY sup_name, prod_name, prod_description, sup_ctry;

SELECT sup_name, prod_name, prod_description, sup_ctry, SUM(order_tot)
FROM products p
JOIN orders o ON o.prod_id = p.prod_id
GROUP BY sup_name, prod_name, prod_description, sup_ctry
ORDER BY sup_name;

SELECT sup_name, prod_name, prod_description, sup_ctry, 
       SUM(order_tot) OVER (PARTITION BY prod_name) AS total_sum
FROM products p
JOIN orders o ON o.prod_id = p.prod_id
ORDER BY sup_name;

--D


SELECT MAX(total_sum) AS max_sum
FROM (
  SELECT SUM(order_tot) AS total_sum
  FROM products p
  JOIN orders o ON o.prod_id = p.prod_id
  GROUP BY sup_name, prod_name, prod_description, sup_ctry
) subquery;

SELECT *
FROM racs

SELECT SUM(tot_ret_amnt) OVER () AS total_ret_value
	, cus_id
    , tot_ret_item_cnt
    , tot_ret_amnt
FROM racs
WHERE tot_ret_item_cnt > 0
ORDER BY tot_ret_amnt DESC;

SELECT *
FROM orders

SELECT *
FROM products p
JOIN orders o ON p.prod_id=o.prod_id 

SELECT
  p.sup_name,
  p.prod_name,
  SUM(o.order_tot) AS total_order_amount,
  AVG(o.order_tot) AS average_order_amount,
  SUM(o.order_tot - o.pre_tax_price) AS order_amount_difference
FROM
  products p
JOIN
  orders o ON p.prod_id = o.prod_id
GROUP BY p.sup_name, p.prod_name;

SELECT
  p.sup_name,
  p.prod_name,
  SUM(o.order_tot) OVER (PARTITION BY p.sup_name, p.prod_name) AS total_order_amount,
  AVG(o.order_tot) OVER (PARTITION BY p.sup_name, p.prod_name) AS average_order_amount,
  (o.order_tot - o.pre_tax_price) AS order_amount_difference
FROM
  products p
JOIN
  orders o ON p.prod_id = o.prod_id;

SELECT p.sup_name
	, p.prod_name
	, o.ord_tax_loc
	, o.ord_id
	, SUM(o.order_tot) OVER (PARTITION BY p.sup_name) AS tot_ord_amnt
 	, AVG(o.order_tot) OVER () AS avg_ord_amnt
	, (o.order_tot - o.pre_tax_price) AS order_difference
	, SUM(o.order_tot) OVER () AS complete_ord_tot
FROM products p
JOIN orders o ON p.prod_id = o.prod_id;
