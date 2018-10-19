select `s_name`, `b_name` from `subscribers` inner join 
(select `sb_subscriber`, `sb_book`, max(`sb_start`) from `subscriptions` group by `sb_subscriber`) as `data` on `s_id` = `sb_subscriber` 
inner join `books` on `sb_book` = `b_id`;