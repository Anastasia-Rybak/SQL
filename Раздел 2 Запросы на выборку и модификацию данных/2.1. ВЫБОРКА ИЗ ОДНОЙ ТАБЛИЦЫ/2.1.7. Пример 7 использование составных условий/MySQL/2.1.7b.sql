-- Задача 2.1.7.b{40}: показать идентификаторы и даты выдачи книг за лето 2012-го года.
SELECT `sb_id`, `sb_start` FROM `subscriptions` WHERE `sb_start` >= '2012-06-01' AND `sb_start` < '2012-09-01'