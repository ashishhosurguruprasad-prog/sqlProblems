/*
Given an input (tab_sequence) table with two columns Group and Sequence.
Write a query to find the maximumn and minimum values of the continuous 'Sequence' in
each 'Group'.
*/



-- create table tab_sequence(
-- [group] varchar(20),sequence int)

-- insert into tab_sequence([group],sequence)
-- values('A',1),('A',2),('A',3),('A',5),('A',6),
-- ('A',8),('A',9),('B',11),('C',1),('C',2),('C',3)



with cte1 as (
select 
*,
row_number() over(partition by [group] order by [SEQUENCE] ) as flag,
[sequence]- row_number() over(partition by [group] order by [SEQUENCE]) as diff
from tab_sequence
)

select distinct
[group],
min([sequence]) over(partition by diff,[group]) as min_seq,
max([sequence]) over(partition by diff,[group]) as max_seq
from cte1