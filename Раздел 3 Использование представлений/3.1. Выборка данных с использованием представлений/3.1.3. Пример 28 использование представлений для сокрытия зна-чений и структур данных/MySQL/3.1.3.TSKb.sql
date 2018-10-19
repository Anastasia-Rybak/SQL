-- Задание 3.1.3.TSK.B: создать представление, возвращающее всю ин-формацию из таблицы subscriptions, преобразуя даты из полей sb_start и sb_finish в формат «ГГГГ-ММ-ДД НН», где «НН» — день недели в виде своего полного названия (т.е. «Понедельник», «Вторник» и т.д.)
CREATE or replace VIEW `subscriptions_convert` 
AS 
	
	SELECT `sb_id`, `s_id`, `b_id`, date_format(`sb_start`, '%Y-%m-%d %W') AS `sb_start`, date_format(`sb_finish`, '%Y-%m-%d %W') AS `sb_finish`, `sb_is_active` FROM `subscriptions`;

select @@lc_time_names into @d;
SET @@lc_time_names='ru_RU';
select * from `subscriptions_convert`;
SET @@lc_time_names = @d ;