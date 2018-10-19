-- Задача 3.2.2.b{270}: создать представление, показывающее список книг с относящимися к этим книгам жанрами, и при этом позволяющее добав-лять новые жанры.
CREATE or replace VIEW `books_with_genres` 
AS 
	SELECT `b_id`, `b_name`, GROUP_CONCAT(`g_name`) AS `genres` FROM `books` JOIN `m2m_books_genres` USING(`b_id`) JOIN `genres` USING(`g_id`) GROUP BY `b_id`;