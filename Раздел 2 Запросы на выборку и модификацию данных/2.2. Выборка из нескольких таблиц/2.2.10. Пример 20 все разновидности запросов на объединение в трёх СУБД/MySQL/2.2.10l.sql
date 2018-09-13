-- Задача 2.2.10.l: показать возможные варианты расстановки свободных компьютеров по пустым комнатам (учитывать вместимость комнат).
SELECT `r_id`, `r_name`, `r_space`, `c_id`, `c_room`, `c_name` 
FROM (SELECT `r_id`, `r_name`, `r_space` 
		FROM `rooms` 
        WHERE `r_id` NOT IN 
        (SELECT `c_room` 
			FROM `computers` 
            WHERE `c_room` IS NOT NULL)) AS `empty_rooms` 
	CROSS JOIN 
		(SELECT `c_id`, `c_room`, `c_name`, @row_num := @row_num + 1 AS `position` 
			FROM `computers`, (SELECT @row_num := 0) AS `x` 
            WHERE `c_room` IS NULL ORDER BY `c_name` ASC) AS `cross_apply_data` 
            WHERE `position` <= `r_space` 
            ORDER BY `r_id`, `c_id`