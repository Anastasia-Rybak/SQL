-- Задача 4.2.2.b{342}: создать триггер, допускающий регистрацию в библио-теке только книг, изданных не более ста лет назад.
drop trigger if exists `books_cntrl_year_ins`;
drop trigger if exists `books_cntrl_year_upd`;
DELIMITER $$ 
CREATE TRIGGER `books_cntrl_year_ins` 
BEFORE INSERT ON `books` 
FOR EACH ROW 
	BEGIN 
		IF ((YEAR(CURDATE()) - NEW.`b_year`) > 100) THEN 
			SET @msg = CONCAT('The following issuing year is more than 100 years in the past: ', NEW.`b_year`); 
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
	END; 
$$ 
CREATE TRIGGER `books_cntrl_year_upd` 
BEFORE UPDATE ON `books` 
FOR EACH ROW 
	BEGIN 
		IF ((YEAR(CURDATE()) - NEW.`b_year`) > 100) THEN 
			SET @msg = CONCAT('The following issuing year is more than 100 years in the past: ', NEW.`b_year`); 
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
        END IF; 
	END; 
$$ 
DELIMITER ;
insert into books (b_name, b_year, b_quantity) values ('kniga', 1900, 1);
update books set b_year = 1900 where b_id = 1;