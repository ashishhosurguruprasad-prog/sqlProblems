-- Write a solution to report the customer ids from the Customer (customer_prod) table
--that bought all the products in the Product (product_list) table.

/*
create table customer_prod(
customer_id int,
product_key int
)

create table product_list(
product_key int
)

insert into customer_prod(customer_id, product_key)
values(1,5),
(2,6),
(3,5),
(3,6),
(1,6)

insert into product_list(product_key)
values(5),(6)

*/

with t1 as(
select 
cp.customer_id,
pl.product_key
from customer_prod as cp
full join product_list as pl on cp.product_key= pl.product_key
)

SELECT
isnull(customer_id, 0) as customer_id
-- count(product_key) as count
from t1
GROUP BY customer_id
having count(product_key)= (select count(distinct(product_key)) from product_list)


-- run this code below after you think the quesry is working fine and then again run your query and you should get null

-- TRUNCATE table product_list


-- insert into product_list(product_key)
-- values(8),(9)
