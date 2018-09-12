-- Задача 7.1.2.b{493}: написать хранимую процедуру, проверяющую суще-ствование маршрута (с возможными пересадками) между двумя указан-ными городами, и вычисляющую стоимость отправки книги по такому маршруту (при его наличии).
DROP PROCEDURE IF EXISTS FIND_PATH2;
-- Создание таблицы для хранения текущего пути: 
CREATE TABLE IF NOT EXISTS `current_path` ( `cp_id` INT PRIMARY KEY AUTO_INCREMENT, `cp_from` INT, `cp_to` INT, `cp_cost` DOUBLE, `cp_bidir` CHAR(1) ) ENGINE = MEMORY; 
-- Создание таблицы для хранения готовых путей: 
CREATE TABLE IF NOT EXISTS `final_paths` ( `fp_id` DOUBLE, `fp_from` INT, `fp_to` INT, `fp_cost` DOUBLE, `fp_bidir` CHAR(1) ) ENGINE = MEMORY; 
-- Установка максимального уровня вложенности рекурсивных вызовов: 
SET @@SESSION.max_sp_recursion_depth = 255;
DELIMITER $$ 
CREATE PROCEDURE FIND_PATH2(IN start_node INT, IN finish_node INT) 
BEGIN 
	-- Признак выхода из цикла курсора: 
    DECLARE done INT DEFAULT 0; 
    -- Переменные для извлечения данных из курсора: 
    DECLARE cn_from_value INT DEFAULT 0; 
    DECLARE cn_to_value INT DEFAULT 0; 
    DECLARE cn_cost_value DOUBLE DEFAULT 0; 
    DECLARE cn_bidir_value CHAR(1) DEFAULT 0; 
    -- Текущая "отправная точка" 
    -- ВАЖНО! Эту переменную нельзя делать @глобальной ! 
    DECLARE from_node INT DEFAULT 0;
    -- Курсор 
    DECLARE nodes_cursor CURSOR FOR 
    SELECT * 
    FROM (SELECT `cn_from`, `cn_to`, `cn_cost`, `cn_bidir` 
			FROM `connections` 
            UNION DISTINCT 
            SELECT `cn_to`, `cn_from`, `cn_cost`, `cn_bidir` 
            FROM `connections` 
            WHERE `cn_bidir` = 'Y') AS `connections_bidir`; 
	-- здесь можно дописать -- WHERE `cn_from` = from_node -- и убрать далее -- IF (cn_from_value != from_node) 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
    IF ((SELECT COUNT(1) FROM `current_path`) = 0) THEN 
    -- Если текущий путь пуст, отправной точкой 
    -- является точка старта 
		SET from_node = start_node; 
    ELSE 
    -- Если текущий путь НЕ пуст, отправной точкой 
    -- является точка прибытия последней связи в пути 
		SET from_node = (SELECT `cp_to` 
							FROM `current_path` 
							WHERE `cp_id` = 
							(SELECT MAX(`cp_id`) FROM `current_path`) ); 
	END IF; 
    OPEN nodes_cursor; 
    nodes_loop: 
    LOOP FETCH nodes_cursor INTO cn_from_value, cn_to_value, cn_cost_value, cn_bidir_value; 
		IF done THEN 
			LEAVE nodes_loop; 
		END IF; 
	-- Отправная точка связи не совпадает с текущей 
	-- отправной точкой, пропускаем 
		IF (cn_from_value != from_node) THEN 
			ITERATE nodes_loop; 
		END IF;
	-- Такая связь уже есть в текущем пути, пропускаем 
        IF EXISTS (SELECT 1 
					FROM `current_path` 
                    WHERE `cp_from` = cn_from_value AND `cp_to` = cn_to_value) THEN 
            ITERATE nodes_loop; 
		END IF; 
	-- Такая связь приводит к циклу, пропускаем 
        IF EXISTS (SELECT 1 
					FROM `current_path` 
                    WHERE `cp_from` = cn_to_value) THEN 
			ITERATE nodes_loop; 
		END IF; 
	-- Конечная точка связи совпала с точкой финиша, путь найден 
        IF (cn_to_value = finish_node) THEN 
			SET @rand_value = RAND(); 
            INSERT INTO `final_paths` (`fp_id`, `fp_from`, `fp_to`, `fp_cost`, `fp_bidir`) 
				SELECT @rand_value, `cp_from`, `cp_to`, `cp_cost`, `cp_bidir` 
                FROM `current_path`; 
			INSERT INTO `final_paths` (`fp_id`, `fp_from`, `fp_to`, `fp_cost`, `fp_bidir`) 
            VALUES (@rand_value, cn_from_value, cn_to_value, cn_cost_value, cn_bidir_value); 
		ELSE
	-- Добавляем связь в текущий путь 
			INSERT INTO `current_path` (`cp_id`, `cp_from`, `cp_to`, `cp_cost`, `cp_bidir`) 
            VALUES (NULL, cn_from_value, cn_to_value, cn_cost_value, cn_bidir_value); 
	-- Продолжаем рекурсивно искать следующие связи 
		CALL FIND_PATH2 (start_node, finish_node); 
    -- Удаляем последнюю связь из текущего пути 
		SET @max_cp_id = (SELECT MAX(`cp_id`) FROM `current_path`); 
		DELETE FROM `current_path` 
		WHERE `cp_id` = @max_cp_id; 
    END IF; 
    END LOOP nodes_loop; 
    CLOSE nodes_cursor;   
END; 
$$ DELIMITER ;
TRUNCATE TABLE `current_path`; 
TRUNCATE TABLE `final_paths`;
CALL FIND_PATH2(1, 6);
SELECT * FROM `final_paths`;
DROP TABLE IF EXISTS `current_path`;
DROP TABLE IF EXISTS `final_paths`;
		