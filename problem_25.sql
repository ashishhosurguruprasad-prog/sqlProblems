--Find Duplicates and Keep Latest
--Identifying and removing redundant data while preserving the most current record.

if exists (select name from sys.tables where name='sample_users')
drop table sample_users


;CREATE TABLE sample_users (user_id INT PRIMARY KEY, username VARCHAR(50), email VARCHAR(100), account_create_date TIMESTAMP);
INSERT INTO sample_users (user_id, username, email, account_create_date) VALUES 
(101, 'johndoe', 'john.doe@sample.com','2099-02-15 08:30:00'),
(102, 'janedoe','jane.doe@sample.com', '2099-03-01 10:45:00'),
(104, 'alice.smith','alice.smith@sample.com', '2099-04-20 09:00:00'),
(105,'johndoe_dup', 'john.doe@sample.com', '2099-05-14 12:00:00'),
(106, 'bob.white','bob.white@sample.com', '2099-06-19 15:30:00'),
(107, 'johndoe_latest', 'john.doe@sample.com', '2099-07-21 11:45:00'),
(108,'laura.parker', 'laura.parker@sample.com', '2099-08-25 10:00:00'),
(109, 'sara.kim', 'sara.kim@sample.com', '2099-09-15 14:30:00'),
(110, 'tom. jones','tom.jones@sample.com', '2099-12-05 18:00:00'),
(111, 'new_user', 'new.user@sample.com', '2099-11-01 09:00:00'),
(115, 'jane_doe', 'jane.doe@sample.com','2099-05-01 10:45:00'),
(117, 'sara_kim', 'sara.kim@sample.com', '2099-06-01 10:45:00');



-- Solution 1: to check if there are duplicates (group by method)

select 
      email,
      count(email) as count
from sample_users
group by email;

-- solution 2: to delete the duplicates (window fucntion)

with cte1 as (
select
      *,
      row_number() over(partition by email order by account_create_date desc) as rn
from sample_users
)
delete from sample_users
where user_id in (select user_id from cte1 where rn>1)

select * from sample_users

