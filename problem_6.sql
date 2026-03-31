--Question 1: Each team play with every other team only once?
--Question 2: Each team plays with every other team twice?


/*
create table team_table
    (
        team_code       varchar(10),
        team_name       varchar(40)
    );

insert into team_table values ('IND', 'India');
insert into team_table values ('AUS', 'Australia');
insert into team_table values ('ENG', 'England');
insert into team_table values ('NZ', 'New Zealand');
insert into team_table values ('SA', 'South Africa');

*/


SELECT * From team_table


-- question 1
select 
t1.team_code,
t2.team_code as team_code2
from team_table as t1
cross join team_table as t2 where t1.team_code > t2.team_code

--question 2
select 
t2.team_code as team_code2, 
t1.team_code 
from team_table as t1
cross join team_table as t2
where t1.team_code!= t2.team_code