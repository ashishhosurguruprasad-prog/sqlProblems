-- Write a SQL query to 'Forward Fill' the company column so that every car 
-- has its correct brand name associated with it, ensuring the fill stops and changes whenever a new non-null brand appears.



-- IF OBJECT_ID('vehicle','U') is not NULL
-- drop table vehicle

-- CREATE TABLE [dbo].[vehicle](
-- 	[car_id] [int] IDENTITY(1,1) NOT NULL,
-- 	[company] [varchar](100) NULL,
-- 	[car] [varchar](100) NULL
-- )
-- SET IDENTITY_INSERT vehicle ON; -- this is use because when we crreated the 
--                                 -- table we have instructed the db to create the car_id by having  
--                                 -- "identity" command but while inserting the data we are forcing a value 
--                               -- into the table to avoid a error we are using the "set" command
-- TRUNCATE table vehicle
-- INSERT INTO [vehicle](car_id,company,car)
-- values(1,'Mercedes','A-class'),
-- (2,	NULL,'GLE'),
-- (3,	NULL,'G-class'),
-- (4,	NULL,'CLS'),
-- (5,'Audi','audi q7'),
-- (6,	NULL,'aud q3'),
-- (7,	NULL,'audi-etron'),
-- (8,'Lexus','lexus es'),
-- (9,	NULL,'lexus lc'),
-- (10,NULL,'NX')

-- SET IDENTITY_INSERT vehicle OFF;-- this is use because when we crreated the 
--                                 -- table we have instructed the db to create the car_id by having  
--                                 -- "identity" command but while inserting the data we are forcing a value 
--                               -- into the table to avoid a error we are using the "set" command



;with cte1 as (
SELECT 
        car_id,
        company,
        car,
        -- This creates a group ID that stays the same until a new brand appears
        COUNT(company) OVER (ORDER BY car_id) as grp
    FROM vehicle
)

select 
car_id,
max(company) over(partition by grp order by car_id) as company,
car
from cte1

