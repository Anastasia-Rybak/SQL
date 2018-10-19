-- Задача 4.2.1.c{335}: создать триггер, не позволяющий изменять значение поля sb_is_active таблицы subscriptions со значения N на значе-ние Y.
drop trigger `sbs_cntrl_is_active`;
DELIMITER $$ 
CREATE TRIGGER `sbs_cntrl_is_active` 
BEFORE UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		IF ((OLD.`sb_is_active` = 'N') AND (NEW.`sb_is_active` = 'Y')) THEN 
			SET @msg = CONCAT('It is prohibited to activate previously deactivated subscriptions (rule violated for subscription with id ', NEW.`sb_id`, ').'); 
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	END; 
$$ 
DELIMITER ;
UPDATE `subscriptions` SET `sb_is_active` = 'Y' WHERE `sb_id` = 57;
