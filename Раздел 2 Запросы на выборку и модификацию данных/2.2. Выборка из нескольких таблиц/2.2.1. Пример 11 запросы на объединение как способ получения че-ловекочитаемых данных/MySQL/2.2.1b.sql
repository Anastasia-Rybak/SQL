-- Задача 2.2.1.b{69}: показать всю человекочитаемую информацию обо всех обращениях в библиотеку (т.е. имя читателя, название взятой книги).
SELECT `b_name`, `subscribers`.`s_id`, `s_name`, `sb_start`, `sb_finish` FROM `books` 
		JOIN `subscriptions` 
        ON `books`.`b_id` = `subscriptions`.`b_id` 
        JOIN `subscribers` 
        ON `subscribers`.`s_id` = `subscriptions`.`s_id`