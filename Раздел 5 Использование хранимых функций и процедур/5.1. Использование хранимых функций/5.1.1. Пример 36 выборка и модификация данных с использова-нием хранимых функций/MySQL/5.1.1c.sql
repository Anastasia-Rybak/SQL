-- Задача 5.1.1.c{367}: создать хранимую функцию, актуализирующую данные в таблице books_statistics (см. задачу 3.1.2.a{215}) и возвращающую число, показывающее изменение количества фактически имеющихся в библиотеке книг.
drop table if exists `books_statistics`; 
CREATE TABLE `books_statistics` 
( 
	`total` INTEGER UNSIGNED NOT NULL, 
    `given` INTEGER UNSIGNED NOT NULL, 
    `rest` INTEGER UNSIGNED NOT NULL 
);
INSERT INTO `books_statistics` (`total`, `given`, `rest`) 
SELECT IFNULL(`total`, 0), IFNULL(`given`, 0), IFNULL(`total` - `given`, 0) AS `rest` 
FROM (SELECT (SELECT SUM(`b_quantity`) FROM `books`) AS `total`, (SELECT COUNT(`sb_book`) FROM `subscriptions` WHERE `sb_is_active` = 'Y') AS `given`) AS `prepared_data`;
DROP FUNCTION IF EXISTS BOOKS_DELTA;
DELIMITER $$ 
CREATE FUNCTION BOOKS_DELTA() 
RETURNS INTEGER UNSIGNED deterministic
BEGIN 
	DECLARE old_books_count INTEGER UNSIGNED DEFAULT 0; 
    DECLARE new_books_count INTEGER UNSIGNED DEFAULT 0; 
    SELECT `total` FROM `books_statistics` into old_books_count ; 
    UPDATE `books_statistics` 
    JOIN (SELECT IFNULL(`total`, 0) AS `total`, IFNULL(`given`, 0) AS `given`, IFNULL(`total` - `given`, 0) AS `rest` 
		FROM (SELECT (SELECT SUM(`b_quantity`) FROM `books`) AS `total`, (SELECT COUNT(`sb_book`) FROM `subscriptions` WHERE `sb_is_active` = 'Y') AS `given`) AS `prepared_data`) AS `src` 
 	SET `books_statistics`.`total` = `src`.`total`, 
 		`books_statistics`.`given` = `src`.`given`, 
 		`books_statistics`.`rest` = `src`.`rest`; 
    SELECT `total` FROM `books_statistics` into new_books_count; 
    RETURN (new_books_count - old_books_count); 
END; 
$$ 
DELIMITER ;
insert into `books` (`b_name`, `b_year`, `b_quantity`) values ('Книга',2000,2);
SELECT BOOKS_DELTA();