-- Задание 4.1.1.TSK.B: создать кэширующую таблицу best_averages, со-держащую в любой момент времени следующую актуальную информа-цию:
-- а) сколько в среднем книг находится на руках у читателей, за время ра-боты с библиотекой прочитавших более 20 книг;
-- б) за сколько в среднем по времени (в днях) прочитывает книгу читатель, никогда не державший у себя книгу больше двух недель;
-- в) сколько в среднем книг прочитал читатель, не имеющий просроченных выдач книг.
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
		ifnull( `days_sum` / `inactive_count`, 0) AS `days_to_read`, 
        ( `inactive_count2` / `subscribers_count2` ) AS `books_returned` 
        
FROM (SELECT COUNT(`s_id`) AS `subscribers_count` 
		FROM `subscribers`
        where `s_id` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
        AS `tmp_subscribers_count`,
        
        (SELECT COUNT(`s_id`) AS `subscribers_count2` 
		FROM `subscribers`
        where `s_id` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate())) 
        AS `tmp_subscribers_count2`,
        
        (SELECT COUNT(`sb_id`) AS `active_count` 
        FROM `subscriptions` 
        WHERE `sb_is_active` = 'Y'
        AND `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
        AS `tmp_active_count`,
        
        (SELECT COUNT(`sb_id`) AS `inactive_count2` 
        FROM `subscriptions` 
        WHERE `sb_is_active` = 'N' and `sb_subscriber` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate()))
        AS `tmp_inactive_count2`,
        
        (SELECT COUNT(`sb_id`) AS `inactive_count` 
        FROM `subscriptions` 
        WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
        AS `tmp_inactive_count`,
        
        (SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
        FROM `subscriptions` 
        WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
        AS `tmp_days_sum`;
DROP TRIGGER if exists `upd_avgs_on_subscribers_ins`; 
DROP TRIGGER if exists `upd_avgs_on_subscribers_del`; 
DELIMITER $$ 
CREATE TRIGGER `upd_avgs_on_subscribers_ins` 
AFTER INSERT ON `subscribers` 
FOR EACH ROW 
    BEGIN 
		UPDATE `averages`, 
			(SELECT COUNT(`s_id`) AS `subscribers_count` 
			FROM `subscribers`
			where `s_id` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
			AS `tmp_subscribers_count`,
			
			(SELECT COUNT(`s_id`) AS `subscribers_count2` 
			FROM `subscribers`
			where `s_id` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate())) 
			AS `tmp_subscribers_count2`,
			
			(SELECT COUNT(`sb_id`) AS `active_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'Y'
			AND `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
			AS `tmp_active_count`,
			
			(SELECT COUNT(`sb_id`) AS `inactive_count2` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate()))
			AS `tmp_inactive_count2`,
			
			(SELECT COUNT(`sb_id`) AS `inactive_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
			AS `tmp_inactive_count`,
			
			(SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
			AS `tmp_days_sum`
		SET `books_taken` = `active_count` / `subscribers_count`, 
			`days_to_read` = ifnull( `days_sum` / `inactive_count`, 0), 
			`books_returned` = `inactive_count2` / `subscribers_count2`; 
	END; 
$$ 
-- Создание триггера, реагирующего на удаление читателей:
CREATE TRIGGER `upd_avgs_on_subscribers_del` 
AFTER DELETE ON `subscribers` 
FOR EACH ROW 
	BEGIN 
		UPDATE `averages`, 
			(SELECT COUNT(`s_id`) AS `subscribers_count` 
			FROM `subscribers`
			where `s_id` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
			AS `tmp_subscribers_count`,
			
			(SELECT COUNT(`s_id`) AS `subscribers_count2` 
			FROM `subscribers`
			where `s_id` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate())) 
			AS `tmp_subscribers_count2`,
			
			(SELECT COUNT(`sb_id`) AS `active_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'Y'
			AND `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
			AS `tmp_active_count`,
			
			(SELECT COUNT(`sb_id`) AS `inactive_count2` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate()))
			AS `tmp_inactive_count2`,
			
			(SELECT COUNT(`sb_id`) AS `inactive_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
			AS `tmp_inactive_count`,
			
			(SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
			AS `tmp_days_sum`
		SET `books_taken` = `active_count` / `subscribers_count`, 
			`days_to_read` = ifnull( `days_sum` / `inactive_count`, 0), 
			`books_returned` = `inactive_count2` / `subscribers_count2`; 
	END; 
$$ 
DELIMITER ;
DROP TRIGGER if exists `upd_avgs_on_subscriptions_ins`; 
DROP TRIGGER if exists `upd_avgs_on_subscriptions_upd`; 
DROP TRIGGER if exists `upd_avgs_on_subscriptions_del`; 
DELIMITER $$ 
-- Создание триггера, реагирующего на добавление выдачи книги: 
CREATE TRIGGER `upd_avgs_on_subscriptions_ins` 
AFTER INSERT ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		UPDATE `averages`, 
			(SELECT COUNT(`s_id`) AS `subscribers_count` 
			FROM `subscribers`
			where `s_id` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
			AS `tmp_subscribers_count`,
			
			(SELECT COUNT(`s_id`) AS `subscribers_count2` 
			FROM `subscribers`
			where `s_id` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate())) 
			AS `tmp_subscribers_count2`,
			
			(SELECT COUNT(`sb_id`) AS `active_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'Y'
			AND `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
			AS `tmp_active_count`,
			
			(SELECT COUNT(`sb_id`) AS `inactive_count2` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate()))
			AS `tmp_inactive_count2`,
			
			(SELECT COUNT(`sb_id`) AS `inactive_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
			AS `tmp_inactive_count`,
			
			(SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
			AS `tmp_days_sum`
		SET `books_taken` = `active_count` / `subscribers_count`, 
			`days_to_read` = ifnull( `days_sum` / `inactive_count`, 0), 
			`books_returned` = `inactive_count2` / `subscribers_count2`; 
	END; 
$$ 
-- Создание триггера, реагирующего на обновление выдачи книги: 
CREATE TRIGGER `upd_avgs_on_subscriptions_upd` 
AFTER UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		UPDATE `averages`, 
			(SELECT COUNT(`s_id`) AS `subscribers_count` 
			FROM `subscribers`
			where `s_id` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
			AS `tmp_subscribers_count`,
			
			(SELECT COUNT(`s_id`) AS `subscribers_count2` 
			FROM `subscribers`
			where `s_id` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate())) 
			AS `tmp_subscribers_count2`,
			
			(SELECT COUNT(`sb_id`) AS `active_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'Y'
			AND `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
			AS `tmp_active_count`,
			
			(SELECT COUNT(`sb_id`) AS `inactive_count2` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate()))
			AS `tmp_inactive_count2`,
			
			(SELECT COUNT(`sb_id`) AS `inactive_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
			AS `tmp_inactive_count`,
			
			(SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
			AS `tmp_days_sum`
		SET `books_taken` = `active_count` / `subscribers_count`, 
			`days_to_read` = ifnull( `days_sum` / `inactive_count`, 0), 
			`books_returned` = `inactive_count2` / `subscribers_count2`; 
	END; 
$$
-- Создание триггера, реагирующего на удаление выдачи книги: 
CREATE TRIGGER `upd_avgs_on_subscriptions_del` 
AFTER DELETE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		UPDATE `averages`, 
			(SELECT COUNT(`s_id`) AS `subscribers_count` 
			FROM `subscribers`
			where `s_id` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
			AS `tmp_subscribers_count`,
			
			(SELECT COUNT(`s_id`) AS `subscribers_count2` 
			FROM `subscribers`
			where `s_id` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate())) 
			AS `tmp_subscribers_count2`,
			
			(SELECT COUNT(`sb_id`) AS `active_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'Y'
			AND `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, count(`sb_book`) as `count` from `subscriptions` where `sb_is_active` = 'N' group by  `sb_subscriber` having `count` > 3) as `data`)) 
			AS `tmp_active_count`,
			
			(SELECT COUNT(`sb_id`) AS `inactive_count2` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` not in (select distinct `sb_subscriber` from `subscriptions` where `sb_is_active` = 'Y' and `sb_finish`< curdate()))
			AS `tmp_inactive_count2`,
			
			(SELECT COUNT(`sb_id`) AS `inactive_count` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
			AS `tmp_inactive_count`,
			
			(SELECT SUM(DATEDIFF(`sb_finish`, `sb_start`)) AS `days_sum` 
			FROM `subscriptions` 
			WHERE `sb_is_active` = 'N' and `sb_subscriber` in (select `sb_subscriber` from (select `sb_subscriber`, Max(datediff(`sb_finish`,`sb_start`)) as `max` from `subscriptions` where `sb_is_active` = 'N' group by `sb_subscriber` having `max` <= 14) as `data`))
			AS `tmp_days_sum`
		SET `books_taken` = `active_count` / `subscribers_count`, 
			`days_to_read` = ifnull( `days_sum` / `inactive_count`, 0), 
			`books_returned` = `inactive_count2` / `subscribers_count2`; 
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