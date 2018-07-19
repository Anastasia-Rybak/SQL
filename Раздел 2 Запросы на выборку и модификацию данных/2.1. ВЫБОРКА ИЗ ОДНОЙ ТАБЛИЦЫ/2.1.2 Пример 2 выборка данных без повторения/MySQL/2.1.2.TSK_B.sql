-- Задание 2.1.2.TSK.B: показать по каждой книге, которую читатели брали в библиотеке, количество выдач этой книги читателям.
SELECT `b_id`, COUNT(*) AS `count` FROM `subscriptions` GROUP BY `b_id`