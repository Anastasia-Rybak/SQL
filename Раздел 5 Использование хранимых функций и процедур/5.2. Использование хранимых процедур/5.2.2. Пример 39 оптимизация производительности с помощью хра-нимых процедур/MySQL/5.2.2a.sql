-- Задача 5.2.2.a{388}: создать хранимую процедуру, запускаемую по распи-санию каждый час и обновляющую данные в агрегирующей таблице books_statistics (см. задачу 3.1.2.a{215}).
drop procedure if exists UPDATE_BOOKS_STATISTICS;
drop event if exists `update_books_statistics_hourly`;
DELIMITER $$ 
CREATE PROCEDURE UPDATE_BOOKS_STATISTICS() 
BEGIN 
	IF (NOT EXISTS(SELECT * FROM `information_schema`.`tables` WHERE `table_schema` = DATABASE() AND `table_name` = 'books_statistics')) THEN 
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'The `books_statistics` table is missing.', MYSQL_ERRNO = 1001; 
	END IF;
	UPDATE `books_statistics` 
		JOIN (SELECT IFNULL(`total`, 0) AS `total`, IFNULL(`given`, 0) AS `given`, IFNULL(`total` - `given`, 0) AS `rest` 
				FROM (SELECT (SELECT SUM(`b_quantity`) FROM `books`) AS `total`, (SELECT COUNT(`sb_book`) FROM `subscriptions` WHERE `sb_is_active` = 'Y') AS `given`) AS `prepared_data` ) AS `src` 
	SET `books_statistics`.`total` = `src`.`total`, 
		`books_statistics`.`given` = `src`.`given`, 
		`books_statistics`.`rest` = `src`.`rest`; 
END; 
$$ 
DELIMITER ;
SET GLOBAL event_scheduler = ON; 
CREATE EVENT `update_books_statistics_hourly` 
ON SCHEDULE 
EVERY 1 HOUR 
STARTS NOW()
ON COMPLETION PRESERVE 
DO 
CALL UPDATE_BOOKS_STATISTICS;
SELECT * FROM `information_schema`.`events`;