-- Задача 5.2.3.a{400}: создать хранимую процедуру, автоматически создаю-щую и наполняющую данными агрегирующую таблицу books_statis-tics (см. задачу 3.1.2.a{215}).
drop procedure if exists CREATE_BOOKS_STATISTICS;
DELIMITER $$ 
CREATE PROCEDURE CREATE_BOOKS_STATISTICS() 
BEGIN 
	IF NOT EXISTS (SELECT `table_name` FROM `information_schema`.`tables` WHERE `table_schema` = DATABASE() AND `table_type` = 'BASE TABLE' AND `table_name` = 'books_statistics') THEN 
		CREATE TABLE `books_statistics` 
        (
			`total` INTEGER UNSIGNED NOT NULL, 
            `given` INTEGER UNSIGNED NOT NULL, 
            `rest` INTEGER UNSIGNED NOT NULL ); 
		INSERT INTO `books_statistics` (`total`, `given`, `rest`) 
        SELECT IFNULL(`total`, 0), IFNULL(`given`, 0), IFNULL(`total` - `given`, 0) AS `rest` 
        FROM (SELECT (SELECT SUM(`b_quantity`) FROM `books`) AS `total`, (SELECT COUNT(`sb_book`) FROM `subscriptions` WHERE `sb_is_active` = 'Y') AS `given`) AS `prepared_data`; 
	ELSE 
		UPDATE `books_statistics` 
        JOIN (SELECT IFNULL(`total`, 0) AS `total`, IFNULL(`given`, 0) AS `given`, IFNULL(`total` - `given`, 0) AS `rest` 
				FROM (SELECT (SELECT SUM(`b_quantity`) FROM `books`) AS `total`, (SELECT COUNT(`sb_book`) FROM `subscriptions` WHERE `sb_is_active` = 'Y') AS `given`) AS `prepared_data`) AS `src` 
		SET `books_statistics`.`total` = `src`.`total`, 
			`books_statistics`.`given` = `src`.`given`, 
            `books_statistics`.`rest` = `src`.`rest`; 
	END IF; 
END;
$$ 
DELIMITER ;
DROP TABLE if exists `books_statistics`; 
CALL CREATE_BOOKS_STATISTICS; 
SELECT * FROM `books_statistics`;