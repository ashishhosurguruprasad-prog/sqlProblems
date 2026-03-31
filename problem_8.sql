 --Write a SQL query to find customers who increased their spending each month compared to the previous month.

 /*
CREATE TABLE Orders_Info (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2)
);


INSERT INTO Orders_Info (order_id, customer_id, order_date, amount) VALUES
(501, 1, '2099-01-10', 300),
(502, 2, '2099-01-15', 500),
(503, 1, '2099-02-12', 400),
(504, 1, '2099-03-10', 600),
(505, 2, '2099-02-18', 450),
(506, 2, '2099-03-20', 470),
(507, 1, '2099-04-21', 700);

 */



select 
*
from Orders_Info


;with cte1 as (
select 
customer_id,
YEAR(order_date) as year,
MONTH(order_date) as MONTH,
sum(amount)as total_amount
from Orders_Info
GROUP by customer_id,YEAR(order_date),MONTH(order_date)
),
cte2 as (
select 
*,
lead(total_amount,1,total_amount) over(partition by customer_id order by year, month) as next_month_amount
from cte1
),
cte3 as (
SELECT
*,
next_month_amount-total_amount as diff
from cte2
),

cte4 as (
select customer_id, MIN(diff) as flag
from cte3
GROUP by customer_id
)

select 
customer_id
from cte4
where flag>=0










-- try this insertion after the query to test if your query is working fine

-- insert into Orders_Info(order_id,customer_id,order_date,amount)
-- values(777,1,'2099-01-11',777.00)


-- delete from Orders_Info
-- where order_id=777


