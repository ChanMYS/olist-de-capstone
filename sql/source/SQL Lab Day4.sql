-- Q1. NULL audit: count NULLs in product_category_name and product_weight_g.

select count(p.product_category_name) from products p where p.product_category_name is null

select count(*) from products p where p.product_weight_g is null

--Q2. For each month of purchase, what is the average delivery time, 
--and how many orders (and what percentage) were delivered within 30 days of purchase?

select  * from orders

with monthCTE as (
select TO_CHAR(order_purchase_timestamp, 'YYYY-MM') as purchase_month
,EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400.0 AS delivery_time
from orders
where order_status = 'delivered'
) 
select purchase_month, 
ROUND(AVG(delivery_time)::numeric, 2) AS avg_delivery_days,
count(*) as total_orders,
(SUM(CASE WHEN delivery_time <= 30 THEN 1 
			ELSE 0 END) /100.0)  AS percentage_within_30_days

from monthCTE
group by purchase_month 


--Q.3On which day of the week do customers place the most orders? 
--Show each weekday’s name and number, and the total orders for that day, 
--sorted from busiest to quietest.

SELECT 
    TO_CHAR(order_purchase_timestamp, 'ID')::INTEGER AS weekday_number,
    TO_CHAR(order_purchase_timestamp, 'Day') AS weekday_name,
    COUNT(order_id) AS total_orders
 from orders 
GROUP BY weekday_number, weekday_name
ORDER BY total_orders DESC;

--Q.4 What is the total revenue for each product category, shown with its English name? 
--If a category has no English translation, show the original Portuguese name instead. 
--If the product has no category at all, show it as ‘unknown’.


select COALESCE(
        ct.product_category_name_english, 
        ct.product_category_name, 
        'unknown'
    ) AS category_name, sum(oi.price + oi.freight_value ) as total_revenue
 from order_items oi 
join products p on oi.product_id = p.product_id 
join category_translation ct on p.product_category_name = ct.product_category_name 
group by ct.product_category_name_english, ct.product_category_name
order by 1


/*Q.5 Group delivered orders by delivery speed:
• Fast: 7 days or less from purchase to delivery.
• Normal: 8 to 14 days.
• Slow: 15 to 30 days.
• Very slow: more than 30 days.
How many orders fall into each group, and what percentage of the total is each?
*/

WITH deliveryCTE AS (
    SELECT 
        order_id,
        EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400.0 AS delivery_days
    FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
      AND order_purchase_timestamp IS NOT NULL
),
groupCTE AS (
    SELECT 
        order_id,
        CASE 
            WHEN delivery_days <= 7 THEN 'Fast'
            WHEN delivery_days > 7 AND delivery_days <= 14 THEN 'Normal'
            WHEN delivery_days > 14 AND delivery_days <= 30 THEN 'Slow'
            ELSE 'Very slow'
        END AS delivery_group,
        CASE 
            WHEN delivery_days <= 7 THEN 1
            WHEN delivery_days > 7 AND delivery_days <= 14 THEN 2
            WHEN delivery_days > 14 AND delivery_days <= 30 THEN 3
            ELSE 4
        END AS group_order_total
    FROM deliveryCTE
)
SELECT 
    delivery_group,
    COUNT(order_id) AS total_orders,
    COUNT(order_id) / 100 AS percentage_of_total
FROM groupCTE
GROUP BY delivery_group, group_order_total
ORDER BY group_order_total;
