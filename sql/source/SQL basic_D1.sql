select * from orders limit 10;

select order_id, order_status as status
from orders limit 10;

select distinct order_status from orders;

select order_id, order_status from orders where order_status = 'delivered'

select distinct order_status from orders where order_status <> 'canceled'

select customer_id, customer_state 
from customers 
where customer_state in ('SP','SC','MG');

select * from order_items
where price between 10 and 50

select * from customers 
where customer_city like 'sao%'

select order_id,product_id,price
from order_items
order by price desc 
limit 10

select price+freight_value as total_paid,order_id
from order_items 
order by total_paid, order_id
limit 10

-- Aggerate Function
select order_status,count(*) 
from orders
group by order_status ;

select count(*),customer_state
from customers 
where customer_state <> 'SP'
group by customer_state

select seller_id, count(*) item_sold
from order_items 
group by seller_id
having count(*) > 100

