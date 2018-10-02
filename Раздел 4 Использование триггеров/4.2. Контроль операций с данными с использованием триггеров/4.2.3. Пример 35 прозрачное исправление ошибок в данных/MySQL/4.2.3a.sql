-- Задача 4.2.3.a{344}: создать триггер, проверяющий наличие точки в конце имени читателя и добавляющий таковую при её отсутствии.
drop trigger if exists `sbsrs_name_lp_ins`;
drop trigger if exists `sbsrs_name_lp_upd`;
DELIMITER $$ 
CREATE TRIGGER `sbsrs_name_lp_ins` 
BEFORE INSERT ON `subscribers` 
FOR EACH ROW 
	BEGIN 
		IF (SUBSTRING(NEW.`s_name`, -1) <> '.') THEN 
			SET @new_value = CONCAT(NEW.`s_name`, '.'); 
            SET @msg = CONCAT('Value [', NEW.`s_name`, '] was automatically changed to [', @new_value ,']'); 
            SET NEW.`s_name` = @new_value; 
            SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1000; 
		END IF; 
	END; 
$$
CREATE TRIGGER `sbsrs_name_lp_upd` 
BEFORE UPDATE ON `subscribers` 
FOR EACH ROW 
	BEGIN 
		IF (SUBSTRING(NEW.`s_name`, -1) <> '.') THEN 
			SET @new_value = CONCAT(NEW.`s_name`, '.'); 
            SET @msg = CONCAT('Value [', NEW.`s_name`, '] was automatically changed to [', @new_value ,']'); 
            SET NEW.`s_name` = @new_value; 
            SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1000; 
		END IF; 
	END; 
$$ 
DELIMITER ;
INSERT INTO `subscribers` (`s_name`) VALUES ('Ковалев');
