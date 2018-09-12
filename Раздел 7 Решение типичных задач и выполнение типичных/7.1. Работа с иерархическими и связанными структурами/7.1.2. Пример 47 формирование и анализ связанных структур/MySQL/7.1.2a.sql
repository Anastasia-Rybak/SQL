-- Задача 7.1.2.a{492}: доработать модель базы данных таким образом, чтобы для прямых маршрутов (без пересадок), цена перемещения по которым «туда» и «обратно» одинакова, в запросе на поиск такого маршрута можно было произвольно менять местами точки отправки и назначения.
CREATE OR REPLACE VIEW `connections_bidir` 
AS 
	SELECT `cn_from`, `cn_to`, `cn_cost`, `cn_bidir` 
	FROM `connections` 
    UNION DISTINCT 
    SELECT `cn_to`, `cn_from`, `cn_cost`, `cn_bidir` 
    FROM `connections` 
    WHERE `cn_bidir` = 'Y';
SELECT * FROM `connections_bidir` WHERE `cn_from` = 5 AND `cn_to` = 1