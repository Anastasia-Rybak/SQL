-- Задача 3.2.1.a{246}: создать представление, извлекающее информацию о читателях, переводя весь текст в верхний регистр и при этом допускаю-щее модификацию списка читателей.
CREATE OR Replace VIEW `subscribers_upper_case` 
AS 
	SELECT `s_id`, UPPER(`s_name`) AS `s_name` FROM `subscribers`;
CREATE OR Replace VIEW `subscribers_upper_case_trick`
AS
	SELECT `s_id`, `s_name`, UPPER(`s_name`) AS `s_name_upper` FROM `subscribers`;
UPDATE `subscribers_upper_case_trick` SET `s_name` = 'Сидоров А.А.' WHERE `s_id` = 4; 
UPDATE `subscribers_upper_case_trick` SET `s_id` = 10 WHERE `s_id` = 4; 
DELETE FROM `subscribers_upper_case` WHERE `s_id` = 10;