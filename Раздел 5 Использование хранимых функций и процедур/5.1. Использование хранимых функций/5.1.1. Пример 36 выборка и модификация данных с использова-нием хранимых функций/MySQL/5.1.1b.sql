-- Задача 5.1.1.b{355}: создать хранимую функцию, возвращающую список свободных значений автоинкрементируемых первичных ключей в указан-ной таблице (свободными считаются значения первичного ключа, кото-рые отсутствуют в таблице, и при этом меньше максимального использу-емого значения; например, если в таблице есть первичные ключи 1, 3, 8, то свободными считаются 2, 4, 5, 6, 7).
DROP FUNCTION IF EXISTS GET_FREE_KEYS_IN_SUBSCRIPTIONS; 
DELIMITER $$ 
CREATE FUNCTION GET_FREE_KEYS_IN_SUBSCRIPTIONS() 
RETURNS VARCHAR(21845) DETERMINISTIC
BEGIN 
	DECLARE start_value INT DEFAULT 0; 
    DECLARE stop_value INT DEFAULT 0; 
    DECLARE done INT DEFAULT 0; 
    DECLARE free_keys_string VARCHAR(21845) DEFAULT '';
    DECLARE free_keys_cursor CURSOR FOR 
		SELECT `start`, `stop` 
        FROM (SELECT `min_t`.`sb_id` + 1 AS `start`, (SELECT MIN(`sb_id`) - 1 
				FROM `subscriptions` AS `x` WHERE `x`.`sb_id` > `min_t`.`sb_id`) AS `stop` 
            FROM `subscriptions` AS `min_t` 
            UNION SELECT 1 AS `start`, (SELECT MIN(`sb_id`) - 1 
				FROM `subscriptions` AS `x` WHERE `sb_id` > 0) AS `stop` ) AS `data` WHERE `stop` >= `start` ORDER BY `start`, `stop`; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
    OPEN free_keys_cursor; 
    BEGIN read_loop: 
		LOOP FETCH free_keys_cursor INTO start_value, stop_value; 
			IF done THEN 
				LEAVE read_loop; 
			END IF; 
			for_loop: LOOP 
				SET free_keys_string = CONCAT(free_keys_string, start_value, ','); 
				SET start_value := start_value + 1; 
				IF start_value <= stop_value THEN 
					ITERATE for_loop; 
				END IF; 
				LEAVE for_loop; 
			END LOOP for_loop; 
		END LOOP read_loop; 
	END; 
    CLOSE free_keys_cursor; 
    RETURN SUBSTRING(free_keys_string, 1, CHAR_LENGTH(free_keys_string) - 1); 
END; 
$$ 
DELIMITER ;
SELECT GET_FREE_KEYS_IN_SUBSCRIPTIONS();