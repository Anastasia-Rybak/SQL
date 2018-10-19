-- Задание 5.2.3.TSK.C: создать хранимую процедуру, удаляющую все представления, для которых SELECT COUNT(1) FROM представление возвращает значение меньше десяти.
drop procedure if exists drop_views;
DELIMITER $$ 
CREATE PROCEDURE drop_views() 
BEGIN 
	DECLARE done INT DEFAULT 0; 
    DECLARE tbl_name VARCHAR(200) DEFAULT ''; 
    DECLARE all_tables_cursor CURSOR FOR SELECT `table_name` FROM `information_schema`.`views` WHERE `table_schema` = DATABASE(); 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
    OPEN all_tables_cursor;
	tables_loop: LOOP FETCH all_tables_cursor INTO tbl_name; 
		IF done THEN 
			LEAVE tables_loop; 
		END IF; 
        SET @table_rc_query = CONCAT('SELECT COUNT(1) INTO @tbl_rc FROM `', tbl_name, '`'); 
        PREPARE table_opt_stmt FROM @table_rc_query; 
        EXECUTE table_opt_stmt; 
        DEALLOCATE PREPARE table_opt_stmt; 
		if @tbl_rc < 10 then
			SET @table_rc_query = CONCAT('drop view `', tbl_name, '`'); 
			PREPARE table_opt_stmt FROM @table_rc_query; 
            EXECUTE table_opt_stmt; 
			DEALLOCATE PREPARE table_opt_stmt; 
        end if;
    END LOOP tables_loop; 
    CLOSE all_tables_cursor; 
END; 
$$ 
DELIMITER ;
CALL drop_views; 