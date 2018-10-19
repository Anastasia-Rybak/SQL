-- Задание 2.3.2.TSK.A: отметить все выдачи с идентификаторами ≤50 как возвращённые.
SET SQL_SAFE_UPDATES = 0;
UPDATE `subscriptions` SET `sb_is_active` = 'Y' WHERE `sb_id` <= 50;
SET SQL_SAFE_UPDATES = 1;