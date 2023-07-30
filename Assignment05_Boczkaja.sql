--Ai
SELECT c.cus_id
	, c.cus_last_name
	, c.cus_first_name
	, c.cus_state
	, c.tot_ord_value
	, w.warehouse_id
FROM customers c
LEFT JOIN customerwarehouseorders w ON c.cus_id = w.cus_id
ORDER BY w.warehouse_id DESC, c.tot_ord_value DESC;

--Aii
SELECT c.cus_id
	, c.cus_last_name
	, c.cus_first_name
	, c.cus_state
	, c.tot_ord_value
	, w.warehouse_id
FROM customers c
FULL OUTER JOIN customerwarehouseorders w ON c.cus_id = w.cus_id
ORDER BY w.warehouse_id DESC, c.tot_ord_value DESC;

--b
SELECT DISTINCT c.cus_id
	, c.cus_last_name
	, c.cus_first_name
FROM customers c
FULL OUTER JOIN racs r ON c.cus_id = r.cus_id
WHERE r.tot_ret_item_cnt>=10
ORDER BY c.cus_last_name

--c
SELECT o.cus_id
	, o.ord_track_num
	, o.ord_date
	, o.order_tot
FROM orders o
FULL OUTER JOIN customers c ON o.cus_id = c.cus_id
WHERE o.warehouse_id=1 AND c.cus_state = 20

--d
SELECT c.cus_id
	, c.cus_last_name
	, c.cus_first_name
	, c.cus_app_cd
	, o.warehouse_id
	, o.ord_date
	, o.ord_track_num
FROM customers c
JOIN orders o ON c.cus_id = o.cus_id
LEFT JOIN suppliers s ON o.prod_id = s.sup_id
WHERE o.prod_id=60
ORDER BY c.cus_app_cd, o.ord_date DESC



	