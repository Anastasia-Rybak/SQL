-- Задание 4.2.3.TSK.D: создать триггер, меняющий дату выдачи книги на текущую, если указанная в SQL-запросе дата выдачи книги меньше теку-щей на полгода и более.
drop trigger if exists `sbscs_date_tm_ins2`;
drop trigger if exists `sbscs_date_tm_upd2`;
DELIMITER $$ 
CREATE TRIGGER `sbscs_date_tm_ins2` 
BEFORE INSERT ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		IF (datediff(curdate(), new.`sb_start`)>=180) THEN 
            SET @msg = CONCAT('Value [', date_format(NEW.`sb_start`, '%Y-%m-%d'), '] was automatically changed to [', date_format(curdate(), '%Y-%m-%d'),']'); 
            SET NEW.`sb_start` = curdate(); 
            SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1000; 
		END IF; 
	END; 
$$ 
CREATE TRIGGER `sbscs_date_tm_upd2` 
BEFORE UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		IF (datediff(curdate(), new.`sb_start`)>=180) THEN 
            SET @msg = CONCAT('Value [', date_format(NEW.`sb_start`, '%Y-%m-%d'), '] was automatically changed to [', date_format(curdate(), '%Y-%m-%d'),']'); 
            SET NEW.`sb_start` = curdate(); 
            SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1000; 
		END IF;
	END; 
$$ 
DELIMITER ;
insert into subscriptions values(300,1,1,'2017-10-02','2017-10-30','Y');