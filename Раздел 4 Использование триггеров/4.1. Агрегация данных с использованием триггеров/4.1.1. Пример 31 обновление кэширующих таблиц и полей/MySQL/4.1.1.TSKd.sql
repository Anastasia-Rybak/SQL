-- Задание 4.1.1.TSK.D: доработать решение{272} задачи 4.1.1.a{272} для MySQL таким образом, чтобы оно учитывало изменения в таблице sub-scriptions, вызванные операцией каскадного удаления (при удалении книг). Убедиться, что решения для MS SQL Server и Oracle не требуют такой доработки.
DROP TRIGGER if exists `last_visit_on_books_del`;
DELIMITER $$
CREATE TRIGGER `last_visit_on_books_del` 
AFTER DELETE ON `books` 
FOR EACH ROW 
	BEGIN 
		UPDATE `subscribers` LEFT JOIN (SELECT `sb_subscriber`, MAX(`sb_start`) AS `last_visit` FROM `subscriptions` GROUP BY `sb_subscriber`) AS `prepared_data` on `s_id` = `sb_subscriber`
        SET `s_last_visit` = `last_visit`;
	END;
$$
DELIMITER ;
set sql_safe_updates = 0;
delete from books where b_id = 4;
set sql_safe_updates = 1;

