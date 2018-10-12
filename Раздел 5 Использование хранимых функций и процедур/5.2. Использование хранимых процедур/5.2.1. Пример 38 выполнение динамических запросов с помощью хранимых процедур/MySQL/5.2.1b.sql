-- Задача 5.2.1.b{382}: создать хранимую процедуру, формирующую список представлений, триггеров и внешних ключей для указанной таблицы.
DROP PROCEDURE if exists SHOW_TABLE_OBJECTS; 
DELIMITER $$ 
CREATE PROCEDURE SHOW_TABLE_OBJECTS (IN table_name VARCHAR(150)) 
BEGIN 
	SET @query_text = ' SELECT \'foreign_key\' AS `object_type`, 
								`constraint_name` AS `object_name` 
						FROM `information_schema`.`table_constraints` 
                        WHERE `table_schema` = DATABASE() AND `table_name` = \'_FP_TABLE_NAME_PLACEHOLDER_\' AND `constraint_type` = \'FOREIGN KEY\' 
                        UNION 
                        SELECT \'trigger\' AS `object_type`, `trigger_name` AS `object_name` 
                        FROM `information_schema`.`triggers` 
                        WHERE `event_object_schema` = DATABASE() AND `event_object_table` = \'_FP_TABLE_NAME_PLACEHOLDER_\' 
                        UNION 
                        SELECT \'view\' AS `object_type`, `table_name` AS `object_name` 
                        FROM `information_schema`.`views` 
                        WHERE `table_schema` = DATABASE() AND `view_definition` LIKE \'%`_FP_TABLE_NAME_PLACEHOLDER_`%\''; 
	SET @query_text = REPLACE(@query_text, '_FP_TABLE_NAME_PLACEHOLDER_', table_name); 
    PREPARE query_stmt FROM @query_text; 
    EXECUTE query_stmt; 
    DEALLOCATE PREPARE query_stmt; 
END; 
$$ 
DELIMITER ;
CALL SHOW_TABLE_OBJECTS('subscriptions')