-- Задание 3.2.2.TSK.A: создать представление, извлекающее из таблицы m2m_books_authors человекочитаемую (с названиями книг и именами авторов вместо идентификаторов) информацию, и при этом позволяю-щее модифицировать данные в таблице m2m_books_authors (в случае неуникальности названий книг и имён авторов в обоих случаях использо-вать запись с минимальным значением первичного ключа).
CREATE or replace VIEW `m2m_books_authors_with_text` 
AS 
	SELECT `b_name` AS `b_id`, `a_name` AS `a_id` FROM `books` JOIN `m2m_books_authors` Using(`b_id`) JOIN `authors` Using(`a_id`);