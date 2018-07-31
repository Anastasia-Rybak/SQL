-- Задание 2.3.3.TSK.A: удалить информацию обо всех выдачах читателям книги с идентификатором 1.
SET SQL_SAFE_UPDATES = 0;
DELETE FROM `subscriptions` WHERE `s_id` = 1;
SET SQL_SAFE_UPDATES = 1;