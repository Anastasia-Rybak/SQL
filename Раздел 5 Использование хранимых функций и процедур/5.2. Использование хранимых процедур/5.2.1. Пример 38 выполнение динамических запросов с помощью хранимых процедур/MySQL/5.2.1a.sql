-- Задача 5.2.1.a{375}: создать хранимую процедуру, устраняющую проме-жутки в последовательности значений первичного ключа для заданной таблицы (например, если значения первичного ключа были равны 4, 7, 9, то после выполнения хранимой процедуры они станут равны 1, 2, 3).
DROP PROCEDURE if exists COMPACT_KEYS; 
DELIMITER $$ 
CREATE PROCEDURE COMPACT_KEYS 
(IN table_name VARCHAR(150), IN pk_name VARCHAR(150), OUT keys_changed INT) 
BEGIN 
	SET keys_changed = 0; 
    -- SELECT CONCAT('Point 1. table_name = ', table_name, ', pk_name = ', pk_name, ', keys_changed = ', IFNULL(keys_changed, 'NULL')); 
    SET @empty_key_query = CONCAT('SELECT MIN(`empty_key`) AS `empty_key` INTO @empty_key_value 
									FROM (SELECT `left`.`', pk_name, '` + 1 AS `empty_key` 
											FROM `', table_name, '` AS `left` 
                                            LEFT OUTER JOIN `', table_name, '` AS `right` ON `left`.`', pk_name, '` + 1 = `right`.`', pk_name, '` 
                                            WHERE `right`.`', pk_name, '` IS NULL 
                                            UNION SELECT 1 AS `empty_key` 
													FROM `', table_name, '` 
                                                    WHERE NOT EXISTS(SELECT `', pk_name, '` 
																		FROM `', table_name, '` 
                                                                        WHERE `', pk_name, '` = 1)) AS `prepared_data` 
									WHERE `empty_key` < (SELECT MAX(`', pk_name, '`) 
															FROM `', table_name, '`)'); 
	SET @max_key_query = CONCAT('SELECT MAX(`', pk_name, '`) INTO @max_key_value FROM `', table_name, '`'); 
    -- SELECT CONCAT('Point 2. empty_key_query = ', @empty_key_query, 'max_key_query = ', @max_key_query); 
    PREPARE empty_key_stmt FROM @empty_key_query; 
    PREPARE max_key_stmt FROM @max_key_query; 
    while_loop: LOOP EXECUTE empty_key_stmt; 
					-- SELECT CONCAT('Point 3. @empty_key_value = ', @empty_key_value); 
                    IF (@empty_key_value IS NULL) THEN 
							LEAVE while_loop; 
					END IF; 
                    EXECUTE max_key_stmt; 
                    SET @update_key_query = CONCAT('UPDATE `', table_name, '` SET `', pk_name, '` = @empty_key_value WHERE `', pk_name, '` = ', @max_key_value); 
                    -- SELECT CONCAT('Point 4. @update_key_query = ', @update_key_query); 
                    PREPARE update_key_stmt FROM @update_key_query; 
                    EXECUTE update_key_stmt; 
                    DEALLOCATE PREPARE update_key_stmt; 
                    SET keys_changed = keys_changed + 1; 
                    ITERATE while_loop; 
				END LOOP while_loop;
	DEALLOCATE PREPARE max_key_stmt; 
    DEALLOCATE PREPARE empty_key_stmt; 
END; 
$$ DELIMITER ;
CALL COMPACT_KEYS('books', 'b_id', @keys_changed);
select @keys_changed;
