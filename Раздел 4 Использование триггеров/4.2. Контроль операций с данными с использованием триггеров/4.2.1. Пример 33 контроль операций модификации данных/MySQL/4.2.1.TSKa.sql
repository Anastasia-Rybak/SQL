-- Задание 4.2.1.TSK.A: создать триггер, не позволяющий добавить в базу данных информацию о выдаче книги, если выполняется хотя бы одно из условий:
-- • дата выдачи или возврата приходится на воскресенье;
-- • читатель брал за последние полгода более 100 книг;
-- • промежуток времени между датами выдачи и возврата менее трёх дней.
drop trigger if exists `subscriptions_control_ins2`; 
drop trigger if exists `subscriptions_control_upd2`; 
DELIMITER $$ 
CREATE TRIGGER `subscriptions_control_ins2` 
AFTER INSERT ON `subscriptions` 
FOR EACH ROW 
	BEGIN  
		IF dayofweek(New.`sb_start`) = 0 or dayofweek(New.`sb_finish`) = 0 THEN 
			SET @msg = 'Error'; 
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF; 
		IF (select count(`sb_books`) from (SELECT count(`sb_book`) as `sb_books` from `subscriptions` where `sb_subscriber` = new.`sb_subscriber` and abs(datediff('2011-02-01', `sb_start`))<=180 group BY `sb_subscriber` having `sb_books` > 1) as `data`) <> 0 tHEN 
			SET @msg = 'Error'; 
            SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1002; 
		END IF;        
		IF abs(datediff(new.`sb_finish`, new.`sb_start`)) < 3 then
			SET @msg = 'Error'; 
            SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1003; 
		END IF; 
	END; 
$$
CREATE TRIGGER `subscriptions_control_upd2` 
AFTER UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		IF dayofweek(New.`sb_start`) = 0 or dayofweek(New.`sb_finish`) = 0 THEN 
			SET @msg = 'Error'; 
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1001; 
		END IF;
		IF (select count(`sb_books`) from (SELECT count(`sb_book`) as `sb_books` from `subscriptions` where `sb_subscriber` = 1 and abs(datediff('2011-02-01', `sb_start`))<=180 group BY `sb_subscriber` having `sb_books` > 1) as `data`) <> 0 tHEN 
			SET @msg = 'Error'; 
            SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1002; 
		END IF;
		IF abs(datediff(new.`sb_finish`, new.`sb_start`)) < 3 then
			SET @msg = 'Error'; 
            SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = @msg, MYSQL_ERRNO = 1003; 
		END IF; 
	END; 
$$ 
DELIMITER ;
insert into `subscriptions` values(600, 1, 1, '2018-09-30', '2018-10-30', 'Y');
insert into `subscriptions` values(600, 2, 2, '2018-09-28', '2018-09-29', 'Y');
insert into `subscriptions` values(600, 1, 1, '2018-09-25', '2018-10-12', 'Y');