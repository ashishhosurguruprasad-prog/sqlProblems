-- https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbmx3eElfWVhjR04zQmZCdVplWjAyU0FZQ04wd3xBQ3Jtc0tuV1gzT2J4Vk5PeFgyMDJGSlh2S0FNT0JmSU5hUjdFeTFRLVRQRUx5Y2kwWGtpazh6SFVJbUowc0l3TDZuR2FEVFRqLXY1dXdkNWxtSnJMb053WGRmQ09mNlV3bFJpMzVTeTNNQ0lJS1NMMG1UYldxWQ&q=https%3A%2F%2Fplatform.stratascratch.com%2Fcoding%2F10064-highest-energy-consumption%3Fcode_type%3D5&v=g38Bn1p7GvY

-- solution :


with cte1 as  (
        select 
            * 
        from fb_eu_energy
    union all
        select 
            * 
        from fb_asia_energy
    union all 
        select 
            * 
        from fb_na_energy
),
cte2 as (
        select
            *,
            sum (consumption) over(partition by recorded_date) as total_energy
        from cte1
),
cte3 as (
        select 
            recorded_date,
            max(total_energy) as total_energy
        from cte2
        group by recorded_date
)
select 
        recorded_Date, 
        total_energy 
from (
select 
        recorded_date,
        total_energy,
        dense_rank() over(order by total_energy desc) as rk
from cte3)t
where rk=1


