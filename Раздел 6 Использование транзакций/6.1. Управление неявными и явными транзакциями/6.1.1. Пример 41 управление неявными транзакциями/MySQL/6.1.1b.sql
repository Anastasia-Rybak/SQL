-- Задача 6.1.1.b{413}: создать хранимую процедуру, выполняющую следую-щие действия:
-- • определяющую, включён ли режим автоподтверждения неявных транзакций;
-- • выключающую этот режим, если требуется (если в процедуру пере-дан соответствующий параметр с соответствующим значением); • выполняющую вставку N записей в таблицу subscribers (N переда-ётся в процедуру соответствующим параметром);
-- • восстанавливающую исходное значение режима автоподтверждения неявных транзакций (если оно было изменено);
-- • возвращающую время, затраченное на выполнение вставки.
drop procedure if exists TEST_INSERT_SPEED;
DELIMITER $$ 
CREATE PROCEDURE TEST_INSERT_SPEED
(
	IN records_count INT, 
    IN use_autocommit INT, 
    OUT total_time TIME(6)
) 
BEGIN 
	DECLARE counter INT DEFAULT 0; 
    SET @old_autocommit = (SELECT @@autocommit); 
    SELECT CONCAT('Old autocommit value = ', @old_autocommit); 
    SELECT CONCAT('New autocommit value = ', use_autocommit); 
    IF (use_autocommit != @old_autocommit) THEN 
		SELECT CONCAT('Switching autocommit to ', use_autocommit); 
        SET autocommit = use_autocommit; 
	ELSE 
		SELECT 'No changes in autocommit mode needed.'; 
	END IF; 
    SELECT CONCAT('Starting insert of ', records_count, ' records...'); 
    SET @start_time = (SELECT NOW(6)); 
    WHILE counter < records_count 
	DO 
		INSERT INTO `subscribers` (`s_name`) VALUES (CONCAT('New subscriber ', (counter + 1))); 
		SET counter = counter + 1; 
	END WHILE; 
    SET @finish_time = (SELECT NOW(6)); SELECT CONCAT('Finished insert of ', records_count, ' records...'); 
    IF ((SELECT @@autocommit) = 0) THEN 
		SELECT 'Current autocommit mode is 0. Performing explicit commit.'; 
        COMMIT; 
	END IF; 
    IF (use_autocommit != @old_autocommit) THEN 
		SELECT CONCAT('Switching autocommit back to ', @old_autocommit); 
        SET autocommit = @old_autocommit; 
	ELSE 
		SELECT 'No changes in autocommit mode were made. No restore needed.'; 
	END IF; 
    SET total_time = (SELECT TIMEDIFF(@finish_time, @start_time)); 
    SELECT CONCAT('Time used: ', total_time); 
    SELECT total_time; 
END; 
$$ DELIMITER ;
CALL TEST_INSERT_SPEED(100, 1, @tmp); 
SELECT @tmp; 
CALL TEST_INSERT_SPEED(100, 0, @tmp); 
SELECT @tmp;