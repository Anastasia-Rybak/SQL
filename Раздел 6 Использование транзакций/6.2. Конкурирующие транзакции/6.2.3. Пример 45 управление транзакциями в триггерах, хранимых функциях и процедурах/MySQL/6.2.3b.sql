-- Задача 6.2.3.b{469}: создать хранимую функцию, порождающую исключи-тельную ситуацию в случае запуска в режиме автоподтверждения тран-закций.
drop FUNCTION if exists NO_AUTOCOMMIT() 
DELIMITER $$ 
CREATE FUNCTION NO_AUTOCOMMIT() 
RETURNS INT DETERMINISTIC 
BEGIN 
	IF ((SELECT @@autocommit) = 1) THEN 
		SIGNAL SQLSTATE '45001' 
        SET MESSAGE_TEXT = 'Please, turn the autocommit off.', 
        MYSQL_ERRNO = 1001; 
		RETURN -1; 
    END IF; 
    -- Тут может быть какой-то полезный код :). 
    RETURN 0; 
END
$$ 
DELIMITER ;
SET autocommit = 1; 
SELECT NO_AUTOCOMMIT(); 
SET autocommit = 0; 
SELECT NO_AUTOCOMMIT();