-- Задача 2.1.4.b{30}: показать, сколько всего разных книг выдано читателям.
SELECT COUNT( distinct `b_id`) AS `in_use` FROM `subscriptions` WHERE `sb_is_active` = 'Y'