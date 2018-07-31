-- Задача 2.3.2.b{191}: изменить ожидаемую дату возврата для всех книг, которые читатель с идентификатором 2 взял в библиотеке 25-го января 2016-го года, на «плюс два месяца» (т.е. читатель будет читать их на два месяца дольше, чем планировал).
SET SQL_SAFE_UPDATES = 0;
UPDATE `subscriptions` SET `sb_finish` = DATE_ADD(`sb_finish`, INTERVAL 2 MONTH) WHERE `s_id` = 2 AND `sb_start` = '2016-01-25';
SET SQL_SAFE_UPDATES = 1;