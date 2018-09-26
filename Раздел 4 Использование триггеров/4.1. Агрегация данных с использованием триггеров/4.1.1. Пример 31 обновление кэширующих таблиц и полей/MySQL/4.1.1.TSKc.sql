-- Задание 4.1.1.TSK.C: оптимизировать MySQL-триггеры из решения{281} за-дачи 4.1.1.b{272} так, чтобы не выполнять лишних действий там, где в них нет необходимости (подсказка: не в каждом случае нам нужны все соби-раемые имеющимися запросами данные).
drop table if exists `averages`;
CREATE TABLE `averages` 
( 
	`books_taken` DOUBLE NOT NULL, 
    `days_to_read` DOUBLE NOT NULL, 
    `books_returned` DOUBLE NOT NULL 
);
-- Инициализация данных: 
INSERT INTO `averages` (`books_taken`, `days_to_read`, `books_returned`) 
SELECT ( `active_count` / `subscribers_count` ) AS `books_taken`, 
		( `days_sum` / `inactive_count` ) AS `days_to_read`, 
        ( `inactive_count` / `subscribers_count` ) AS `books_returned` 
FROM (SELECT COUNT(`s_id`) AS `subscribers_count` 
		FROM `subscribers`) AS `tmp_subscribers_count`, 
        (SELECT COUNT(`sb_id`) AS `active_count` 
        FROM `subscriptions` 
        WHERE `sb_is_active` = 'Y') AS `tmp_active_count`, 
        (SELECT COUNT(`sb_id`) AS `inactive_count` 
        FROM `subscriptions` 
        WHERE `sb_is_active` = 'N') AS `tmp_inactive_count`, 
        (SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
        FROM `subscriptions` 
        WHERE `sb_is_active` = 'N') AS `tmp_days_sum`;
DROP TRIGGER if exists `upd_avgs_on_subscribers_ins2`; 
DROP TRIGGER if exists `upd_avgs_on_subscribers_del2`; 
DELIMITER $$ 
CREATE TRIGGER `upd_avgs_on_subscribers_ins2` 
AFTER INSERT ON `subscribers` 
FOR EACH ROW 
    BEGIN 
		UPDATE `averages`, 
			(SELECT COUNT(`s_id`) AS `subscribers_count` 
			FROM `subscribers`) AS `tmp_subscribers_count`, 
			(SELECT COUNT(`sb_id`) AS `active_count`
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'Y') AS `tmp_active_count`, 
			(SELECT COUNT(`sb_id`) AS `inactive_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N') AS `tmp_inactive_count` -- , 
			-- (SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
			-- FROM `subscriptions` 
			-- WHERE `sb_is_active` = 'N') AS `tmp_days_sum` 
		SET `books_taken` = `active_count` / `subscribers_count`, 
			-- `days_to_read` = `days_sum` / `inactive_count`, 
			`books_returned` = `inactive_count` / `subscribers_count`; 
	END; 
$$ 
-- Создание триггера, реагирующего на удаление читателей:
CREATE TRIGGER `upd_avgs_on_subscribers_del2` 
AFTER DELETE ON `subscribers` 
FOR EACH ROW 
	BEGIN 
		UPDATE `averages`, 
			(SELECT COUNT(`s_id`) AS `subscribers_count` 
            FROM `subscribers`) AS `tmp_subscribers_count`, 
            (SELECT COUNT(`sb_id`) AS `active_count` 
            FROM `subscriptions` 
            WHERE `sb_is_active` = 'Y') AS `tmp_active_count`, 
            (SELECT COUNT(`sb_id`) AS `inactive_count` 
            FROM `subscriptions` 
            WHERE `sb_is_active` = 'N') AS `tmp_inactive_count` -- , 
            -- (SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
            -- FROM `subscriptions` 
            -- WHERE `sb_is_active` = 'N') AS `tmp_days_sum` 
		SET `books_taken` = `active_count` / `subscribers_count`, 
			-- `days_to_read` = `days_sum` / `inactive_count`, 
            `books_returned` = `inactive_count` / `subscribers_count`; 
	END; 
$$ 
DELIMITER ;
DROP TRIGGER if exists `upd_avgs_on_subscriptions_ins2`; 
DROP TRIGGER if exists `upd_avgs_on_subscriptions_upd2`; 
DROP TRIGGER if exists `upd_avgs_on_subscriptions_del2`; 
DELIMITER $$ 
-- Создание триггера, реагирующего на добавление выдачи книги: 
CREATE TRIGGER `upd_avgs_on_subscriptions_ins2` 
AFTER INSERT ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		UPDATE `averages`, 
			(SELECT COUNT(`s_id`) AS `subscribers_count` 
			FROM `subscribers`) AS `tmp_subscribers_count`, 
            (SELECT COUNT(`sb_id`) AS `active_count` 
            FROM `subscriptions` 
            WHERE `sb_is_active` = 'Y') AS `tmp_active_count`, 
            (SELECT COUNT(`sb_id`) AS `inactive_count` 
            FROM `subscriptions` 
            WHERE `sb_is_active` = 'N') AS `tmp_inactive_count`, 
            (SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
            FROM `subscriptions` 
            WHERE `sb_is_active` = 'N') AS `tmp_days_sum` 
		SET `books_taken` = `active_count` / `subscribers_count`, 
			`days_to_read` = `days_sum` / `inactive_count`, 
            `books_returned` = `inactive_count` / `subscribers_count`; 
	END; 
$$ 
-- Создание триггера, реагирующего на обновление выдачи книги: 
CREATE TRIGGER `upd_avgs_on_subscriptions_upd2` 
AFTER UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		UPDATE `averages`, 
			(SELECT COUNT(`s_id`) AS `subscribers_count` 
			FROM `subscribers`) AS `tmp_subscribers_count`, 
			(SELECT COUNT(`sb_id`) AS `active_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'Y') AS `tmp_active_count`, 
			(SELECT COUNT(`sb_id`) AS `inactive_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N') AS `tmp_inactive_count`, 
			(SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N') AS `tmp_days_sum` 
        SET `books_taken` = `active_count` / `subscribers_count`, 
			`days_to_read` = `days_sum` / `inactive_count`, 
            `books_returned` = `inactive_count` / `subscribers_count`; 
	END; 
$$
-- Создание триггера, реагирующего на удаление выдачи книги: 
CREATE TRIGGER `upd_avgs_on_subscriptions_del2` 
AFTER DELETE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		UPDATE `averages`, 
			(SELECT COUNT(`s_id`) AS `subscribers_count` 
			FROM `subscribers`) AS `tmp_subscribers_count`, 
            (SELECT COUNT(`sb_id`) AS `active_count` 
            FROM `subscriptions` 
            WHERE `sb_is_active` = 'Y') AS `tmp_active_count`, 
            (SELECT COUNT(`sb_id`) AS `inactive_count` 
            FROM `subscriptions` 
            WHERE `sb_is_active` = 'N') AS `tmp_inactive_count`, 
            (SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
            FROM `subscriptions` 
            WHERE `sb_is_active` = 'N') AS `tmp_days_sum` 
		SET `books_taken` = `active_count` / `subscribers_count`, 
			`days_to_read` = `days_sum` / `inactive_count`, 
            `books_returned` = `inactive_count` / `subscribers_count`; 
	END; 
$$ 
-- Восстановление разделителя завершения запросов: 
DELIMITER ;
set sql_safe_updates = 0;
INSERT INTO `subscribers` (`s_id`, `s_name`) VALUES (500, 'Читателев Ч.Ч.');
DELETE FROM `subscribers` WHERE `s_id` = 500;
INSERT INTO `subscriptions` (`sb_id`, `sb_subscriber`, `sb_book`, `sb_start`, `sb_finish`, `sb_is_active`) VALUES (200, 1, 1, '2019-01-12', '2019-02-12', 'N'), (201, 2, 1, '2020-01-12', '2020-02-12', 'N');
UPDATE `subscriptions` SET `sb_is_active` = 'Y' WHERE `sb_id` >= 200;
DELETE FROM `subscriptions` WHERE `sb_id` >= 200;
set sql_safe_updates = 1;