-- Write a query to find the customers who have placed more than one order and the total amount spent by them.


--Orders Table:
create table order_info(OrderID int,
CustomerID int,
OrderDate date,
Amount int)

insert into order_info(OrderID,	CustomerID,	OrderDate,	Amount)
values(1,	101,	'2099-01-10',	250),
(2,	102,	'2099-02-15',	450),
(3,	101,	'2099-03-12',	300),
(4,	103,	'2099-04-25',	500)

--Customers Table:
create table customer_info(
CustomerID int,
CustomerName varchar(20),	
Country varchar(20)
)

insert into customer_info(CustomerID,	CustomerName,	Country)
values(101,	'Alice',	'USA'),
(102,	'Bob',	'Canada'),
(103,	'Charlie',	'USA'),
(104,	'David',	'UK')


-- Solution 1

select
      o.CustomerID,
      c.CustomerName,
      sum(o.amount) as total_amount
from order_info as o
join customer_info as c on c.CustomerID=o.CustomerID
group by o.customerId, c.CustomerName
having count(*)>1


-- Solution 2

select 
    o.customerid,
    c.CustomerName,
    o.total_amount 
from (
    select
      customerid,
      sum(amount) over(partition by customerid) as total_amount,
      count(*) over(partition by customerid) as order_count
from order_info
order by CustomerID) as o 
join customer_info as c on o.customerid=c.customerid
where o.order_count>1
group by o.customerid,o.total_amount,o.order_count, c.CustomerName
