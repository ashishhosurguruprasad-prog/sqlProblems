-- Obtain the output in the required format?

/*
create table subject_info(
class varchar(20),
subject varchar(20))

insert into subject_info(class, subject)
values('A','Maths'),
('B','English'),
('A','Social'),
('B','Chemistry'),
('A','Physics'),
('B','Statistics'),
('A','Biology'),
('B','Maths'),
('A','Science'),
('B','Social')
*/





with t1 as (
select
*,
ROW_NUMBER() over(partition by class order by (select null)) as row_number

from subject_info
),
t2 as (
select 
*,
case when row_number=1 then subject 
else null
end as sub1,
case when row_number=2 then subject 
else null
end as sub2,
case when row_number=3 then subject 
else null
end as sub3,
case when row_number=4 then subject 
else null
end as sub4,
case when row_number=5 then subject 
else null
end as sub5
from t1

)

select
class, 
max(sub1) as sub1,
max(sub2) as sub2,
max(sub3) as sub3,
max(sub4) as sub4,
max(sub5) as sub5
from t2
group by class
