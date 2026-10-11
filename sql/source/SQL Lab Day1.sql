-- Q1 How many customers are there in each state? Show the top 5 states.

select customer_state, count(*) as total_count from customers 
group by customer_state 
order by total_count desc
limit 5

-- Q2 How many distinct real customers (customer_unique_id) are there?

select count( distinct customer_unique_id ) from customers

-- Q3 Which payment_type is used most, and what is its total payment_value?

select payment_type, count(*) as total_count_of_types, sum(payment_value )
from order_payments
group by payment_type 
order by total_count_of_types desc;

select * from order_payments


--Q4. How many reviews are there for each review_score (1 to 5)? What is the overall average score?

select review_score, count(*) as reviews_count
from order_reviews
group by review_score ;

select AVG(review_score) as avg_review_score
from order_reviews;


--Q5. Sellers by state: which states have more than 50 sellers?
select seller_state, count(seller_id) as seller_total from sellers
group by seller_state 
having  count(seller_id ) > '50'
;

--Q6. Average price and freight per order item, rounded to 2 decimals.

select order_item_id, round(avg(price),2) as avg_price, round(avg(freight_value),2) as avg_freight_value
from order_items
group by order_item_id 
order by order_item_id
