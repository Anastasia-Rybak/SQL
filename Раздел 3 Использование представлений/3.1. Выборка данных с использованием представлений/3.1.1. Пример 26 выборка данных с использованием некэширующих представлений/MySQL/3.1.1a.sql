-- Задача 3.1.1.a{210}: упростить использование решения задачи 2.2.9.d{132} так, чтобы для получения нужных данных не приходилось использовать представленные в решении{140} объёмные запросы.
-- Замена первого подзапроса представлением: 
CREATE OR REPLACE VIEW `first_book_step_1` 
AS 
	SELECT subscriptions.s_id, MIN(`sb_start`) AS `min_sb_start` 
	FROM `subscriptions` GROUP BY subscriptions.s_id;
    
-- Замена второго подзапроса представлением: 
CREATE OR REPLACE VIEW `first_book_step_2` 
AS 
	SELECT `subscriptions`.`s_id`, MIN(`sb_id`) AS `min_sb_id` 
    FROM `subscriptions` JOIN `first_book_step_1` ON `subscriptions`.`s_id` = `first_book_step_1`.`s_id` AND `subscriptions`.`sb_start` = `first_book_step_1`.`min_sb_start` 
    GROUP BY `subscriptions`.`s_id`, `min_sb_start`;

-- Замена третьего подзапроса представлением: 
CREATE OR REPLACE VIEW `first_book_step_3` 
AS 
	SELECT `subscriptions`.`s_id`, `b_id` FROM `subscriptions` JOIN `first_book_step_2` ON `subscriptions`.`sb_id` = `first_book_step_2`.`min_sb_id`; 
    
-- Создание основного представления: 
CREATE OR REPLACE VIEW `first_book` 
AS 
	SELECT `subscribers`.`s_id`, `s_name`, `b_name` 
    FROM `subscribers` JOIN `first_book_step_3` 
    ON `subscribers`.`s_id` = `first_book_step_3`.`s_id` JOIN `books` ON `first_book_step_3`.`b_id` = `books`.`b_id`;

SELECT * FROM first_book;