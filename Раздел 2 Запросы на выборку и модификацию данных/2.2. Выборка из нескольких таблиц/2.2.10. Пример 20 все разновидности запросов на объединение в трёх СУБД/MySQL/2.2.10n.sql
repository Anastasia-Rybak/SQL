-- Задача 2.2.10.n: показать расстановку компьютеров по непустым комна-там так, чтобы в выборку не попало больше компьютеров, чем может по-меститься в комнату.
SELECT `r_id`, `r_name`, `r_space`, `c_id`, `c_room`, `c_name` 
	FROM `rooms` JOIN 
	(SELECT `c_id`, `c_room`, `c_name`, @row_num := IF(@prev_value = `c_room`, @row_num + 1, 1) AS `position`, @prev_value := `c_room` 
		FROM `computers`, (SELECT @row_num := 1) AS `x`, (SELECT @prev_value := '') AS `y` 
			ORDER BY `c_room`, `c_name` ASC) AS `cross_apply_data` ON `r_id` = `c_room` 
            WHERE `position` <= `r_space` 
            ORDER BY `r_id`, `c_id`