--Write a SQL query to find students whose scores are the same in all subjects they appeared in.

/*
CREATE TABLE student_scores (
    student_id INT,
    subject VARCHAR(50),
    score INT
);


INSERT INTO student_scores (student_id, subject, score) VALUES
(1, 'Math', 85),
(1, 'Science', 92),
(2, 'Math', 90),
(2, 'Science', 88),
(3, 'Math', 78),
(3, 'Science', 78);
*/

-- Solution 1

select 
      student_id,
      count(distinct score) as count
from student_scores
group by student_id
having count(distinct score)>1
;

-- Solution 2

select
      student_id
from student_scores
group by student_id
having max(score)=min(score)


