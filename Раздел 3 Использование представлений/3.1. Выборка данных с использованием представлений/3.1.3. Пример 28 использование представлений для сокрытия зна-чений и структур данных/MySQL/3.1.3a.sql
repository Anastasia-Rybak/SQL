-- Задача 3.1.3.a{242}: создать представление, через которое невозможно по-лучить информацию о том, какой конкретно читатель взял ту или иную книгу.
CREATE or replace VIEW `subscriptions_anonymous` 
AS 
	SELECT `sb_id`, `b_id`, `sb_start`, `sb_finish`, `sb_is_active` FROM `subscriptions`;
select * from `subscriptions_anonymous`;