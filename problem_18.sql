/*
Write an SQL query to determine the number of days between the first "Shipped" order and the first "Delivered" order for each customer.
If a customer does not have both types of orders, they should not be included in the results.
Note: - first "Deilvered" order after "Shipped" order should be considered
*/
;

if exists (select name from sys.tables where name='customer_orders')
drop table customer_orders

create table customer_orders(order_id int,
customer_id int,
order_date date,
status varchar(20));

insert into customer_orders(order_id, customer_id, order_date, status)
values(1, 1001, '2024-08-01', 'Shipped'),
(2, 1001, '2024-08-02', 'Delivered'),
(3, 1002, '2024-08-01', 'Shipped'),
(4, 1002, '2024-08-05', 'Shipped'),
(5, 1003, '2024-08-02', 'Delivered'),
(6, 1003, '2024-08-10', 'Shipped'),
(7, 1003, '2024-08-15', 'Delivered');


with cte1 as (
select
      customer_id,
      min(order_date) as min_shipped_date
from customer_orders as c1
where lower(status)='shipped'
group by customer_id
)
,cte2 as (
select 
      c1.customer_id, 
      c1.min_shipped_date,
      min(c2.order_date) as min_delivery_date 
from cte1 as c1
join customer_orders as c2 on c1.customer_id=c2.customer_id
where lower(c2.status)='delivered' and c2.order_date>c1.min_shipped_date
group by c1.customer_id, c1.min_shipped_date
)

select
      *,
      datediff(day,min_shipped_date,min_delivery_date) as difference
from cte2
