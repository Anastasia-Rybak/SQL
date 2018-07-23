-- Задание 2.2.3.TSK.A: показать список книг, которые когда-либо были взяты читателями.
SELECT `b_id`, `b_name` FROM `books` WHERE `b_id` IN (SELECT DISTINCT `b_id` FROM `subscriptions`)