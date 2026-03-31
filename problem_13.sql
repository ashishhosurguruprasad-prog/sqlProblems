-- Find the least number of products and list the products that contribute to 80 percent or more of the sales?


-- use MyDatabase
-- if exists(SELECT * FROM sys.tables WHERE name = 'walmart')
-- BEGIN
-- drop table walmart
-- end

-- CREATE TABLE walmart (
--     ProductID INT PRIMARY KEY,
--     Name VARCHAR(50),
--     Sales int
-- );

-- -- Insert data into the table
-- INSERT INTO walmart (ProductID, Name, Sales) VALUES
-- (1, 'Laptop', 7500),
-- (2, 'Smartphone', 6000),
-- (3, 'Furniture', 2500),
-- (4, 'Headphones', 800),
-- (5, 'Smartwatch', 700),
-- (6, 'Books', 500),
-- (7, 'Keyboard', 300),
-- (8, 'Bags', 200),
-- (9, 'Charger', 200),
-- (10, 'Toys', 100),
-- (11, 'Peronal Care', 100);


with cte1 as(
select 
*,
sum(sales) over(order by sales desc, productid) as running_sales,
sum(sales) over() as total_sales
from walmart
),
cte2 AS (
    SELECT 
        *,
        -- 3. Calculate what percentage of total sales we have reached so far
        (CAST(running_sales AS FLOAT) / total_sales) * 100 AS cumulative_percentage
    FROM cte1
)
SELECT 
    ProductID, 
    Name, 
    Sales, 
    ROUND(cumulative_percentage, 2) AS [Cumulative %]
FROM cte2
WHERE cumulative_percentage - (CAST(Sales AS FLOAT) / total_sales * 100) < 80;


-- run this to test once you write your query
-- insert into walmart(ProductID, Name, Sales) values(12, 'mac', 1),
-- (13, 'airpods', 10)


-- delete from walmart
-- where productid in(12,13)