-- Задание 7.1.1.TSK.C: написать функцию, возвращающую список иденти-фикаторов вершин на пути от корня дерева к заданной вершине (напри-мер, идентификаторов всех вершин на пути от страницы «Главная» к странице «Архивная»).
SET GLOBAL log_bin_trust_function_creators = 1;
DROP function IF EXISTS `GET_PATH_TO_ROOT2`;
DELIMITER $$ 
CREATE FUNCTION GET_PATH_TO_ROOT2(start_node INT, end_node INT) 
RETURNS TEXT
BEGIN 
	DECLARE path_to_root TEXT; 
	DECLARE current_node INT; 
    DECLARE isFound boolean;
    SET ISFOUND = false;
	SET current_node = start_node; 
	SET path_to_root = start_node; 
	wet: LOOP SELECT `sp_parent` INTO current_node FROM `site_pages` WHERE `sp_id` = current_node; 
		IF (current_node != end_node) THEN 
			SET path_to_root = CONCAT(current_node, ',', path_to_root);
		ELSE 
			SET path_to_root = CONCAT(current_node, ',', path_to_root);
			SET ISFOUND = TRUE;
			leave wet;
		END IF; 
	END LOOP wet;
    IF(ISFOUND = FALSE) THEN		
		RETURN null;
    ELSE 
		RETURN path_to_root;
	END IF;
END$$ 
DELIMITER ;
SELECT GET_PATH_TO_ROOT2(13,2)