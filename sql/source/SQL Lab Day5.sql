--Q1 Top 3 in each state
with sellerCTE as (
select s.seller_id, s.seller_state, sum(oi.price + oi.freight_value ) as revenue
from order_items oi 
join sellers s on oi.seller_id = s.seller_id 
group by s.seller_id, s.seller_state
), 
ranked as (
select s.*, rank() over (partition by seller_state order by revenue desc) as rnk
from sellerCTE s
)
select * from ranked
where rnk<='3'
order by seller_state , revenue desc

--Q2 
select c.customer_unique_id, min (cast(o.order_purchase_timestamp as date)) as first_order  
,count(o.order_id) over(partition by c.customer_unique_id) as order_count
,rank() over(partition by c.customer_unique_id order by cast(o.order_purchase_timestamp as date)) as date_rnk
from orders o 
join customers c on o.customer_id = c.customer_id 
group by c.customer_unique_id,o.order_id
;
