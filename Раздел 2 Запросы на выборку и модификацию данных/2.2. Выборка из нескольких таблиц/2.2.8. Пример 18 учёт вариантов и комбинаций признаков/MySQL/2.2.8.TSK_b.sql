-- Задание 2.2.8.TSK.B: показать читателей, бравших самые разножанровые книги (т.е. книги, одновременно относящиеся к максимальному количеству жанров).
select max(`genres_count`) from (select `b_id`, count(`g_id`) as `genres_count` from `m2m_books_genres` where `b_id` in (select distinct `sb_book` from subscriptions) group by `b_id`) as `data` into @max_count;
select distinct `s_id`, `s_name` 
from `subscribers` 
inner join subscriptions 
on `s_id` = `sb_subscriber` 
where `sb_book` in (select `b_id` from (select `b_id`, count(`g_id`) as `genres_count` from `m2m_books_genres` where `b_id` in (select distinct `sb_book` from subscriptions) group by `b_id` having `genres_count` = @max_count) as `data`);


