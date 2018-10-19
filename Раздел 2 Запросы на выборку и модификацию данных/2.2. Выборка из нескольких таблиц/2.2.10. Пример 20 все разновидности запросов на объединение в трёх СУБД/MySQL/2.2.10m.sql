-- Задача 2.2.10.m: показать возможные варианты расстановки свободных компьютеров по комнатам (учитывать остаточную вместимость комнат).
SELECT `r_id`, `r_name`, `r_space`, ( `r_space` - IFNULL(`r_used`, 0) ) AS `r_space_left`, `c_id`, `c_name` 
FROM `rooms` 
LEFT JOIN (SELECT `c_room` AS `c_room_inner`, COUNT(`c_room`) AS `r_used` 
			FROM `computers` 
            GROUP BY `c_room`) AS `computers_in_room` ON `r_id` = `c_room_inner` 
            CROSS JOIN (SELECT `c_id`, `c_room`, `c_name`, @row_num := @row_num + 1 AS `position` 
						FROM `computers`, (SELECT @row_num := 0) AS `x` 
                        WHERE `c_room` IS NULL ORDER BY `c_name` ASC) AS `cross_apply_data` 
                        WHERE `position` <= (`r_space` - IFNULL(`r_used`, 0)) 
                        ORDER BY `r_id`, `c_id`