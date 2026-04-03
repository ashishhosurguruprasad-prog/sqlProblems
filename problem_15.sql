-- Q: Write a SQL query that reports the device that is first logged in for each player.


if exists (select name from sys.tables where name='worker')
drop table worker

CREATE TABLE Worker (
	player_id INT NOT NULL PRIMARY KEY,
	device_id INT,
	event_date DATE,
	games_played INT
);

INSERT INTO Worker 
	(player_id, device_id, event_date, games_played) VALUES
		(1,  2, '2014-02-20', 5),
		(1,  2, '2014-06-11', 6),
		(2,  3, '2014-02-20', 1),
		(3,  1, '2014-02-20', 0),
		(3, 4, '2014-06-11', 5);

select *from(
select
      *,
      row_number() over(partition by player_id order by event_date) as rn
from worker
)t where rn=1

