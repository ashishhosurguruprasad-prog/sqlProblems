-- --? Question
-- Employee 'A' is asked to compute the average salary of all employees from the "employee_salary' table
-- --he created but realized that the zero key in his keyboard is not working after the result showed a very less average.
-- --He wants to find out the actual average and
-- --difference between miscalculated average and actual average.


create table employee_salary(
emp_id int not null,
name varchar(50),
salary int
)
;
insert into employee_salary(emp_id, name, salary)
values(110, 'sam', 156),
(111, 'tina', 18),
(112, 'toto', 4),
(113, 'jack', 234),
(114, 'lewis', 32),
(115, 'george', 2),
(116, 'alex', 23),
(117, 'sheldon', 34),
(118, 'tom', 3),
(119, 'tony', 32)


-- solution 1 

with cte1 as (
select 
      *,
      5-len(salary) as len_missing,
      repeat(0,5-len(salary)) as num_to_add
from employee_salary
),
cte2 as (
select 
      emp_id,
      name,
      salary,
      cast(final_salary as int) as final_salary
from (
select
      *,
      concat(salary,num_to_add) as final_salary
from cte1)t
)

select avg_final-avg_miss from(
select
avg(final_salary) as avg_final,
avg(salary) as avg_miss
from cte2
)t
;

---solution 2

SELECT 
    -- Calculate both averages and subtract in one step
    AVG(CAST(RPAD(salary, 5, '0') AS INT)) - AVG(salary) AS total_delta
FROM employee_salary;