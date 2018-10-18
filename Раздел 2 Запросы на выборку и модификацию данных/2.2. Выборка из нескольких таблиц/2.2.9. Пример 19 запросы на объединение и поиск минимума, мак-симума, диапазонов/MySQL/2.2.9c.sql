-- Задача 2.2.9.c{137}: показать, какую книгу (или книги, если их несколько) каждый читатель взял в первый день своей работы с библиотекой.
SELECT `s_id`, `s_name`, GROUP_CONCAT(`b_name` ORDER BY `b_name` SEPARATOR ', ') AS `books_list` FROM 
(SELECT `s_id`, `s_name`, `b_name` FROM `subscribers` JOIN 
(SELECT `subscriptions`.`s_id`, `subscriptions`.`b_id` FROM `subscriptions` JOIN 
(SELECT `s_id`, MIN(`sb_start`) AS `min_date` FROM `subscriptions` GROUP BY `s_id`) AS `first_visit` 
		ON `subscriptions`.`s_id` = `first_visit`.`s_id` AND `subscriptions`.`sb_start` = `first_visit`.`min_date`)
	AS `books_list` using(s_id) JOIN `books` using(`b_id`)) AS `prepared_data` GROUP BY `s_id`