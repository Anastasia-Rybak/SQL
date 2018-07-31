-- Задача 2.3.3.b{193}: удалить информацию обо всех посещениях библиотеки читателем с идентификатором 3 по воскресеньям.
SET SQL_SAFE_UPDATES = 0;
DELETE FROM `subscriptions` WHERE `s_id` = 3 AND DAYOFWEEK(`sb_start`) = 1;
SET SQL_SAFE_UPDATES = 1;