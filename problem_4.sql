-- identify and deal with reverse pairs in data


/*

create table src_dest(
source varchar(50),
destination varchar(50),
distance int
)

insert into src_dest(source,destination,distance)
values('Alaska','Albany',5166),
('Dover','Florida',1393),
('Illinois','Indiana',279),
('New Mexico','New York',2873),
('Albany','Alaska',5166),
('Ohio','Oklahoma',1383),
('Indiana','Illinois',279),
('Oklahoma','Ohio',1383),
('Frankfort','Georgia',695),
('Georgia','Frankfort',695)
*/
select
*
from src_dest

except

select 
t1.source,
t1.destination,
t1.distance
FRom src_dest as t1
join src_dest as t2 on t1.source= t2.destination and t1.destination=t2.source and t1.source>t2.source
