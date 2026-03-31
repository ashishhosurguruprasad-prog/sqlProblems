-- Question:- Club Table has three columns namely Club_ID, Member_id and Rewards.
-- Same member fan be a part of different club. The 'rewards' column has different rewards. The points for these awards are as follows :-
-- MM - 0.5, CI - 0.5, CO- 0.5, CD - I, CL-I, CM - I Write a SQL query to find the total points scored by each club.


-- create table club(
-- club_id int,
-- member_id int,
-- rewards varchar(20));

-- insert into club
-- values(1001,210, null),(1001,211,'MM:CI'),(1002,215,'CD:CI:CM'),
-- (1002,216,'CL:CM'),(1002,217,'MM:CM'),(1003,255,null),
-- (1001,216,'CO:CD:CL:MM'),(1002,210,null)

-- select * from club


;with t1 as (
select c.*, saa.[value] as rewards2  from club as c
cross APPLY STRING_SPLIT(c.rewards, ':') as saa
),
t2 as (
select 
*,
case upper(rewards2)
when 'MM' then 0.5
when 'CI' then 0.5
when 'CO' THEN 0.5
-- when 'CD' THEN 'I'
-- when 'CL' THEN 'I'
-- when 'CM' THEN 'I'
else 1
end as valuese
from t1
)

select 
club_id,
sum(cast(valuese as float)) as sum
from t2
GROUP BY club_id
