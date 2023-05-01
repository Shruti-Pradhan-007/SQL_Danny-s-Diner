--1. What is the total amount each customer spent at the restaurant?--

SELECT 
	s.customer_id
	, SUM(m.price) AS total_amount_spent
FROM 
	sales s
	join menu m on s.product_id = m.product_id
GROUP BY 
	s.customer_id;
  
  -- 2. How many days has each customer visited the restaurant?--

SELECT customer_id 
	, COUNT(ORDER_DATE) AS No_Of_Days_Visited
FROM 
	sales
GROUP BY 
	customer_id;
	
-- 3. What was the first item from the menu purchased by each customer?--

WITH first_item AS (
SELECT  customer_id
		, order_date
		, product_id
		, RANK () OVER (PARTITION BY customer_id ORDER BY order_date) AS rnk
FROM 
	sales)
 
SELECT  distinct(f.customer_id)
	, f.order_date
	, m.product_name
FROM 
	first_item f
	JOIN menu m on f.product_id = m.product_id
WHERE 
	rnk = 1;	
	
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?--

SELECT 
	TOP 1 s.product_id
	, m.product_name
	, COUNT (s.product_id) AS times_purchased
FROM 
	sales s
	join menu m on s.product_id = m.product_id
GROUP BY 
	s.product_id
	, m.product_name
ORDER BY
	times_purchased DESC;

--5. Which item was the most popular for each customer?--

SELECT TOP 3 s.customer_id
	, m.product_name
	, count(s.product_id) AS times_purchased
FROM 
	sales s
	JOIN menu m ON s.product_id = m.product_id
GROUP BY 
	s.customer_id, s.product_id, m.product_name
ORDER BY 
	times_purchased DESC;




--10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?--

WITH temp AS (
SELECT s.customer_id, 
CASE 
	WHEN DATEDIFF(day, s.order_date, m.join_date) <= 7 THEN  20 * me.price
ELSE 
	10 * me.price
END AS points
FROM 
	sales s
	JOIN menu me on s.product_id=me.product_id
	JOIN members m on s.customer_id=m.customer_id
WHERE 
	s.order_date >= m.join_date AND s.order_date < '2021-01-31')

SELECT
	customer_id AS Customer
	, SUM(points) AS Points_Earned
FROM
	temp
GROUP BY
	customer_id;
