-- Write a query to identify customers who have made consecutive purchases on back-to-back days and where 
-- each purchase amount was above a specific threshold (e.g., $100).
-- The goal is to find customers who have a pattern of frequent and significant purchases.

if exists (select name from sys.tables where name='purchases_info')
drop table purchases_info

CREATE TABLE purchases_info (
    purchase_id INT PRIMARY KEY,
    customer_id INT,
    purchase_date DATE,
    amount DECIMAL(10, 2)
);

INSERT INTO purchases_info (purchase_id, customer_id, purchase_date, amount) VALUES
(1, 101, '2024-11-01', 150),
(2, 101, '2024-11-02', 200),
(3, 101, '2024-11-05', 90),
(4, 101, '2024-11-06', 120),
(5, 102, '2024-11-01', 110),
(6, 102, '2024-11-02', 130),
(7, 102, '2024-11-03', 140),
(8, 103, '2024-11-01', 50),
(9, 103, '2024-11-04', 110),
(10, 104, '2024-11-02', 150),
(11, 104, '2024-11-03', 200),
(12, 104, '2024-12-01', 100),
(13, 104, '2024-12-02', 110);



-- method 1
with cte1 as (
select 
*,
-- sum(amount) over(partition by customer_id order by purchase_date,purchase_id) as total_sum,
row_number() over(partition by customer_id order by purchase_date,purchase_id) as row_id
from purchases_info
where amount>100
),
cte2 as(
select
*,
DATEADD(day, -row_id,purchase_date) as streak
from cte1

)

select 
customer_id,
MIN(purchase_date) as [start_date],
Max(purchase_date) as end_date,
SUM(amount) as total_amount
from cte2
GROUP by customer_id, streak
HAVING count(*)>=2





-- method 2
WITH SignificantPurchases AS (
    SELECT 
        customer_id,
        purchase_date,
        amount,
        LAG(purchase_date) OVER (PARTITION BY customer_id ORDER BY purchase_date) AS prev_purchase_date
    FROM purchases_info
    WHERE amount > 100
)

SELECT DISTINCT 
    customer_id
FROM SignificantPurchases
WHERE DATEDIFF(day, prev_purchase_date, purchase_date) = 1;