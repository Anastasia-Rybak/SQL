-- Задание 2.1.4.TSK.B: показать, сколько читателей брало книги в библиотеке.
SELECT COUNT( distinct `s_id`) AS `in_use` FROM `subscriptions`