/*
Find the most expensive ('Exp_Product) and the least expensive ('Che_Product) product of a particular category with every row of the table using first_ value' and last_ value' window
functions.
Limitation :- There is a default frame that SQL uses with every window function.
The default FRAME is a 'range between unbounded preceding and current row'.
*/


if exists (select name from sys.tables where name='STATIONERY')
drop table STATIONERY

Create Table STATIONERY(
Category VARCHAR(20),
Brand VARCHAR(20),
Product_Name VARCHAR(20),
Price int,
Primary Key(Product_Name));

INSERT INTO STATIONERY VALUES('Pen','Alpha','Alpen',280),
('Pen','Fabre','Fapen',250),
('Pen','Camel','Capen',220),
('Board','Alpha','Alord',550),
('Board','Fabre','Faord',400),
('Board','Camel','Carod',250),
('Notebook','Alpha','Albook',250),
('Notebook','Fabre','Fabook',230),
('Notebook','Camel','Cabook',210);


with cte1 as (
select
      *,
      first_value(Product_Name) over(partition by category order by price desc range between unbounded preceding and unbounded following) as max_product,
      last_value(Product_Name) over(partition by Category order by price desc range between unbounded preceding and unbounded following) as min_product
from stationery
)

select distinct
      Category,
      max_product,
      min_product
from cte1
