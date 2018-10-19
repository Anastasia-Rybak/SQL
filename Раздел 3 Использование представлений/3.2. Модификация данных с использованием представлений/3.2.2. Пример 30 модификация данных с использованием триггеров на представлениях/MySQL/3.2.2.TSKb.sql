-- Задание 3.2.2.TSK.B: создать представление, показывающее список книг с их авторами, и при этом позволяющее добавлять новых авторов.
CREATE or replace VIEW `books_with_authors` 
AS 
	SELECT `b_id`, `b_name`, GROUP_CONCAT(`a_name`) AS `authors` FROM `books` JOIN `m2m_books_authors` USING(`b_id`) JOIN `authors` USING(`a_id`) GROUP BY `b_id`;