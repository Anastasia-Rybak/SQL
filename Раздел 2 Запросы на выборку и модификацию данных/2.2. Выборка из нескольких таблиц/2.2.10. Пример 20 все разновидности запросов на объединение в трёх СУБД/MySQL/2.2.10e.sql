-- Задача 2.2.10.e: показать все свободные компьютеры.
SELECT `r_id`, `r_name`, `c_id`, `c_room`, `c_name` FROM `rooms` RIGHT JOIN `computers` ON `r_id` = `c_room` WHERE `r_id` IS NULL
