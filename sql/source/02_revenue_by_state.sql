-- Q1.Revenue (SUM of price) by customer_state for delivered orders. Top 10 states.

select * from orders;

select c.customer_state ,count(c.customer_state ) as total_state, sum(oi.price ) as revenue
from customers c 
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
where o.order_status='delivered'
group by c.customer_state 
order by total_state desc
limit 10;

--Q.2 How many orders have no review at all? (anti-join)

select count(1) as noreview_count from orders 
where order_id not in (select order_id from order_reviews) ;


--Q;3: Top 10 product categories in English by items sold. Why LEFT JOIN to the translation?

select product_category_name_english ,count(1) as total_count
from category_translation ct 
join products p on ct.product_category_name = p.product_category_name 
join order_items oi on p.product_id = oi.product_id 
group by product_category_name_english
order by total_count desc
limit 10;

--Q4. What share of order items were sold by a seller in the same state as the customer?

select  c.customer_state, s.seller_state ,count(oi.order_item_id )
from order_items oi 
join orders o on oi.order_id = o.order_id 
join customers c on o.customer_id = c.customer_id
join sellers s on oi.seller_id = s.seller_id and  c.customer_state = s.seller_state 
group by c.customer_state, s.seller_state
;

--Q5. For 5 orders, show item revenue and payment total side by side — without fan-out.

select oi.order_id ,sum(oi.price ) as revenue ,op.payment_type  
from  order_items oi 
join order_payments op on  oi.order_id = op.order_id
group by oi.order_id ,op.payment_type
order by revenue desc
limit 5;


--Q6. Find orders where payments differ from price + freight by more than 1.00.


select distinct oi.order_id , op.payment_value,(oi.price + oi.freight_value) as total_price
,op.payment_value - (oi.price + oi.freight_value) as differ_amt
from order_items oi 
join order_payments op on oi.order_id = op.order_id 
where op.payment_value - (oi.price + oi.freight_value ) > 1.00
