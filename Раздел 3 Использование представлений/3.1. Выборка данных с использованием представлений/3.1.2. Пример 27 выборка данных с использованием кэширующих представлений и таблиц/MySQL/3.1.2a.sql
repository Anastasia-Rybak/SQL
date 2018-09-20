-- Задача 3.1.2.a{216}: создать представление, ускоряющее получение ин-формации о количестве экземпляров книг: имеющихся в библиотеке, вы-данных на руки, оставшихся в библиотеке.
DROP TABLE IF EXISTS  `books_statistics`;
CREATE  TABLE `books_statistics` 
( 
	`total` INTEGER UNSIGNED NOT NULL, 
    `given` INTEGER UNSIGNED NOT NULL, 
    `rest` INTEGER UNSIGNED NOT NULL 
);
-- Очистка таблицы: 
TRUNCATE TABLE `books_statistics`; 
-- Инициализация данных: 
INSERT INTO `books_statistics` (`total`, `given`, `rest`) 
SELECT IFNULL(`total`, 0), 
		IFNULL(`given`, 0), 
        IFNULL(`total` - `given`, 0) AS `rest` 
        FROM (SELECT (SELECT SUM(`b_quantity`) 
						FROM `books`) AS `total`, 
					(SELECT COUNT(`b_id`) 
						FROM `subscriptions` 
                        WHERE `sb_is_active` = 'Y') AS `given`) AS `prepared_data`;
-- Удаление старых версий триггеров 
-- (удобно в процессе разработки и отладки): 
DROP TRIGGER IF EXISTS `upd_bks_sts_on_books_ins`; 
DROP TRIGGER IF EXISTS `upd_bks_sts_on_books_del`; 
DROP TRIGGER IF EXISTS `upd_bks_sts_on_books_upd`; 
-- Переключение разделителя завершения запроса, 
-- т.к. сейчас запросом будет создание триггера, 
-- внутри которого есть свои, классические запросы: 
DELIMITER $$ 
-- Создание триггера, реагирующего на добавление книг: 
CREATE TRIGGER `upd_bks_sts_on_books_ins` 
BEFORE INSERT ON `books` 
	FOR EACH ROW 
		BEGIN 
			UPDATE `books_statistics` SET `total` = `total` + NEW.`b_quantity`, `rest` = `total` - `given`; 
		END; 
$$
-- Создание триггера, реагирующего на удаление книг: 
CREATE TRIGGER `upd_bks_sts_on_books_del` 
BEFORE DELETE ON `books` 
	FOR EACH ROW 
		BEGIN 
			UPDATE `books_statistics` SET `total` = `total` - OLD.`b_quantity`, `given` = `given` - (SELECT COUNT(`b_id`) FROM `subscriptions` WHERE `b_id`= OLD.`b_id` AND `sb_is_active` = 'Y'), `rest` = `total` - `given`; 
		END; 
$$ 
-- Создание триггера, реагирующего на 
-- изменение количества книг: 
CREATE TRIGGER `upd_bks_sts_on_books_upd` 
BEFORE UPDATE ON `books` 
	FOR EACH ROW 
		BEGIN 
			UPDATE `books_statistics` SET `total` = `total` - OLD.`b_quantity` + NEW.`b_quantity`, `rest` = `total` - `given`; 
		END; 
$$ 
-- Восстановление разделителя завершения запросов: 
DELIMITER ;
-- Удаление старых версий триггеров 
-- (удобно в процессе разработки и отладки): 
DROP TRIGGER IF EXISTS `upd_bks_sts_on_subscriptions_ins`; 
DROP TRIGGER IF EXISTS `upd_bks_sts_on_subscriptions_del`; 
DROP TRIGGER IF EXISTS `upd_bks_sts_on_subscriptions_upd`; 
-- Переключение разделителя завершения запроса, 
-- т.к. сейчас запросом будет создание триггера, 
-- внутри которого есть свои, классические запросы: 
DELIMITER $$ 
-- Создание триггера, реагирующего на добавление выдачи книг: 
CREATE TRIGGER `upd_bks_sts_on_subscriptions_ins` 
BEFORE INSERT ON `subscriptions` 
	FOR EACH ROW 
		BEGIN 
			SET @delta = 0; 
            IF (NEW.`sb_is_active` = 'Y') THEN 
				SET @delta = 1; 
			END IF; 
            UPDATE `books_statistics` SET `rest` = `rest` - @delta, `given` = `given` + @delta; 
		END;
$$ 
-- Создание триггера, реагирующего на удаление выдачи книг: 
CREATE TRIGGER `upd_bks_sts_on_subscriptions_del` 
BEFORE DELETE ON `subscriptions` 
	FOR EACH ROW 
		BEGIN 
			SET @delta = 0; 
            IF (OLD.`sb_is_active` = 'Y') THEN 
				SET @delta = 1; 
			END IF; 
            UPDATE `books_statistics` SET `rest` = `rest` + @delta, `given` = `given` - @delta; 
        END; 
$$
-- Создание триггера, реагирующего на обновление выдачи книг: 
CREATE TRIGGER `upd_bks_sts_on_subscriptions_upd` 
BEFORE UPDATE ON `subscriptions` 
	FOR EACH ROW 
		BEGIN 
			SET @delta = 0; 
				IF ((NEW.`sb_is_active` = 'Y') AND (OLD.`sb_is_active` = 'N')) THEN 
					SET @delta = -1; 
				END IF; 
                IF ((NEW.`sb_is_active` = 'N') AND (OLD.`sb_is_active` = 'Y')) THEN 
					SET @delta = 1; 
				END IF; 
                UPDATE `books_statistics` SET `rest` = `rest` + @delta, `given` = `given` - @delta; 
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
