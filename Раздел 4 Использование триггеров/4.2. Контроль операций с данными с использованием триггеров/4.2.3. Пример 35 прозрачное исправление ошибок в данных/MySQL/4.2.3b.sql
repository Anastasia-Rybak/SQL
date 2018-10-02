-- Задача 4.2.3.b{347}: создать триггер, меняющий дату возврата книги на «два месяца с момента выдачи», если дата возврата меньше даты вы-дачи или находится в прошлом.
drop trigger if exists `sbscs_date_tm_ins`;
drop trigger if exists `sbscs_date_tm_upd`;
DELIMITER $$ 
CREATE TRIGGER `sbscs_date_tm_ins` 
BEFORE INSERT ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		IF (NEW.`sb_finish` < NEW.`sb_start`) OR (NEW.`sb_finish` < CURDATE()) THEN 
			SET @new_value = DATE_ADD(CURDATE(), INTERVAL 2 MONTH); 
            SET @msg = CONCAT('Value [', date_format(NEW.`sb_finish`, '%Y-%m-%d'), '] was automatically changed to [', date_format(@new_value, '%Y-%m-%d'),']'); 
            SET NEW.`sb_finish` = @new_value; 
            SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1000; 
		END IF; 
	END; 
$$ 
CREATE TRIGGER `sbscs_date_tm_upd` 
BEFORE UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		IF (NEW.`sb_finish` < NEW.`sb_start`) OR (NEW.`sb_finish` < CURDATE()) THEN 
			SET @new_value = DATE_ADD(CURDATE(), INTERVAL 2 MONTH); 
            SET @msg = CONCAT('Value [', date_format(NEW.`sb_finish`, '%Y-%m-%d'), '] was automatically changed to [', date_format(@new_value, '%Y-%m-%d'),']');
            SET NEW.`sb_finish` = @new_value; 
            SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1000; 
		END IF; 
	END; 
$$ 
DELIMITER ;