-- Задача 4.2.1.a{315}: создать триггер, не позволяющий добавить в базу дан-ных информацию о выдаче книги, если выполняется хотя бы одно из условий:
-- • дата выдачи находится в будущем;
-- • дата возврата находится в прошлом (только для вставки данных);
-- • дата возврата меньше даты выдачи.
drop trigger if exists `subscriptions_control_ins`; 
drop trigger if exists `subscriptions_control_upd`; 
DELIMITER $$ 
CREATE TRIGGER `subscriptions_control_ins` 
AFTER INSERT ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
    -- Блокировка выдач книг с датой выдачи в будущем. 
		IF NEW.`sb_start` > CURDATE() THEN 
			SET @msg = CONCAT('Date ', NEW.`sb_start`, ' for subscription ', NEW.`sb_id`, ' activation is in the future.'); 
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	-- Блокировка выдач книг с датой возврата в прошлом. 
		IF NEW.`sb_finish` < CURDATE() THEN 
			SET @msg = CONCAT('Date ', NEW.`sb_finish`, ' for subscription ', NEW.`sb_id`, ' deactivation is in the past.');
            SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1002; 
		END IF; 
	-- Блокировка выдач книг с датой возврата меньшей, чем дата выдачи. 
		IF NEW.`sb_finish` < NEW.`sb_start` THEN 
			SET @msg = CONCAT('Date ', NEW.`sb_finish`, ' for subscription ', NEW.`sb_id`, ' deactivation is less than the date for its activation (', NEW.`sb_start`, ').'); 
            SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1003; 
		END IF; 
	END; 
$$
CREATE TRIGGER `subscriptions_control_upd` 
AFTER UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
    -- Блокировка выдач книг с датой выдачи в будущем. 
		IF NEW.`sb_start` > CURDATE() THEN 
			SET @msg = CONCAT('Date ', NEW.`sb_start`, ' for subscription ', NEW.`sb_id`, ' activation is in the future.'); 
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	-- Блокировка выдач книг с датой возврата меньшей, чем дата выдачи. 
		IF NEW.`sb_finish` < NEW.`sb_start` THEN 
			SET @msg = CONCAT('Date ', NEW.`sb_finish`, ' for subscription ', NEW.`sb_id`, ' deactivation is less than the date for its activation (', NEW.`sb_start`, ').'); 
            SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1003; 
		END IF; 
	END; 
$$ 
DELIMITER ;
INSERT INTO `subscriptions` VALUES (500, 1, 1, '2020-01-12', '2020-02-12', 'N');
INSERT INTO `subscriptions` (`sb_id`, `sb_subscriber`, `sb_book`, `sb_start`, `sb_finish`, `sb_is_active`) VALUES (501, 3, 3, '2020-01-12', '2020-02-12', 'N');
INSERT INTO `subscriptions` VALUES (502, 1, 1, '2000-01-12', '2000-02-12', 'N');
INSERT INTO `subscriptions` VALUES (503, 1, 1, '2000-01-12', '2020-02-12', 'N');
UPDATE `subscriptions` SET `sb_start` = '2020-01-01' WHERE `sb_id` = 503;
UPDATE `subscriptions` SET `sb_start` = '2010-01-01', `sb_finish` = '2005-01-01' WHERE `sb_id` = 503;
UPDATE `subscriptions` SET `sb_start` = '2005-01-01', `sb_finish` = '2006-01-01' WHERE `sb_id` = 503;
UPDATE `subscriptions` SET `sb_start` = '2005-01-01', `sb_finish` = '2010-01-01' WHERE `sb_id` = 503
