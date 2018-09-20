-- Задача 3.2.2.a{258}: создать представление, извлекающее из таблицы sub-scriptions человекочитаемую (с именами читателей и названиями книг вместо идентификаторов) информацию, и при этом позволяющее моди-фицировать данные в таблице subscriptions.
CREATE or replace VIEW `subscriptions_with_text` 
AS 
	SELECT `sb_id`, `s_name` AS `sb_subscriber`, `b_name` AS `sb_book`, `sb_start`, `sb_finish`, `sb_is_active` FROM `subscriptions` JOIN `subscribers` Using(`s_id`) JOIN `books` Using(`b_id`);