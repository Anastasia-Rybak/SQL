-- Задача 7.1.1.c{485}: написать функцию, возвращающую список идентифи-каторов вершин на пути от заданной вершины к корню дерева (например, идентификаторов всех вершин на пути от страницы «Архивная» к стра-нице «Главная»).
SET GLOBAL log_bin_trust_function_creators = 1;
DROP function IF EXISTS `GET_PATH_TO_ROOT`;
DELIMITER $$ 
CREATE FUNCTION GET_PATH_TO_ROOT(start_node INT) 
RETURNS TEXT 
NOT DETERMINISTIC 
BEGIN 
	DECLARE path_to_root TEXT; 
	DECLARE current_node INT; 
	DECLARE EXIT HANDLER FOR NOT FOUND RETURN path_to_root; 
	SET current_node = start_node; 
	SET path_to_root = start_node; 
	LOOP SELECT `sp_parent` INTO current_node FROM `site_pages` WHERE `sp_id` = current_node; 
		IF (current_node IS NOT NULL) THEN 
			SET path_to_root = CONCAT(path_to_root, ',', current_node); 
		END IF; 
	END LOOP; 
END$$ 
DELIMITER ;
SELECT GET_PATH_TO_ROOT(13)
