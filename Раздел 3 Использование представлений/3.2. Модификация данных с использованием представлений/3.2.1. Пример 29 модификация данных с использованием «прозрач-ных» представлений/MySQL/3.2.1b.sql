-- Задача 3.2.1.b{251}: создать представление, извлекающее информацию о датах выдачи и возврата книг в виде единой строки и при этом допускаю-щее обновление информации в таблице subscriptions.
CREATE or replace view `subscriptions_wcd`
AS 
	SELECT `sb_id`, `s_id`, `b_id`, CONCAT(`sb_start`, ' - ', `sb_finish`) AS `sb_dates`, `sb_is_active` FROM `subscriptions`;
CREATE or replace VIEW `subscriptions_wcd_trick` 
AS
	SELECT `sb_id`, `s_id`, `b_id`, CONCAT(`sb_start`, ' - ', `sb_finish`) AS `sb_dates`, `sb_start`, `sb_finish`, `sb_is_active` FROM `subscriptions`;    