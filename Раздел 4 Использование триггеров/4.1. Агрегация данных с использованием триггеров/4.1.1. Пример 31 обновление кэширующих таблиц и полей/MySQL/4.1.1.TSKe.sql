-- Задание 4.1.1.TSK.E: доработать решение{281} задачи 4.1.1.b{272} для MySQL таким образом, чтобы оно учитывало изменения в таблице sub-scriptions, вызванные операцией каскадного удаления (при удалении книг). Убедиться, что решения для MS SQL Server и Oracle не требуют такой доработки.
drop table if exists `averages`;
CREATE TABLE `averages` 
( 
	`books_taken` DOUBLE NOT NULL, 
    `days_to_read` DOUBLE NOT NULL, 
    `books_returned` DOUBLE NOT NULL 
);
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
DELIMITER $$;
CREATE TRIGGER `upd_avgs_on_books_del` 
AFTER DELETE ON `books` 
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
DELIMITER ;
set sql_safe_updates = 0;
delete from books where b_id = 3;
set sql_safe_updates = 1;