-- Задание 7.1.1.TSK.A: создать функцию, возвращающую список иденти-фикаторов всех дочерних вершин заданной вершины (например, иденти-фикаторов всех подстраниц страницы «Читателям») на глубину, не более заданной.
SET GLOBAL log_bin_trust_function_creators = 1;
DROP function IF EXISTS `GET_ALL_CHILDREN2`;
DELIMITER $$ 
CREATE FUNCTION GET_ALL_CHILDREN2(start_node INT, lim INT) 
RETURNS TEXT 
BEGIN 
DECLARE result TEXT; 
SELECT GROUP_CONCAT(`children_ids` SEPARATOR ',') INTO result FROM ( SELECT `sp_id`, @parent_values := ( SELECT GROUP_CONCAT(`sp_id` SEPARATOR ',') FROM `site_pages` WHERE FIND_IN_SET(`sp_parent`, @parent_values) > 0) AS `children_ids` FROM `site_pages` JOIN (SELECT @parent_values := start_node) AS `initialisation` WHERE `sp_id` IN (@parent_values) limit lim) AS `data`; 
RETURN result; 
END$$ 
DELIMITER ;
SELECT `sp_id`, `sp_name`, GET_ALL_CHILDREN2(`sp_id`, 2) AS `children` FROM `site_pages`;