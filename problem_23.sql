/*
Q1: Find the number of times each word appears in drafts.
Output the word along with the corresponding number of occurrences.

Q2: Find total number of words in each file name
*/

if exists (select name from sys.tables where name='google_file_store')
drop table google_file_store

;create table google_file_store(
filename varchar(20),
contents varchar(1000)
);

insert into google_file_store(filename, contents)
values('draft1.txt','The stock exchange predicts a a bull market which would make many investors happy.'),
('draft2.txt', 'The stock exchange predicts a bull market which would make many investors happy, but analysts warn of possibility of too much optimism and that in fact we are awaiting a bear market.'),
('final.txt', 'The stock exchange predicts a bull market which would make many investors happy, but analysts warn of possibility of too much optimism and that in fact we are awaiting a bear market. As always predicting the future market is an uncertain game and all investors should follow their instincts and best practices.')
;


-- Q1:------------------------------------------------------------------------


with cte1 as (
select 
      filename,
      explode(split(contents, ' ')) AS word
from google_file_store
where filename like 'draft%'
)

select word, count(*) as no_of_occurence
from cte1
group by word

-- Q2:------------------------------------------------------------------------

SELECT filename, count(word) from (
select 
      filename,
      explode(split(contents, ' ')) AS word
from google_file_store
) group by filename