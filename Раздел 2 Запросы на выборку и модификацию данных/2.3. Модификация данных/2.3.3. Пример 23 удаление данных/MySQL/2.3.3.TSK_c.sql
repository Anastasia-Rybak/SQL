-- Задание 2.2.3.TSK.C: удалить информацию обо всех выдачах книг, произведённых после 20-го числа любого месяца любого года.
SET SQL_SAFE_UPDATES = 0;
DELETE FROM `subscriptions` WHERE day(`sb_start`) > 20;
SET SQL_SAFE_UPDATES = 1;