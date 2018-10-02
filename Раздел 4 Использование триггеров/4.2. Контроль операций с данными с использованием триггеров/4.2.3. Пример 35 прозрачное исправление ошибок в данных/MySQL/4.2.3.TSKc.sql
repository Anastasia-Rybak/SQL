-- Задание 4.2.3.TSK.C: создать триггер, корректирующий название книги таким образом, чтобы оно удовлетворяло следующим условиям:
-- • не допускается наличие пробелов в начале и конце названия;
-- • не допускается наличие повторяющихся пробелов;
-- • первая буква в названии всегда должна быть заглавной.
drop trigger if exists `books_name_control_ins`;
drop trigger if exists `books_name_control_upd`;
DELIMITER $$ 
CREATE TRIGGER `books_name_control_ins` 
BEFORE INSERT ON `books` 
FOR EACH ROW 
	BEGIN 
		SET @new_value = trim(NEW.`b_name`);
        SET @new_value = CONCAT(UPPER(LEFT(@new_value, 1)), SUBSTRING(@new_value, 2));
        SET @new_value = replace(@new_value,'  ', ' ');
        SET @msg = CONCAT('Value [', NEW.`b_name`, '] was automatically changed to [', @new_value ,']'); 
        SET NEW.`b_name` = @new_value; 
        SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1000; 
	END; 
$$
CREATE TRIGGER `books_name_control_upd` 
BEFORE UPDATE ON `books` 
FOR EACH ROW 
	BEGIN 
		SET @new_value = trim(NEW.`b_name`);
        SET @new_value = CONCAT(UPPER(LEFT(@new_value, 1)), SUBSTRING(@new_value, 2));
        SET @new_value = replace(@new_value,'  ', ' ');
        SET @msg = CONCAT('Value [', NEW.`b_name`, '] was automatically changed to [', @new_value ,']'); 
        SET NEW.`b_name` = @new_value; 
        SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1000; 
	END; 
$$ 
DELIMITER ;
INSERT INTO `books` (`b_name`) VALUES ('');