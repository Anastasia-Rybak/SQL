-- Задача 2.2.10.a: показать информацию о том, как компьютеры распреде-лены по комнатам.
SELECT `r_id`, `r_name`, `c_id`, `c_room`, `c_name` FROM `rooms` JOIN `computers` ON `r_id` = `c_room`