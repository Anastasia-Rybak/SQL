-- Задача 2.1.4.a{29}: показать, сколько всего экземпляров книг выдано чита-телям.
SELECT COUNT(`b_id`) AS `in_use` FROM `subscriptions` WHERE `sb_is_active` = 'Y'