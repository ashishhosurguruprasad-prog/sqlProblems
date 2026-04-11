-- Write a query to "forward-fill" the missing data. For every hour, if the stock_count is NULL, you must show 
-- the most recent non-null value that came before it for that specific warehouse.

CREATE TABLE inventory_logs (
    warehouse_id VARCHAR(10),
    check_time TIMESTAMP,
    stock_count INT
);

INSERT INTO inventory_logs (warehouse_id, check_time, stock_count) VALUES
('W1', '2026-04-09 08:00', 500),
('W1', '2026-04-09 09:00', NULL),
('W1', '2026-04-09 10:00', NULL),
('W1', '2026-04-09 11:00', 480),
('W1', '2026-04-09 12:00', NULL);

with cte1 as (
select
      warehouse_id,
      check_time,
      stock_count,
      count(stock_count) over(partition by warehouse_id order by check_time) as group_id
from inventory_logs
)

select
      *,
      max(stock_count) over(partition by group_id) as filled_count
from cte1