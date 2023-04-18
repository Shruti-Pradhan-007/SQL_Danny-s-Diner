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
