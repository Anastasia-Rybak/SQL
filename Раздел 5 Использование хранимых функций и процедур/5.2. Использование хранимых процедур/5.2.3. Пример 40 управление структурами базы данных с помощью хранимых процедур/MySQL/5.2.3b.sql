-- Задача 5.2.3.b{404}: создать хранимую процедуру, автоматически создаю-щую и наполняющую данными агрегирующую таблицу tables_rc, со-держащую информацию о количестве записей во всех таблицах базы данных в формате (имя_таблицы, количество_записей).
drop procedure if exists CACHE_TABLES_RC;
DELIMITER $$ 
CREATE PROCEDURE CACHE_TABLES_RC() 
BEGIN 
	DECLARE done INT DEFAULT 0; 
    DECLARE tbl_name VARCHAR(200) DEFAULT ''; 
    DECLARE all_tables_cursor CURSOR FOR SELECT `table_name` FROM `information_schema`.`tables` WHERE `table_schema` = DATABASE() AND `table_type` = 'BASE TABLE'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
    IF NOT EXISTS (SELECT `table_name` FROM `information_schema`.`tables` WHERE `table_schema` = DATABASE() AND `table_type` = 'BASE TABLE' AND `table_name` = 'tables_rc') THEN 
		CREATE TABLE `tables_rc`
        ( 
			`table_name` VARCHAR(200), 
            `rows_count` INT 
		); 
	END IF; 
    TRUNCATE TABLE `tables_rc`; 
    OPEN all_tables_cursor;
	tables_loop: LOOP FETCH all_tables_cursor INTO tbl_name; 
		IF done THEN 
			LEAVE tables_loop; 
		END IF; 
        SET @table_rc_query = CONCAT('SELECT COUNT(1) INTO @tbl_rc FROM `', tbl_name, '`'); 
        PREPARE table_opt_stmt FROM @table_rc_query; 
        EXECUTE table_opt_stmt; 
        DEALLOCATE PREPARE table_opt_stmt; 
        INSERT INTO `tables_rc` (`table_name`, `rows_count`) VALUES (tbl_name, @tbl_rc); 
    END LOOP tables_loop; 
    CLOSE all_tables_cursor; 
END; 
$$ 
DELIMITER ;
CALL CACHE_TABLES_RC; 
SELECT * FROM `tables_rc`;