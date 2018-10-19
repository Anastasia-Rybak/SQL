-- Задача 3.1.1.b{213}: создать представление, позволяющее получать список авторов и количество имеющихся в библиотеке книг по каждому автору, но отображающее только таких авторов, по которым имеется более од-ной книги.
CREATE OR REPLACE VIEW `authors_with_more_than_one_book` 
AS 
	SELECT `a_id`, `a_name`, COUNT(`b_id`) AS `books_in_library` 
    FROM `authors` JOIN `m2m_books_authors` USING (`a_id`) 
    GROUP BY `a_id` 
    HAVING `books_in_library` > 1;

select * from `authors_with_more_than_one_book` 