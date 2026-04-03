/*
You are given a table, Tasks, containing three columns: Task_ID, Start_Date and End_Date.
It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.
If the End_Date of the tasks are consecutive, then they are part of the same project.
The manager is interested in finding the total number of different projects completed.
Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. I
If there is more than one projectlthat have the same number of completion days, then order by the start date of the project.
*/


if exists (select name from sys.tables where name='tasks')
drop table tasks


;create table tasks(task_id int,
start_date date,
end_date date)

;insert into tasks(task_id,start_date,end_date)
values(1,'2024-10-01','2024-10-02'),(2,'2024-10-02','2024-10-03'),(3,'2024-10-03','2024-10-04'),(4,'2024-10-13','2024-10-14'),(5,'2024-10-14','2024-10-15'),(6,'2024-10-28','2024-10-29'),
(7,'2024-10-30','2024-10-31');


with cte1 as (
select 
      *,
      cast(dateadd(day, -row_number() over(order by end_date),end_date) as date) as anchor_date
from tasks
),
cte2 as (
select
      row_number() over(order by anchor_date) as project,
      min(start_date) as start_date,
      max(end_date) as end_date
from cte1
group by anchor_date
)
select
      *,
      datediff(day, start_date, end_date) as total_days_per_project
from cte2


