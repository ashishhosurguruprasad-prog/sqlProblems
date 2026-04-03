-- how would you find the longest sequence of consecutive days a customer placed orders?

if exists (select name from sys.tables where name='Customer_Order')
drop table Customer_Order

CREATE TABLE Customer_Order (
    CustomerID INT,
    OrderDate DATE,
    OrderID INT PRIMARY KEY
);

INSERT INTO Customer_Order (CustomerID, OrderDate, OrderID)
VALUES
(1, '2025-01-01', 101),
(1, '2025-01-02', 102),
(1, '2025-01-04', 103),
(1, '2025-01-05', 104),
(1, '2025-01-07', 105),
(2, '2025-01-01', 106),
(2, '2025-01-02', 107),
(2, '2025-01-03', 108),
(3, '2025-01-01', 109),
(3, '2025-01-03', 110);

select * from customer_order;

with cte1 as (
SELECT 
        CustomerID, 
        OrderDate,
        DATEADD(day, -ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate), OrderDate) AS IslandID
    FROM Customer_Order
),

cte2 as (select
customerid, 
count(*) as streak_length
from cte1
group by customerid, islandid
)

select 
      customerid,
      max(streak_length) as max_streak 
from cte2
group by customerid
having max_streak = (select max(streak_length) from cte2)