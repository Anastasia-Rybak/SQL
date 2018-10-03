-- Задание 5.1.2.TSK.C: создать хранимую функцию, автоматизирующую проверку условий задачи 4.2.2.b{338}, т.е. возвращающую 1, если книга из-дана менее ста лет назад, и 0 в противном случае.
DROP FUNCTION IF EXISTS CHECK_books_year; 
DELIMITER $$ 
CREATE FUNCTION CHECK_books_year
(year_book int) 
RETURNS INT reads sql data 
BEGIN
 	IF ((YEAR(CURDATE()) - year_book) < 100) THEN 
		return 1;
	else
		return 0;
	END IF; 
END; 
$$ 
DELIMITER ;
select CHECK_books_year(2000), CHECK_books_year(1900);