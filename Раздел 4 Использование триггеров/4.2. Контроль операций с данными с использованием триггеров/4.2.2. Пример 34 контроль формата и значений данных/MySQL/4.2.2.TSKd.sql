-- Задание 4.2.2.TSK.D: создать триггер, допускающий регистрацию в биб-лиотеке только таких автором, имя которых не содержит никаких симво-лов кроме букв, цифр, знаков - (минус), ' (апостроф) и пробелов (не до-пускается два и более идущих подряд пробела).
drop trigger if exists `authors_cntrl_name_ins`;
drop trigger if exists `authors_cntrl_name_upd`;
DELIMITER $$ 
CREATE TRIGGER `authors_cntrl_name_ins` 
BEFORE INSERT ON `authors` 
FOR EACH ROW 
	BEGIN 
		IF ((CAST(NEW.`a_name` AS CHAR CHARACTER SET cp1251) REGEXP CAST('^[0-9a-zA-Zа-яА-ЯёЁ]+([-\'\ ]{1}[0-9a-zA-Zа-яА-ЯёЁ]+)*$' AS CHAR CHARACTER SET cp1251)) = 0) THEN 
            SET @msg = CONCAT('Author\'s name \'', NEW.`a_name`, '\' is not valid.'); 
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	END; 
$$
CREATE TRIGGER `authors_cntrl_name_upd` 
BEFORE UPDATE ON `authors` 
FOR EACH ROW 
	BEGIN 
		IF ((CAST(NEW.`a_name` AS CHAR CHARACTER SET cp1251) REGEXP CAST('^[0-9a-zA-Zа-яА-ЯёЁ]+([-\'\ ]+[0-9a-zA-Zа-яА-ЯёЁ]+){0,}$' AS CHAR CHARACTER SET cp1251)) = 0) THEN 
			SET @msg = CONCAT('Author\'s name \'', NEW.`a_name`, '\' is not valid.');  
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	END; 
$$ 
DELIMITER ;
set SQL_SAFE_UPDATES = 0;
insert into authors (a_name) values('Ковалев V ');
set SQL_SAFE_UPDATES = 1;