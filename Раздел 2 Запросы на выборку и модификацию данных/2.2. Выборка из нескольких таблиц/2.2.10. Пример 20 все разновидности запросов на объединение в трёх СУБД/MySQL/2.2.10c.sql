-- Задача 2.2.10.c: показать все пустые комнаты.
SELECT `r_id`, `r_name`, `c_id`, `c_room`, `c_name` FROM `rooms` LEFT JOIN `computers` ON `r_id` = `c_room` WHERE `c_room` IS NULL