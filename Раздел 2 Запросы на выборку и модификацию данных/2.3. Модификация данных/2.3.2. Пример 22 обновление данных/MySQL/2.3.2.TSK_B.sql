-- Задание 2.2.2.TSK.B: для всех выдач, произведённых до 1-го января 2012-го года, уменьшить значение дня выдачи на 3.
SET SQL_SAFE_UPDATES = 0;
UPDATE `subscriptions` SET `sb_start` = DATE_SUB(`sb_start`, INTERVAL 3 DAY) WHERE date(`sb_start`) < '2012-01-01';
SET SQL_SAFE_UPDATES = 1;