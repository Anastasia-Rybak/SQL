-- Задание 2.2.3.TSK.B: показать список книг, которые никто из читателей никогда не брал.
SELECT `b_id`, `b_name` FROM `books` WHERE `b_id` NOT IN (SELECT DISTINCT `b_id` FROM `subscriptions`)