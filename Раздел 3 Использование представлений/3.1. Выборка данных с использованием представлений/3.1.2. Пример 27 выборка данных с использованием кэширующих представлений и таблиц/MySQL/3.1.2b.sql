-- Задача 3.1.2.b{232}: создать представление, ускоряющее получение всей информации из таблицы subscriptions в человекочитаемом виде (где идентификаторы читателей и книг заменены на имена и названия).
DROP TABLE IF EXISTS `subscriptions_ready`;
CREATE TABLE `subscriptions_ready` 
( 
	`sb_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT, 
    `sb_subscriber` VARCHAR(150) NOT NULL, 
    `sb_book` VARCHAR(150) NOT NULL, 
    `sb_start` DATE NOT NULL, 
    `sb_finish` DATE NOT NULL, 
    `sb_is_active` ENUM ('Y', 'N') NOT NULL, 
	CONSTRAINT `PK_subscriptions` PRIMARY KEY (`sb_id`) 
);
-- Очистка таблицы: 
TRUNCATE TABLE `subscriptions_ready`; 
-- Инициализация данных: 
INSERT INTO `subscriptions_ready` (`sb_id`, `sb_subscriber`, `sb_book`, `sb_start`, `sb_finish`, `sb_is_active`) 
SELECT `sb_id`, `s_name` AS `sb_subscriber`, `b_name` AS `sb_book`, `sb_start`, `sb_finish`, `sb_is_active` 
FROM `books` JOIN `subscriptions` USING(`b_id`) JOIN `subscribers` USING(`s_id`);
-- Удаление старых версий триггеров 
-- (удобно в процессе разработки и отладки): 
DROP TRIGGER IF EXISTS `upd_sbs_rdy_on_books_del`; 
DROP TRIGGER IF EXISTS `upd_sbs_rdy_on_books_upd`;
-- Переключение разделителя завершения запроса, 
-- т.к. сейчас запросом будет создание триггера, 
-- внутри которого есть свои, классические запросы: 
DELIMITER $$ 
-- Создание триггера, реагирующего на удаление книг: 
CREATE TRIGGER `upd_sbs_rdy_on_books_del` 
AFTER DELETE ON `books` 
	FOR EACH ROW 
		BEGIN 
			DELETE FROM `subscriptions_ready`; 
            INSERT INTO `subscriptions_ready` (`sb_id`, `sb_subscriber`, `sb_book`, `sb_start`, `sb_finish`, `sb_is_active`) 
            SELECT `sb_id`, `s_name`, `b_name`, `sb_start`, `sb_finish`, `sb_is_active` FROM `books` JOIN `subscriptions` USING(`b_id`) JOIN `subscribers` USING(`s_id`); 
		END; 
$$
-- Создание триггера, реагирующего на 
-- изменение данных о книгах: 
CREATE TRIGGER `upd_sbs_rdy_on_books_upd` 
AFTER UPDATE ON `books` 
	FOR EACH ROW 
		BEGIN 
			IF (OLD.`b_name` != NEW.`b_name`) THEN 
				DELETE FROM `subscriptions_ready`; 
                INSERT INTO `subscriptions_ready` (`sb_id`, `sb_subscriber`, `sb_book`, `sb_start`, `sb_finish`, `sb_is_active`) 
                SELECT `sb_id`, `s_name`, `b_name`, `sb_start`, `sb_finish`, `sb_is_active` FROM `books` JOIN `subscriptions` USING(`b_id`) JOIN `subscribers` USING(`s_id`); 
			END IF; 
		END;
$$ 
-- Восстановление разделителя завершения запросов: 
DELIMITER ;
-- Удаление старых версий триггеров 
-- (удобно в процессе разработки и отладки): 
DROP TRIGGER IF EXISTS `upd_sbs_rdy_on_subscribers_del`; 
DROP TRIGGER IF EXISTS `upd_sbs_rdy_on_subscribers_upd`; 
-- Переключение разделителя завершения запроса, 
-- т.к. сейчас запросом будет создание триггера, 
-- внутри которого есть свои, классические запросы: 
DELIMITER $$
-- Создание триггера, реагирующего на удаление книг: 
CREATE TRIGGER `upd_sbs_rdy_on_subscribers_del` 
AFTER DELETE ON `subscribers` 
	FOR EACH ROW 
		BEGIN 
			DELETE FROM `subscriptions_ready`; 
			INSERT INTO `subscriptions_ready` (`sb_id`, `sb_subscriber`, `sb_book`, `sb_start`, `sb_finish`, `sb_is_active`) 
			SELECT `sb_id`, `s_name`, `b_name`, `sb_start`, `sb_finish`, `sb_is_active` FROM `books` JOIN `subscriptions` USING(`b_id`) JOIN `subscribers` USING(`s_id`); 
        END; 
$$ 
-- Создание триггера, реагирующего на 
-- изменение данных о книгах: 
CREATE TRIGGER `upd_sbs_rdy_on_subscribers_upd` 
AFTER UPDATE ON `subscribers` 
	FOR EACH ROW 
		BEGIN 
			IF (OLD.`s_name` != NEW.`s_name`) THEN 
				DELETE FROM `subscriptions_ready`; 
                INSERT INTO `subscriptions_ready` (`sb_id`, `sb_subscriber`, `sb_book`, `sb_start`, `sb_finish`, `sb_is_active`) 
                SELECT `sb_id`, `s_name`, `b_name`, `sb_start`, `sb_finish`, `sb_is_active` FROM `books` JOIN `subscriptions` USING(`b_id`) JOIN `subscribers` USING(`s_id`); 
			END IF; 
		END; 
$$ 
-- Восстановление разделителя завершения запросов: 
DELIMITER ;
DROP TRIGGER IF EXISTS `upd_sbs_rdy_on_subscriptions_ins`; 
DROP TRIGGER IF EXISTS `upd_sbs_rdy_on_subscriptions_del`; 
DROP TRIGGER IF EXISTS `upd_sbs_rdy_on_subscriptions_upd`; 
-- Переключение разделителя завершения запроса, 
-- т.к. сейчас запросом будет создание триггера, 
-- внутри которого есть свои, классические запросы: 
DELIMITER $$ 
CREATE TRIGGER `upd_sbs_rdy_on_subscriptions_ins` 
AFTER INSERT ON `subscriptions` 
	FOR EACH ROW 
		BEGIN 
			INSERT INTO `subscriptions_ready` (`sb_id`, `sb_subscriber`, `sb_book`, `sb_start`, `sb_finish`, `sb_is_active`) 
            SELECT `sb_id`, `s_name`, `b_name`, `sb_start`, `sb_finish`, `sb_is_active` 
            FROM `books` JOIN `subscriptions` USING(`b_id`) JOIN `subscribers` USING(`s_id`) 
            WHERE `s_id` = NEW.`s_id` AND `b_id` = NEW.`b_id`; 
		END; 
$$ 
-- Создание триггера, реагирующего на удаление выдачи книг: 
CREATE TRIGGER `upd_sbs_rdy_on_subscriptions_del` 
AFTER DELETE ON `subscriptions` 
	FOR EACH ROW 
		BEGIN 
			DELETE FROM `subscriptions_ready` WHERE `subscriptions_ready`.`sb_id` = OLD.`sb_id`; 
		END; 
$$
-- Создание триггера, реагирующего на обновление выдачи книг: 
CREATE TRIGGER `upd_sbs_rdy_on_subscriptions_upd` 
AFTER UPDATE ON `subscriptions` 
	FOR EACH ROW 
		BEGIN 
			UPDATE `subscriptions_ready` JOIN (SELECT `sb_id`, `s_name`, `b_name` FROM `books` JOIN `subscriptions` USING(`b_id`) JOIN `subscribers` USING(`s_id`) WHERE `s_id` = NEW.`s_id` AND `b_id` = NEW.`b_id` AND `sb_id` = NEW.`sb_id`) AS `new_data` SET `subscriptions_ready`.`sb_id` = NEW.`sb_id`, `subscriptions_ready`.`sb_subscriber` = `new_data`.`s_name`, `subscriptions_ready`.`sb_book` = `new_data`.`b_name`, `subscriptions_ready`.`sb_start` = NEW.`sb_start`, `subscriptions_ready`.`sb_finish` = NEW.`sb_finish`, `subscriptions_ready`.`sb_is_active` = NEW.`sb_is_active` WHERE `subscriptions_ready`.`sb_id` = OLD.`sb_id`; 
		END; 
$$ 
-- Восстановление разделителя завершения запросов: 
DELIMITER ;
SET SQL_SAFE_UPDATES = 0;
INSERT INTO `books` (`b_id`, `b_name`, `b_quantity`, `b_year`) VALUES (NULL, 'Новая книга 1', 5, 2001), (NULL, 'Новая книга 2', 10, 2002);
UPDATE `books` SET `b_quantity` = `b_quantity` + 5 WHERE `b_quantity` = 10;
DELETE FROM `books` WHERE `b_id` = 1;
UPDATE `subscriptions` SET `sb_is_active` = 'N' WHERE `sb_id` = 3;
UPDATE `subscriptions` SET `sb_is_active` = 'Y' WHERE `sb_id` = 3;
INSERT INTO `subscriptions` (`sb_id`, `s_id`, `b_id`, `sb_start`, `sb_finish`, `sb_is_active`) VALUES (101,2, 5, '2016-01-10', '2016-02-10', 'Y'), (102, 2, 6, '2016-01-10', '2016-02-10', 'Y');
DELETE FROM `subscriptions` WHERE `sb_id` = 42;
DELETE FROM `subscriptions` WHERE `sb_id` = 62;
DELETE FROM `books`;
SET SQL_SAFE_UPDATES = 1;