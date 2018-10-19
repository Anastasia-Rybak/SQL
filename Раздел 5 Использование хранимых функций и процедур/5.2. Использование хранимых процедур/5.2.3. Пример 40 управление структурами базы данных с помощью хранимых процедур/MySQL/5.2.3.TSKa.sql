-- Задание 5.2.3.TSK.A: создать хранимую процедуру, автоматически со-здающую и наполняющую данными таблицу arrears, в которой должны быть представлены идентификаторы и имена читателей, у которых до сих пор находится на руках хотя бы одна книга, по которой дата возврата установлена в прошлом относительно текущей даты. Эта таблица должна быть связана с таблицей subscriptions связью «один к од-ному».
drop procedure if exists CREATE_arrears;
DELIMITER $$ 
CREATE PROCEDURE CREATE_arrears() 
BEGIN 
	IF NOT EXISTS (SELECT `table_name` FROM `information_schema`.`tables` WHERE `table_schema` = DATABASE() AND `table_type` = 'BASE TABLE' AND `table_name` = 'arrears') THEN 
		CREATE TABLE `arrears` 
        (
			`id` INTEGER UNSIGNED NOT NULL, 
            `name` varchar(150) NOT NULL
		); 
		INSERT INTO `arrears` (`id`, `name`)       
		SELECT `s_id`, `s_name` 
        from `subscribers` 
        where `s_id` in (SELECT distinct `sb_subscriber` from `subscriptions` where `sb_finish` < curdate() and `sb_is_active` = 'Y'); 
	ELSE 
		UPDATE `arrears` 
        JOIN (SELECT `s_id`, `s_name` 
				from `subscribers` 
					where `s_id` in (SELECT distinct `sb_subscriber` from `subscriptions` where `sb_finish` < curdate() and `sb_is_active` = 'Y')) as `data`
		SET `arrears`.`id` = `data`.`s_id`, 
			`arrears`.`name` = `data`.`s_name`; 
	END IF; 
END;
$$ 
DELIMITER ;
DROP TABLE if exists `arrears`; 
CALL CREATE_arrears; 
SELECT * FROM `arrears`;