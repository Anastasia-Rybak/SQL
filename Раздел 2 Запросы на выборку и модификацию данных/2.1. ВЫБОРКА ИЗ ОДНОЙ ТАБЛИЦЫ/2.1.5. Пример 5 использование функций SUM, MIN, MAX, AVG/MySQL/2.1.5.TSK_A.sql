-- Задание 2.1.5.TSK.A: показать первую и последнюю даты выдачи книги читателю.
SELECT MIN(`sb_start`) AS `min`, MAX(`sb_start`) AS `max` FROM `subscriptions`