-- Задание 5.2.2.TSK.B: создать хранимую процедуру, запускаемую по рас-писанию раз в неделю и оптимизирующую (дефрагментирующую, компак-тифицирующую) все таблицы базы данных, в которых находится не ме-нее одного миллиона записей.
drop procedure if exists OPTIMIZE_ALL_TABLES2;
drop event if exists `optimize_all_tables_weekly`;
DELIMITER $$ 
CREATE PROCEDURE OPTIMIZE_ALL_TABLES2() 
BEGIN 
	DECLARE done INT DEFAULT 0; 
    DECLARE tbl_name VARCHAR(200) DEFAULT ''; 
    DECLARE all_tables_cursor CURSOR FOR SELECT `table_name` FROM `information_schema`.`tables` WHERE `table_schema` = DATABASE() AND `table_type` = 'BASE TABLE'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN all_tables_cursor; 
    tables_loop: LOOP FETCH all_tables_cursor INTO tbl_name; 
		IF done THEN 
			LEAVE tables_loop; 
		END IF;
        set @count_items = (select count(*) as `count` from tbl_name);
        if @count_items >= 1000000 THEN
			SET @table_opt_query = CONCAT('OPTIMIZE TABLE `', tbl_name, '`'); 
			PREPARE table_opt_stmt FROM @table_opt_query; 
			EXECUTE table_opt_stmt; 
			DEALLOCATE PREPARE table_opt_stmt;
        END IF;
	END LOOP tables_loop; 
    CLOSE all_tables_cursor; 
END; 
$$ 
DELIMITER ;
SET GLOBAL event_scheduler = ON; 
CREATE EVENT `optimize_all_tables_weekly` 
ON SCHEDULE 
EVERY 1 week 
STARTS NOW()
ON COMPLETION PRESERVE 
DO 
CALL OPTIMIZE_ALL_TABLES2;
SELECT * FROM `information_schema`.`events`;