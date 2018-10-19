-- Задача 7.1.2.b{493}: написать хранимую процедуру, проверяющую суще-ствование маршрута (с возможными пересадками) между двумя указан-ными городами, и вычисляющую стоимость отправки книги по такому маршруту (при его наличии).
DROP PROCEDURE IF EXISTS FIND_PATH;
DELIMITER $$ 
CREATE PROCEDURE FIND_PATH(IN start_node INT, IN finish_node INT) 
BEGIN 
	DECLARE rows_inserted INT DEFAULT 0; 
	-- Пересоздание временной таблицы для хранения маршрутов -- (именно DROP/CREATE на случай, если такая таблица была): 
	DROP TABLE IF EXISTS `connections_temp`; 
    CREATE TABLE IF NOT EXISTS `connections_temp` ( `cn_from` INT, `cn_to` INT, `cn_cost` DOUBLE, `cn_bidir` CHAR(1), `cn_steps` SMALLINT, `cn_route` VARCHAR(1000) ) ENGINE = MEMORY;
    -- Первичное наполнение временной таблицы -- существующими маршрутами: 
    INSERT INTO `connections_temp` 
    SELECT `cn_from`, `cn_to`, `cn_cost`, `cn_bidir`, 1, CONCAT(`cn_from`, ',', `cn_to`) 
    FROM (SELECT `cn_from`, `cn_to`, `cn_cost`, `cn_bidir` 
			FROM `connections` 
            UNION DISTINCT 
            SELECT `cn_to`, `cn_from`, `cn_cost`, `cn_bidir` 
            FROM `connections` 
            WHERE `cn_bidir` = 'Y' ) AS `connections_bidir`; 
	-- Наполнение временной таблицы производными -- маршрутами: 
    SET rows_inserted = ROW_COUNT(); 
    WHILE (rows_inserted > 0) 
    DO 
		INSERT INTO `connections_temp` 
        SELECT `connections_next`.`cn_from`, `connections_next`.`cn_to`, `connections_next`.`cn_cost`, `connections_next`.`cn_bidir`, `connections_next`.`cn_steps`, `connections_next`.`cn_route` 
        FROM (SELECT `connections_temp`.`cn_from` AS `cn_from`, `connections`.`cn_to` AS `cn_to`, (`connections_temp`.`cn_cost` + `connections`.`cn_cost`) AS `cn_cost`, 
				CASE WHEN (`connections_temp`.`cn_bidir` = 'Y') AND (`connections`.`cn_bidir` = 'Y') 
					THEN 'Y' 
                    ELSE 'N' 
				END AS `cn_bidir`, (`connections_temp`.`cn_steps` + 1) AS `cn_steps`, CONCAT(`connections_temp`.`cn_route`, ',', `connections`.`cn_to`) AS `cn_route` 
                FROM `connections_temp`
                JOIN (SELECT `cn_from`, `cn_to`, `cn_cost`, `cn_bidir` 
						FROM `connections` 
						UNION DISTINCT 
						SELECT `cn_to`, `cn_from`, `cn_cost`, `cn_bidir` 
						FROM `connections` WHERE `cn_bidir` = 'Y' ) AS `connections` ON `connections_temp`.`cn_to` = `connections`.`cn_from` AND FIND_IN_SET(`connections`.`cn_to`, `connections_temp`.`cn_route`) = 0 ) AS `connections_next` 
				LEFT JOIN `connections_temp` ON `connections_next`.`cn_from` = `connections_temp`.`cn_from` AND `connections_next`.`cn_to` = `connections_temp`.`cn_to` 
                WHERE `connections_temp`.`cn_from` IS NULL AND `connections_temp`.`cn_to` IS NULL; SET rows_inserted = ROW_COUNT(); 
                END WHILE; 
	-- Извлечение маршрутов, соответствующих условию поиска: 
    SELECT * FROM `connections_temp` WHERE `cn_from` = start_node AND `cn_to` = finish_node ORDER BY `cn_cost` ASC; DROP TABLE IF EXISTS `connections_temp`; 
END; 
$$ DELIMITER ;
CALL FIND_PATH(1, 6);
		