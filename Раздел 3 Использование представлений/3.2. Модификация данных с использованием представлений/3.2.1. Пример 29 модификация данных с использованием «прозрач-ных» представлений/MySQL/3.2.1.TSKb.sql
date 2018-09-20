-- Задание 3.2.1.TSK.B: создать представление, извлекающее информацию о датах выдачи и возврата книг и состоянии выдачи книги в виде единой строки в формате «ГГГГ-ММ-ДД - ГГГГ-ММ-ДД - Возвращена» и при этом допускающее обновление информации в таблице subscriptions.
CREATE or replace view `subscriptions_wcd2`
AS 
	SELECT `sb_id`, `b_id`, CONCAT(`sb_start`, ' - ', `sb_finish`, ' - ', if(`sb_is_active` = 'Y', 'Возвращено', if(`sb_is_active` = 'N', 'Не возвращено', 'Неизвестно'))) AS `sb_dates` FROM `subscriptions`;
CREATE or replace VIEW `subscriptions_wcd_trick2` 
AS
	SELECT `sb_id`, `b_id`, CONCAT(`sb_start`, ' - ', `sb_finish`, ' - ', if(`sb_is_active` = 'Y', 'Возвращено', if(`sb_is_active` = 'N', 'Не возвращено', 'Неизвестно'))) AS `sb_dates`, `sb_start`, `sb_finish`, `sb_is_active` FROM `subscriptions`;    