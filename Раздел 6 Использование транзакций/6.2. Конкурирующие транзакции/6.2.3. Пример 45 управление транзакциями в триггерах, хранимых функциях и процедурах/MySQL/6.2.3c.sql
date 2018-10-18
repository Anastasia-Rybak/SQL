-- Задача 6.2.3.c{471}: создать хранимую процедуру, выполняющую подсчёт количества записей в указанной таблице таким образом, чтобы запрос выполнялся максимально быстро (вне зависимости от параллельно вы-полняемых запросов), даже если в итоге он вернёт не совсем корректные данные.
drop procedure if exists COUNT_ROWS;
DELIMITER $$ 
CREATE PROCEDURE COUNT_ROWS
(
	IN table_name VARCHAR(150), 
    OUT rows_in_table INT
) 
BEGIN 
	set SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 
    SET @count_query = CONCAT('SELECT COUNT(1) INTO @rows_found FROM ', table_name); 
    PREPARE count_stmt FROM @count_query; 
    EXECUTE count_stmt; 
    DEALLOCATE PREPARE count_stmt; 
    SET rows_in_table := @rows_found; 
END; 
$$ DELIMITER ;
CALL COUNT_ROWS('subscriptions', @rows_in_table); 
SELECT @rows_in_table;