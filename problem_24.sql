/*
Transform a column with comma-separated product categories into individual rows for detailed analysis and count the number 
of product categories each customer ordered
*/

if exists (select name from sys.tables where name='ecomm_orders')
drop table ecomm_orders

create table ecomm_orders(
order_id int primary key,
customer_name varchar(20),
product_categories varchar(255)
);

insert into ecomm_orders(order_id, customer_name, product_categories)
values(101, 'John Doe', 'Electronics, Home, Kitchen'),
(102, 'Jane Smith', 'Fashion, Beauty'),
(103, 'Mike Brown', 'Sports, Fitness, Outdoors')


select 
      order_id,
      customer_name,
      count(*) as count
from (
select
      order_id,
      customer_name,
      explode(split(product_categories,',')) as product
from ecomm_orders
)t
group by order_id,customer_name