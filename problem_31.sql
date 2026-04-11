/*
Calculate the Total Unique Time (in minutes) the user was active. In the example above, U1 was active from 10:00 to 12:00 
(one continuous block) and 13:00 to 14:00.
*/

CREATE TABLE user_sessions (
    user_id VARCHAR(10),
    session_start TIMESTAMP,
    session_end TIMESTAMP
);

INSERT INTO user_sessions (user_id, session_start, session_end) VALUES
('U1', '10:00', '11:00'),
('U1', '10:30', '12:00'), -- This overlaps with the first session!
('U1', '13:00', '14:00');


WITH cte1 AS (
    SELECT
        user_id,
        session_start,
        session_end,
        MAX(session_end) OVER (
            PARTITION BY user_id 
            ORDER BY session_start 
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS max_end_so_far
    FROM user_sessions
),
cte2 AS (
    SELECT
        *,
        CASE 
            WHEN session_start <= max_end_so_far THEN 0 -- Continuation
            ELSE 1 -- Brand New Island
        END AS is_new_island
    FROM cte1
),
cte3 AS (
    SELECT
        *,
        -- Running sum creates a unique ID for each "Super-Session"
        SUM(is_new_island) OVER (
            PARTITION BY user_id 
            ORDER BY session_start
        ) AS island_id
    FROM cte2
),
cte4 AS (
    SELECT 
        user_id,
        island_id,
        MIN(session_start) AS super_start,
        MAX(session_end) AS super_end
    FROM cte3
    GROUP BY user_id, island_id
)
-- FINAL RESULT: Total Unique Time per User
SELECT 
    user_id,
    -- SQL Server: DATEDIFF(MINUTE, super_start, super_end)
    -- Databricks: (CAST(super_end AS LONG) - CAST(super_start AS LONG)) / 60
    SUM(DATEDIFF(MINUTE, super_start, super_end)) AS total_active_minutes
FROM cte4
GROUP BY user_id;


