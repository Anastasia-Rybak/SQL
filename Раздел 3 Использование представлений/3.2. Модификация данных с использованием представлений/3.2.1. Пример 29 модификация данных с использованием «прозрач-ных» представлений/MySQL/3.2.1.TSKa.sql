-- Задание 3.2.1.TSK.A: создать представление, извлекающее информацию о книгах, переводя весь текст в верхний регистр и при этом допускающее модификацию списка книг.
CREATE OR Replace VIEW `books_upper_case` 
AS 
	SELECT `b_id`, UPPER(`b_name`) AS `b_name`, `b_year`,`b_quantity` FROM `books`;
CREATE OR Replace VIEW `books_upper_case_trick`
AS
	SELECT `b_id`, `b_name`, UPPER(`b_name`) AS `b_name_upper`, `b_year`,`b_quantity` FROM `books`;