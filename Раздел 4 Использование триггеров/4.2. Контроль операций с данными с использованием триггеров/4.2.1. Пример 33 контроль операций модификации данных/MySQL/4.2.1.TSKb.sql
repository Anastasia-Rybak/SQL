-- Задание 4.2.1.TSK.B: создать триггер, не позволяющий выдать книгу чи-тателю, у которого на руках находится пять и более книг, при условии, что суммарное время, оставшееся до возврата всех выданных ему книг, со-ставляет менее одного месяца.
drop trigger if exists `sbs_cntrl_10_books_ins_OK2`; 
drop trigger if exists `sbs_cntrl_10_books_upd_OK2`; 
DELIMITER $$ 
create TRIGGER `sbs_cntrl_10_books_ins_OK2` 
BEFORE INSERT ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		SET @msg = IFNULL((SELECT CONCAT('Subscriber ', `s_name`, ' (id=', `sb_subscriber`, ') already has ', `sb_books`, ' books out of 2 allowed.') AS `message` 
			FROM (SELECT `sb_subscriber`, COUNT(`sb_book`) AS `sb_books`, sum(datediff(`sb_finish`, curdate())) as `sum` FROM `subscriptions` WHERE `sb_is_active` = 'Y' and `sb_finish` > curdate() AND `sb_subscriber` = NEW.`sb_subscriber` GROUP BY `sb_subscriber` HAVING `sb_books` >= 2 and `sum` < 30) AS `prepared_data` 
			JOIN `subscribers` ON `sb_subscriber` = `s_id`), ''); 
		IF (LENGTH(@msg) > 0) THEN 
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	END; 
$$ 
create TRIGGER `sbs_cntrl_10_books_upd_OK2` 
BEFORE UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		SET @msg = IFNULL((SELECT CONCAT('Subscriber ', `s_name`, ' (id=', `sb_subscriber`, ') already has ', `sb_books`, ' books out of 2 allowed.') AS `message` 
			FROM (SELECT `sb_subscriber`, COUNT(`sb_book`) AS `sb_books`, sum(datediff(`sb_finish`, curdate())) as `sum` FROM `subscriptions` WHERE `sb_is_active` = 'Y' and `sb_finish` > curdate() AND `sb_subscriber` = NEW.`sb_subscriber` GROUP BY `sb_subscriber` HAVING `sb_books` >= 2 and `sum` < 30) AS `prepared_data`
            JOIN `subscribers` ON `sb_subscriber` = `s_id`), ''); 
		IF (LENGTH(@msg) > 0) THEN 
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	END;
$$ 
DELIMITER ;