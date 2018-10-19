-- Задание 6.2.3.TSK.C: создать хранимую процедуру, выполняющую под-счёт количества записей в указанной таблице таким образом, чтобы она возвращала максимально корректные данные, даже если для достиже-ния этого результата придётся пожертвовать производительностью.
drop procedure if exists COUNT_ROWS;
DELIMITER $$ 
CREATE PROCEDURE COUNT_ROWS
(
	IN table_name VARCHAR(150), 
    OUT rows_in_table INT
) 
BEGIN 
	set SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; 
    SET @count_query = CONCAT('SELECT COUNT(1) INTO @rows_found FROM ', table_name); 
    PREPARE count_stmt FROM @count_query; 
    EXECUTE count_stmt; 
    DEALLOCATE PREPARE count_stmt; 
    SET rows_in_table := @rows_found; 
END; 
$$ DELIMITER ;
CALL COUNT_ROWS('subscriptions', @rows_in_table); 
SELECT @rows_in_table;