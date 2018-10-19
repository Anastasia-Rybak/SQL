-- Задача 4.2.1.b{328}: создать триггер, не позволяющий выдать книгу чита-телю, у которого на руках находится десять и более книг.
drop trigger if exists `sbs_cntrl_10_books_ins_OK`; 
drop trigger if exists `sbs_cntrl_10_books_upd_OK`; 
DELIMITER $$ 
CREATE TRIGGER `sbs_cntrl_10_books_ins_OK` 
BEFORE INSERT ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		SET @msg = IFNULL((SELECT CONCAT('Subscriber ', `s_name`, ' (id=', `sb_subscriber`, ') already has ', `sb_books`, ' books out of 2 allowed.') AS `message` 
			FROM (SELECT `sb_subscriber`, COUNT(`sb_book`) AS `sb_books` FROM `subscriptions` WHERE `sb_is_active` = 'Y' AND `sb_subscriber` = NEW.`sb_subscriber` GROUP BY `sb_subscriber` HAVING `sb_books` >= 2) AS `prepared_data` 
			JOIN `subscribers` ON `sb_subscriber` = `s_id`), ''); 
		IF (LENGTH(@msg) > 0) THEN 
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	END; 
$$ 
CREATE TRIGGER `sbs_cntrl_10_books_upd_OK` 
BEFORE UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		SET @msg = IFNULL((SELECT CONCAT('Subscriber ', `s_name`, ' (id=', `sb_subscriber`, ') already has ', `sb_books`, ' books out of 2 allowed.') AS `message` 
			FROM (SELECT `sb_subscriber`, COUNT(`sb_book`) AS `sb_books` FROM `subscriptions` WHERE `sb_is_active` = 'Y' AND `sb_subscriber` = NEW.`sb_subscriber` GROUP BY `sb_subscriber` HAVING `sb_books` >= 2) AS `prepared_data` 
            JOIN `subscribers` ON `sb_subscriber` = `s_id`), ''); 
		IF (LENGTH(@msg) > 0) THEN 
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	END;
$$ 
DELIMITER ;
INSERT INTO `subscriptions` VALUES (600, 3, 3, '2015-01-12', '2015-02-12', 'N');
UPDATE `subscriptions` SET `sb_is_active` = 'Y' WHERE `sb_id` = 57;

