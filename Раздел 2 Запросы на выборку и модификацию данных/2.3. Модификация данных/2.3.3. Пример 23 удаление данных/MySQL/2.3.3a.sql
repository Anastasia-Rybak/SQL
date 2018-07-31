-- Задача 2.3.3.a{193}: удалить информацию о том, что читатель с идентифи-катором 4 взял 15-го января 2016-го года в библиотеке книгу с идентифи-катором 3.
SET SQL_SAFE_UPDATES = 0;
DELETE FROM `subscriptions` WHERE `s_id` = 4 AND `sb_start` = '2016-01-15' AND `b_id` = 3;
set SQL_SAFE_UPDATES = 1;