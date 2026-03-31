-- -- Write a SQl to display the Source_Phone_Nor and a flag where
-- the flag needs to be set to 'y' if first called number and last called number are the same and
-- 'N' if first called number and last called number are different




-- create table phone_log(
-- source_phone_nbr int, destination_phone_nbr int,
-- call_start_date_time datetime)

-- insert into phone_log
-- values(2345,6789,'2099-07-01 10:00:00'),
-- (2345,1234,'2099-07-01 11:00:00'),
-- (2345,4567,'2099-07-01 12:00:00'),
-- (2345,4567,'2099-07-01 13:00:00'),
-- (2345,6789,'2099-07-01 15:00:00'),
-- (3311,7890,'2099-07-01 10:00:00'),
-- (3311,6543,'2099-07-01 12:00:00'),
-- (3311,1234,'2099-07-01 13:00:00')




-- method-1



with cte1 as(
SELECT 
        source_phone_nbr,
        destination_phone_nbr,
        ROW_NUMBER() OVER(PARTITION BY source_phone_nbr ORDER BY call_start_date_time ASC) as first_rank,
        ROW_NUMBER() OVER(PARTITION BY source_phone_nbr ORDER BY call_start_date_time DESC) as last_rank
    FROM phone_log
)
SELECT 
    -- f.source_phone_nbr,
    CASE 
        WHEN t1.destination_phone_nbr = t2.destination_phone_nbr THEN 'Y' 
        ELSE 'N' 
    END AS flag,
t1.source_phone_nbr,
t1.destination_phone_nbr as dest1,
t2.destination_phone_nbr as dest2
FROM cte1 t1
JOIN cte1 t2 ON t1.source_phone_nbr = t2.source_phone_nbr
WHERE t1.first_rank = 1  -- This is the first call row
  AND t2.last_rank = 1;  -- This is the last call row


-- method-2 


;WITH CallBounds AS (
    SELECT 
        source_phone_nbr,
        destination_phone_nbr,
        -- Get the first destination called for this source
        FIRST_VALUE(destination_phone_nbr) OVER (
            PARTITION BY source_phone_nbr 
            ORDER BY call_start_date_time
        ) AS first_call,
        -- Get the last destination called for this source
        -- Note: ROWS BETWEEN is necessary for LAST_VALUE to see the whole partition
        LAST_VALUE(destination_phone_nbr) OVER (
            PARTITION BY source_phone_nbr 
            ORDER BY call_start_date_time
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS last_call
    FROM phone_log
)
SELECT DISTINCT
    source_phone_nbr,
    CASE 
        WHEN first_call = last_call THEN 'Y' 
        ELSE 'N' 
    END AS flag
FROM CallBounds;


-- method-3

;with cte1 as(
SELECT 
        source_phone_nbr,
        destination_phone_nbr,
        ROW_NUMBER() OVER(PARTITION BY source_phone_nbr ORDER BY call_start_date_time ASC) as flag
from phone_log
),
cte2 as(
select *, max(flag) over(partition by source_phone_nbr) as max from cte1
)

select 
t1.source_phone_nbr,
t1.destination_phone_nbr as dest1,
t2.destination_phone_nbr as dest2,
t1.flag as f1,
t1.max as m1,
t2.flag as f2,
case when t1.destination_phone_nbr=t2.destination_phone_nbr then 'Y'
else 'N'
end as flag 
from cte2 as t1
join cte1 as t2 on t1.source_phone_nbr= t2.source_phone_nbr
WHERE t1.flag = 1  -- Only the first call from the first table
  AND t2.flag = t1.max