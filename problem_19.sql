/*
The relationship between the LIFT and LIFT_PASSENGERS Table is such that multiple passengers can attempt to enter the same lift,

but the total weight of the passengers in a lift cannot exceed the lift's capacity.

Write an SQL query that produces a comma separated list of passengers who can be accommodated in each lift without exceeding the lift's capacity.

The passengers in the list should be ordered by their weight in increasing order
*/


if exists (select name from sys.tables where name='lift_passengers')
drop table lift_passengers

;Create Table lift_passengers(
Passenger_Name Varchar(20),
Weight_Kg int,
Lift_Id int);

Insert into Lift_Passengers Values('Lewis',85,1);
Insert into Lift_Passengers Values('Anto',73,1);
Insert into Lift_Passengers Values('Danny',95,1);
Insert into Lift_Passengers Values('Mary',80,1);
Insert into Lift_Passengers Values('Raj',92,1);
Insert into Lift_Passengers Values('Mark',83,2);
Insert into Lift_Passengers Values('Robert',77,2);
Insert into Lift_Passengers Values('Maria',73,2);
Insert into Lift_Passengers Values('Susan',85,2);
Insert into Lift_Passengers Values('John',92,2);

Create Table Lift( Id int,
Capacity_Kg Bigint);

Insert into Lift Values(1,300);
Insert into Lift Values(2,350);



with cte1 as (
select 
* 
from lift_passengers p
left join lift as l on p.Lift_Id=l.Id
),

cte2 as(select 
      Passenger_Name,
      Weight_Kg,lift_id,
      capacity_kg,
      sum(Weight_Kg) over(partition by lift_id order by Weight_Kg asc) as total_weight_in_lift
from cte1
)

select 
      lift_id,
      string_agg(passenger_name,',') within group(order by weight_kg) as passenger_name
from cte2 
where total_weight_in_lift<=capacity_kg
group by lift_id
