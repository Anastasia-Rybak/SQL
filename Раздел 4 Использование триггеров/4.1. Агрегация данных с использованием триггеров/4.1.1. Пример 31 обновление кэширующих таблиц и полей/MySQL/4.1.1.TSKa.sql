-- Задание 4.1.1.TSK.A: модифицировать схему базы данных «Библиотека» таким образом, чтобы таблица authors хранила актуальную информа-цию о дате последней выдачи книги автора читателю.
DROP TRIGGER if exists `last_issue_on_subscriptions_ins`; 
DROP TRIGGER if exists `last_issue_on_subscriptions_upd`; 
DROP TRIGGER if exists `last_issue_on_subscriptions_del`; 
DELIMITER $$
CREATE TRIGGER `last_issue_on_subscriptions_ins` 
AFTER INSERT ON `subscriptions` 
	FOR EACH ROW 
		BEGIN 
			IF (SELECT IFNULL(Max(`a_last_issue`), '1970-01-01') 
					FROM `authors` join `m2m_books_authors` using(`a_id`)
                    WHERE `m2m_books_authors`.`b_id` = NEW.`sb_book`) < NEW.`sb_start` THEN 
                    UPDATE `authors` join (select `a_id` from `authors`join `m2m_books_authors` using(`a_id`) WHERE `m2m_books_authors`.`b_id` = NEW.`sb_book`) as `data` using(`a_id`) SET `a_last_issue` = NEW.`sb_start` WHERE `authors`.`a_id` in  (`data`.`a_id`);
				end if;
		END; 
$$ 
CREATE TRIGGER `last_issue_on_subscriptions_upd` 
AFTER UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN
		UPDATE `authors` join (select `a_id` from `authors`join `m2m_books_authors` using(`a_id`) WHERE `m2m_books_authors`.`b_id` in(OLD.`sb_book`, NEW.`sb_book`)) as `data` using(`a_id`) 
        SET `a_last_issue` = NEW.`sb_start` WHERE `authors`.`a_id` in  (`data`.`a_id`);
	END; 
$$  
CREATE TRIGGER `last_issue_on_subscriptions_del` 
AFTER DELETE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		UPDATE `authors` join (select `a_id` from `authors`join `m2m_books_authors` using(`a_id`) WHERE `m2m_books_authors`.`b_id` = OLD.`sb_book`) as `data` using(`a_id`) 
        SET `a_last_issue` = (Select MAX(`sb_start`) from `subscriptions` where `sb_book` = OLD.`sb_book`) WHERE `authors`.`a_id` in  (`data`.`a_id`);			
END; 
$$ 
DELIMITER ;
set sql_safe_updates = 0;
INSERT INTO `subscriptions` VALUES (200, 2, 6, '2019-01-12', '2019-02-12', 'N');
UPDATE `subscriptions` SET `sb_book` = 7 WHERE `sb_id` = 200;
DELETE FROM `subscriptions` WHERE `sb_id` = 200;
set sql_safe_updates = 1;