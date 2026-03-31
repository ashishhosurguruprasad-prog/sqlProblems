-- Write an SQL query to find all flights where at least two passengers have confirmed reservations in adjacent seats.
-- Adjacent seats are defined as having consecutive seat numbers (e.g., 12A and 12B).
-- Display the FlightID and the names of the passengers with adjacent confirmed seats.



/*
CREATE TABLE SeatReservations (
    ReservationID INT PRIMARY KEY,
    PassengerName VARCHAR(50),
    SeatNumber VARCHAR(5),
    BookingDate DATE,
    FlightID VARCHAR(10),
    Status VARCHAR(20)
);

INSERT INTO SeatReservations (ReservationID, PassengerName, SeatNumber, BookingDate, FlightID, Status)
VALUES 
(1, 'John Smith', '12A', '2024-01-01', 'F101', 'Confirmed'),
(2, 'Jane Doe', '12B', '2024-01-01', 'F101', 'Cancelled'),
(3, 'Alice Brown', '14A', '2024-01-02', 'F102', 'Confirmed'),
(4, 'Bob Johnson', '14B', '2024-01-02', 'F102', 'Confirmed'),
(5, 'Mary Taylor', '15A', '2024-01-03', 'F103', 'Confirmed'),
(6, 'John Smith', '12C', '2024-01-03', 'F101', 'Confirmed'),
(7, 'Tom Hardy', '10A', '2024-01-04', 'F104', 'Confirmed'),
(8, 'Emma Davis', '10B', '2024-01-04', 'F104', 'Confirmed'),
(9, 'Chris Evans', '10C', '2024-01-04', 'F104', 'Confirmed'),
(10, 'Sophia Lee', '14C', '2024-01-02', 'F102', 'Confirmed'),
(11, 'Emily Clark', '16A', '2024-01-05', 'F105', 'Cancelled'),
(12, 'Henry Adams', '14A', '2024-01-05', 'F102', 'Confirmed'),
(13, 'Olivia Green', '14B', '2024-01-05', 'F102', 'Confirmed'),
(14, 'David Brown', '13A', '2024-01-06', 'F106', 'Confirmed'),
(15, 'Linda Wilson', '13B', '2024-01-06', 'F106', 'Confirmed');


*/

;with cte1 as(
select 
* ,
ROW_NUMBER() over(partition by BookingDate,flightid order by SeatNumber) as flag
from seatreservations
),
cte2 as (
select
t1.passengername,
t2.passengername as name2, 
t1.flag as flag,
t2.flag as flag2,
t1.bookingdate as b1,
t2.bookingdate as b2,
t1.flightid as f1,
t2.flightid as f2,
t1.seatnumber as s1,
t2.seatnumber as s2
from cte1 as t1 JOIN cte1 as t2
on t1.bookingdate=t2.bookingdate 
and t1.flightID=t2.flightid 
and t1.flag!= t2.flag
)

select 
passengername,
name2 as passengername, 
b1 as bookingdate ,
f1 as flightid,
s1 as seatnumber,
s2 as copassenger
from cte2
where flag2-flag=1











-- insert into seatreservations (ReservationID,PassengerName,SeatNumber,BookingDate,FlightId,Status)
-- VALUES(26, 'Ashish', '16C', '2024-01-01', 'F101', 'Confirmed')

