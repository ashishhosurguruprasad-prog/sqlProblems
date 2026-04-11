/*
Task: Write an SQL query to calculate the average subscription duration and the average amount paid per subscription for eath customer.
Additionally, identify customers who have a longest subscription gap between two consecutive subscriptions.

The result should include:

›customer_id
›average_subscription_duration (in days)
›average_amount_paid (average amount paid per subscription)
›longest_gap_between_subscriptions (the longest gap in days between two consecutive subscriptions for each customer
Requirements:
1. Calculate the average subscription duration as the difference between the start_date and end_date for each subscri
2. Calculate the average amount paid as the average of the amount_paid column for each customer.
3. For each customer, find the longest gap between two consecutive subscriptions by calculating the difference between the start_date of a current subscription and the end_date of the previous subscription.
4.Only include customers who have at least two subscriptions.
5. Return the results ordered by longest_gap_between_subscriptions in descending order.
*/


if exists (select name from sys.tables where name='Subscriptions')
drop table Subscriptions

CREATE TABLE Subscriptions (
    subscription_id INT PRIMARY KEY,
    customer_id INT,
    start_date DATE,
    end_date DATE,
    amount_paid DECIMAL(10, 2)
);


INSERT INTO Subscriptions (subscription_id, customer_id, start_date, end_date, amount_paid) VALUES
(1, 101, '2023-01-01', '2023-03-01', 50.00),
(2, 101, '2023-04-01', '2023-06-01', 55.00),
(3, 101, '2023-08-01', '2023-10-01', 60.00),
(4, 102, '2023-01-15', '2023-04-15', 45.00),
(5, 102, '2023-05-01', '2023-08-01', 50.00),
(6, 102, '2023-09-01', '2023-12-01', 55.00),
(7, 103, '2023-02-01', '2023-04-01', 60.00),
(8, 103, '2023-05-01', '2023-07-01', 65.00),
(9, 103, '2023-08-01', '2023-10-01', 70.00),
(10, 104, '2023-03-01', '2023-05-01', 40.00),
(11, 104, '2023-06-01', '2023-08-01', 45.00),
(12, 104, '2023-09-01', '2023-11-01', 50.00);

-- note : break the max and average in to another cte as it might affect the performance


with cte1 as (
SELECT 
      customer_id,
      round(avg(date_diff(end_date,start_date)) over(partition by customer_id),0) as avg_duration,
      round(avg(amount_paid) over(partition by customer_id),0) as avg_amount,
      max(date_diff(lead(start_date,1,end_date) over(partition by customer_id order by start_date), end_date)) over(partition by customer_id) as max_diff_per_sub
from subscriptions
)

select
      *
from cte1
group by customer_id,avg_duration,avg_amount,max_diff_per_sub