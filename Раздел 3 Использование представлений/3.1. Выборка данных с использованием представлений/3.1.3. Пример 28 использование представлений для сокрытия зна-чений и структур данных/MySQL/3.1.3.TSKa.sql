-- Задание 3.1.3.TSK.A: создать представление, через которое невозможно получить информацию о том, какая конкретно книга была выдана чита-телю в любой из выдач.
CREATE or replace VIEW `subscriptions_anonymous2` 
AS 
	SELECT `sb_id`, `s_id`, `sb_start`, `sb_finish`, `sb_is_active` FROM `subscriptions`;
select * from `subscriptions_anonymous2`;