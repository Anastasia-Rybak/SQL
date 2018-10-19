-- Задача 4.1.1.a{272}: модифицировать схему базы данных «Библиотека» та-ким образом, чтобы таблица subscribers хранила актуальную инфор-мацию о дате последнего визита читателя в библиотеку.
DROP TRIGGER if exists `last_visit_on_subscriptions_ins`; 
DROP TRIGGER if exists `last_visit_on_subscriptions_upd`; 
DROP TRIGGER if exists `last_visit_on_subscriptions_del`; 
DELIMITER $$
CREATE TRIGGER `last_visit_on_subscriptions_ins` 
AFTER INSERT ON `subscriptions` 
	FOR EACH ROW 
		BEGIN 
			IF (SELECT IFNULL(`s_last_visit`, '1970-01-01') 
					FROM `subscribers` 
                    WHERE `subscribers`.`s_id` = NEW.`sb_subscriber`) < NEW.`sb_start` THEN 
                    UPDATE `subscribers` SET `s_last_visit` = NEW.`sb_start` WHERE `subscribers`.`s_id` =  NEW.`sb_subscriber`; 
			END IF; 
		END; 
$$ 
CREATE TRIGGER `last_visit_on_subscriptions_upd` 
AFTER UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		UPDATE `subscribers` LEFT JOIN (SELECT `sb_subscriber`, MAX(`sb_start`) AS `last_visit` FROM `subscriptions` GROUP BY `sb_subscriber`) AS `prepared_data` on `s_id` = `sb_subscriber` 
        SET `s_last_visit` = `last_visit` WHERE `subscribers`.`s_id` IN (OLD.`sb_subscriber`, NEW.`sb_subscriber`); 
	END; 
$$  
CREATE TRIGGER `last_visit_on_subscriptions_del` 
AFTER DELETE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		UPDATE `subscribers` LEFT JOIN (SELECT `sb_subscriber`, MAX(`sb_start`) AS `last_visit` FROM `subscriptions` GROUP BY `sb_subscriber`) AS `prepared_data` on `s_id` = `sb_subscriber` 
        SET `s_last_visit` = `last_visit` WHERE `subscribers`.`s_id` = OLD.`sb_subscriber`; 
END; 
$$ 
DELIMITER ;
set sql_safe_updates = 0;
INSERT INTO `subscriptions` VALUES (200, 2, 1, '2019-01-12', '2019-02-12', 'N');
UPDATE `subscriptions` SET `sb_subscriber` = 1 WHERE `sb_id` = 200;
INSERT INTO `subscriptions` VALUES (201, 2, 1, '2020-01-12', '2020-02-12', 'N');
UPDATE `subscriptions` SET `sb_start` = '2018-01-12' WHERE `sb_id` = 200;
DELETE FROM `subscriptions` WHERE `sb_id` = 200;
DELETE FROM `subscriptions` WHERE `sb_id` = 201;
set sql_safe_updates = 1;