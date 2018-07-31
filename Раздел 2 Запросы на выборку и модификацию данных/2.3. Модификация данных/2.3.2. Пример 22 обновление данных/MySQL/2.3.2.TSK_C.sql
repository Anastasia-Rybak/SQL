-- Задание 2.2.2.TSK.C: отметить как невозвращённые все выдачи, полученные читателем с идентификатором 2.
SET SQL_SAFE_UPDATES = 0;
UPDATE `subscriptions` SET `sb_is_active` = 'N' WHERE s_id = 2;
SET SQL_SAFE_UPDATES = 1;