-- Задача 3.1.3.b{243}: создать представление, возвращающее всю информа-цию из таблицы subscriptions, преобразуя даты из полей sb_start и sb_finish в формат UNIXTIME.
CREATE or replace VIEW `subscriptions_unixtime` 
AS 
	SELECT `sb_id`, `s_id`, `b_id`, UNIX_TIMESTAMP(`sb_start`) AS `sb_start`, UNIX_TIMESTAMP(`sb_finish`) AS `sb_finish`, `sb_is_active` FROM `subscriptions`;
select * from `subscriptions_unixtime`;