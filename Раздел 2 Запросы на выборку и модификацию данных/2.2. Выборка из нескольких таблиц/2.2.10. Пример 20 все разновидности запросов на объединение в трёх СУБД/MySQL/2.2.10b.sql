-- Задача 2.2.10.b: показать все комнаты с поставленными в них компьюте-рами.
SELECT `r_id`, `r_name`, `c_id`, `c_room`, `c_name` FROM `rooms` LEFT JOIN `computers` ON `r_id` = `c_room`