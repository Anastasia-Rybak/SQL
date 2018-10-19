-- Задание 5.1.2.TSK.A: переписать решения{315}, {338} задач 4.2.1.a{315} и 4.2.2.a{338} с использованием хранимых функций, созданных в реше-ниях{370}, {373} задач 5.1.2.a{370} и 5.1.2.b{370} соответственно.
drop trigger if exists `subscriptions_control_ins`; 
drop trigger if exists `subscriptions_control_upd`; 
DELIMITER $$ 
CREATE TRIGGER `subscriptions_control_ins` 
AFTER INSERT ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		declare result int;
		set result = CHECK_SUBSCRIPTION_DATES(new.`sb_start`, new.`sb_finish`, 1);
		IF result = -1 THEN 
			SET @msg = CONCAT('Date ', NEW.`sb_start`, ' for subscription ', NEW.`sb_id`, ' activation is in the future.'); 
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 		
		elseIF result = -2 THEN 
			SET @msg = CONCAT('Date ', NEW.`sb_finish`, ' for subscription ', NEW.`sb_id`, ' deactivation is in the past.');
            SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1002; 
		elseIF result = -3 THEN 
			SET @msg = CONCAT('Date ', NEW.`sb_finish`, ' for subscription ', NEW.`sb_id`, ' deactivation is less than the date for its activation (', NEW.`sb_start`, ').'); 
            SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1003; 
		END IF; 
	END; 
$$
CREATE TRIGGER `subscriptions_control_upd` 
AFTER UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		declare result int;
		set result = CHECK_SUBSCRIPTION_DATES(new.`sb_start`, new.`sb_finish`, 0);
		IF result = -1 THEN 
			SET @msg = CONCAT('Date ', NEW.`sb_start`, ' for subscription ', NEW.`sb_id`, ' activation is in the future.'); 
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 		
		elseIF result = -2 THEN 
			SET @msg = CONCAT('Date ', NEW.`sb_finish`, ' for subscription ', NEW.`sb_id`, ' deactivation is in the past.');
            SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1002; 
		elseIF result = -3 THEN 
			SET @msg = CONCAT('Date ', NEW.`sb_finish`, ' for subscription ', NEW.`sb_id`, ' deactivation is less than the date for its activation (', NEW.`sb_start`, ').'); 
            SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1003; 
		END IF; 
	END; 
$$ 
DELIMITER ;
drop trigger if exists `sbsrs_cntrl_name_ins`;
drop trigger if exists `sbsrs_cntrl_name_upd`;
DELIMITER $$ 
CREATE TRIGGER `sbsrs_cntrl_name_ins` 
BEFORE INSERT ON `subscribers` 
FOR EACH ROW 
	BEGIN 
		IF CHECK_SUBSCRIBER_NAME(new.`s_name`) = 0 THEN 
            SET @msg = CONCAT('Subscribers name should contain at least two words and one point, but the following name violates this rule: ', NEW.`s_name`); 
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	END; 
$$
CREATE TRIGGER `sbsrs_cntrl_name_upd` 
BEFORE UPDATE ON `subscribers` 
FOR EACH ROW 
	BEGIN 
		IF CHECK_SUBSCRIBER_NAME(new.`s_name`) = 0 THEN 
			SET @msg = CONCAT('Subscribers name should contain at least two words and one point, but the following name violates this rule: ', NEW.`s_name`); 
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	END; 
$$ 
DELIMITER ;
INSERT INTO `subscriptions` VALUES (500, 1, 1, '2020-01-12', '2020-02-12', 'N');
INSERT INTO `subscriptions` VALUES (501, 3, 3, '2020-01-12', '2020-02-12', 'N');
INSERT INTO `subscriptions` VALUES (502, 1, 1, '2000-01-12', '2000-02-12', 'N');
INSERT INTO `subscriptions` VALUES (503, 1, 1, '2000-01-12', '2020-02-12', 'N');
UPDATE `subscriptions` SET `sb_start` = '2020-01-01' WHERE `sb_id` = 503;
UPDATE `subscriptions` SET `sb_start` = '2010-01-01', `sb_finish` = '2005-01-01' WHERE `sb_id` = 503;
UPDATE `subscriptions` SET `sb_start` = '2005-01-01', `sb_finish` = '2006-01-01' WHERE `sb_id` = 503;
UPDATE `subscriptions` SET `sb_start` = '2005-01-01', `sb_finish` = '2010-01-01' WHERE `sb_id` = 503;
set SQL_SAFE_UPDATES = 0;
insert into subscribers (s_name) values('Иванов');
insert into subscribers (s_name) values('Иванов И');
insert into subscribers (s_name) values('Иванов И.');
insert into subscribers (s_name) values('Иванов И.И.');
insert into subscribers (s_name) values('Иванов И. И. ');
update subscribers set s_name = 'Ковалев' where s_name = 'Иванов И.И.';
set SQL_SAFE_UPDATES = 1;