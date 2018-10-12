drop procedure if exists UPDATE_subscriptions_ready;
drop event if exists `update_subscriptions_ready_hourly`;
DELIMITER $$ 
CREATE PROCEDURE UPDATE_subscriptions_ready() 
BEGIN 
	IF (NOT EXISTS(SELECT * FROM `information_schema`.`tables` WHERE `table_schema` = DATABASE() AND `table_name` = 'subscriptions_ready')) THEN 
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'The `subscriptions_ready` table is missing.', MYSQL_ERRNO = 1001; 
	END IF;
	UPDATE `subscriptions_ready` 
		JOIN (SELECT `sb_id`, `s_name` AS `sb_subscriber`, `b_name` AS `sb_book`, `sb_start`, `sb_finish`, `sb_is_active` 
				FROM `books` JOIN `subscriptions` on b_id = sb_book JOIN `subscribers` on s_id = sb_subscriber) AS `src` 
	SET `subscriptions_ready`.`sb_id` = `src`.`sb_id`, 
		`subscriptions_ready`.`sb_subscriber` = `src`.`sb_subscriber`,
        `subscriptions_ready`.`sb_book` = `src`.`sb_book`, 
		`subscriptions_ready`.`sb_start` = `src`.`sb_start`,         
		`subscriptions_ready`.`sb_is_active` = `src`.`sb_start`, 
		`subscriptions_ready`.`sb_finish` = `src`.`sb_finish`; 
END; 
$$ 
DELIMITER ;
SET GLOBAL event_scheduler = ON; 
CREATE EVENT `update_subscriptions_ready_hourly` 
ON SCHEDULE 
EVERY 12 HOUR 
STARTS NOW()
ON COMPLETION PRESERVE 
DO 
CALL UPDATE_subscriptions_ready;
SELECT * FROM `information_schema`.`events`;