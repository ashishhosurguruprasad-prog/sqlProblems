-- Requirement :
-- Write a query that (as efficiently as possible) will return only new INSERTS into ORDER since the snapshot was taken (record is in ORDER, but not ORDER_COPY) OR only new DELETES from ORDER since the snapshot was taken (record is in ORDER_COPY, but not ORDER).
-- The query should return the Primary Key (ORDER_ID) and a single character
-- ('INSERT_OR_DELETE_FLAG") of "I" if it is an INSERT, or "D" if it is a DELETE.


-- create table orders_yt (
-- order_id int,
-- order_date date
-- )

-- insert into orders_yt(order_id,order_date)
-- values(1,'10-11-2022'),
-- (2,'09-11-2022'),
-- (3,'08-11-2022'),
-- (4,'07-11-2022'),
-- (5,'06-11-2022'),
-- (6,'05-11-2022'),
-- (7,'03-11-2022')

-- --create table orders_copy
-- --taking the copy of orders to orders_copy
-- select * into orders_copy_yt from orders_yt

-- --insert new records to orders
-- insert into orders_yt(order_id,order_date)
-- values(8,'02-11-2022'),
-- (9,'01-11-2022')

-- delete from orders_yt
-- where order_id in (1,2)


select 
*
FROM orders_yt

select 
*
FROM orders_copy_yt


-- solution 1-----left join --------
select o.order_id,
case when c.order_id is null then 'I'
when o.order_id is null then 'I'
end as flag
from orders_yt as o
left join orders_copy_yt as c on o.order_id=c.order_id
where c.order_id is null
UNION all
select order_id , 'D' as flag from orders_copy_yt as c
where not EXISTS (select 1 from orders_yt as o where o.order_id=c.order_id)


-- solution 2 ----- outer join------
select coalesce(o.order_id, c.order_id) as order_id,

case when c.order_id is null then 'I'
when o.order_id is null then 'D' 
end as flag from orders_yt as o
full outer join orders_copy_yt as c 
on o.order_id = c.order_id

where c.order_id is null or o.order_id is null
order by order_id


-- solution 2 ----except--

select order_id, 'I' as flag from orders_yt
except 
select order_id, 'I' as flag from orders_copy_yt


union ALL

select order_id, 'D' as flag from orders_copy_yt
except 
select order_id ,'D' as flag from orders_yt



