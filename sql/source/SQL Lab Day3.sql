-- Q1. Rewrite last week's Q5 (revenue vs payments per order) using two CTEs.


-- Q2. Sellers with no 1-star reviews at all — use NOT EXISTS.


--Q4. Monthly revenue for delivered orders.
--Q5. For each month, which product category earned the most delivered revenue?



Week3 Day1 Question 4 & 5 answer , NOT IN and NOT EXIST difference
--Q:4 Monthly revenue for delivered orders.
WITH delivered_orders AS (
SELECT o.order_id,
DATE_TRUNC('month', o.order_purchase_timestamp)::date AS order_month
FROM raw.orders AS o
WHERE o.order_status = 'delivered'
),
order_revenue AS (
SELECT p.order_id,
SUM(p.payment_value) AS revenue
FROM raw.order_payments AS p
GROUP BY p.order_id
)
SELECT d.order_month,
COUNT(*) AS delivered_orders,
ROUND(SUM(r.revenue), 2) AS revenue
FROM delivered_orders AS d
JOIN order_revenue AS r
ON r.order_id = d.order_id
GROUP BY d.order_month
ORDER BY d.order_month;

--Q5: For each month, which product category earned the most delivered revenue
WITH monthly AS ( -- step 1: revenue per month + category
SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
p.product_category_name AS category,
SUM(oi.price) AS revenue
FROM raw.orders o
JOIN raw.order_items oi USING (order_id)
JOIN raw.products p USING (product_id)
WHERE o.order_status = 'delivered'
GROUP BY 1, 2
order by month
),
monthly_max AS ( -- step 2: best revenue per month with category
SELECT month, MAX(revenue) AS top_revenue
FROM monthly
GROUP BY month
order by month
)

SELECT m.month, m.category, m.revenue
FROM monthly m
JOIN monthly_max x
ON x.month = m.month
AND x.top_revenue = m.revenue -- keep only the winner
ORDER BY m.month;

--
-- NOT IN
SELECT p.product_category_name
FROM raw.products p
WHERE p.product_category_name NOT IN (
SELECT ct.product_category_name
FROM raw.category_translation ct
)order by p.product_category_name desc ;--13

-- NOT EXISTS
SELECT p.product_category_name ,p.product_id
FROM raw.products p
WHERE NOT EXISTS (
SELECT 1
FROM raw.category_translation ct
WHERE ct.product_category_name = p.product_category_name
)order by p.product_category_name desc ;--623 610 is null and 13 have value