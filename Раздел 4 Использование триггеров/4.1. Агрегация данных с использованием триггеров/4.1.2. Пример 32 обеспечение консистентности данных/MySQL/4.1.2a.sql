-- Задача 4.1.2.a{292}: модифицировать схему базы данных «Библиотека» та-ким образом, чтобы таблица subscribers хранила информацию о том, сколько в настоящий момент книг выдано каждому из читателей.
-- Задание 4.1.2.TSK.A: доработать триггеры из решений{292}, {305} задач 4.1.2.a{292} и 4.1.2.b{292} таким образом, чтобы ни при каких манипуляциях с данными значения полей s_books (в таблице subscribers) и g_books (в таблице genres) не могли оказаться отрицательными.
drop TRIGGER if exists `s_has_books_on_subscriptions_ins`;
drop TRIGGER if exists `s_has_books_on_subscriptions_del`;
drop TRIGGER if exists `s_has_books_on_subscriptions_upd`;
drop TRIGGER if exists `s_has_books_on_books_del`;
DELIMITER $$ 
-- Реакция на добавление выдачи книги: 
CREATE TRIGGER `s_has_books_on_subscriptions_ins` 
AFTER INSERT ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		IF (NEW.`sb_is_active` = 'Y') THEN 
			UPDATE `subscribers` 
            SET `s_books` = `s_books` + 1 
            WHERE `s_id` = NEW.`sb_subscriber`; 
		END IF; 
	END; 
$$ 
-- Реакция на удаление выдачи книги: 
CREATE TRIGGER `s_has_books_on_subscriptions_del` 
AFTER DELETE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		IF (OLD.`sb_is_active` = 'Y') THEN 
			UPDATE `subscribers` 
            SET `s_books` = if(`s_books` <= 1, 0,`s_books` - 1)
            WHERE `s_id` = OLD.`sb_subscriber`; 
		END IF; 
	END; 
$$
-- Реакция на обновление выдачи книги: 
CREATE TRIGGER `s_has_books_on_subscriptions_upd` 
AFTER UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
    -- A) Читатель тот же, Y -> N 
		IF ((OLD.`sb_subscriber` = NEW.`sb_subscriber`) AND 
			(OLD.`sb_is_active` = 'Y') AND 
            (NEW.`sb_is_active` = 'N')) THEN 
			UPDATE `subscribers` 
            SET `s_books` = if(`s_books` <= 1, 0,`s_books` - 1)
            WHERE `s_id` = OLD.`sb_subscriber`; 
		END IF; 
	-- B) Читатель тот же, N -> Y 
		IF ((OLD.`sb_subscriber` = NEW.`sb_subscriber`) AND 
			(OLD.`sb_is_active` = 'N') AND 
            (NEW.`sb_is_active` = 'Y')) THEN 
            UPDATE `subscribers` 
            SET `s_books` = `s_books` + 1 
            WHERE `s_id` = OLD.`sb_subscriber`; 
		END IF; 
	-- C) Читатели разные, Y -> Y 
		IF ((OLD.`sb_subscriber` != NEW.`sb_subscriber`) AND 
			(OLD.`sb_is_active` = 'Y') AND 
			(NEW.`sb_is_active` = 'Y')) THEN 
			UPDATE `subscribers` 
			SET `s_books` = if(`s_books` <= 1, 0,`s_books` - 1)
			WHERE `s_id` = OLD.`sb_subscriber`; 
			UPDATE `subscribers` 
			SET `s_books` = `s_books` + 1 
			WHERE `s_id` = NEW.`sb_subscriber`; 
		END IF; 
    -- D) Читатели разные, Y -> N 
		IF ((OLD.`sb_subscriber` != NEW.`sb_subscriber`) AND 
			(OLD.`sb_is_active` = 'Y') AND 
            (NEW.`sb_is_active` = 'N')) THEN 
            UPDATE `subscribers` 
            SET `s_books` = if(`s_books` <= 1, 0,`s_books` - 1)
            WHERE `s_id` = OLD.`sb_subscriber`; 
		END IF; 
	-- E) Читатели разные, N -> Y 
		IF ((OLD.`sb_subscriber` != NEW.`sb_subscriber`) AND 
			(OLD.`sb_is_active` = 'N') AND 
            (NEW.`sb_is_active` = 'Y')) THEN 
            UPDATE `subscribers` 
            SET `s_books` = `s_books` + 1 
            WHERE `s_id` = NEW.`sb_subscriber`; 
		END IF; 
	END;
$$ 
-- Реакция на удаление книги: 
CREATE TRIGGER `s_has_books_on_books_del` 
BEFORE DELETE ON `books` 
FOR EACH ROW 
	BEGIN 
		UPDATE `subscribers` 
        JOIN (SELECT `sb_subscriber`, COUNT(`sb_book`) AS `delta` FROM `subscriptions` WHERE `sb_book` = OLD.`b_id` AND `sb_is_active` = 'Y' GROUP BY `sb_subscriber`) AS `prepared_data` ON `s_id` = `sb_subscriber` 
        SET `s_books` = if((`s_books` - `delta`) <= 0, 0, `s_books` - `delta`); 
	END; 
$$
DELIMITER ;
set SQL_SAFE_UPDATES = 0;
INSERT INTO `subscriptions` VALUES (200, 1, 1, '2011-01-12', '2011-02-12', 'Y'), (201, 2, 1, '2011-01-12', '2011-02-12', 'N');
DELETE FROM `subscriptions` WHERE `sb_id` IN ( 200, 201 );
INSERT INTO `subscriptions` VALUES (300, 1, 1, '2011-01-12', '2011-02-12', 'Y');
-- A 
UPDATE `subscriptions` SET `sb_is_active` = 'N' WHERE `sb_id` = 300;
-- B 
UPDATE `subscriptions` SET `sb_is_active` = 'Y' WHERE `sb_id` = 300;
-- C 
UPDATE `subscriptions` SET `sb_subscriber` = 2 WHERE `sb_id` = 300;
-- D 
UPDATE `subscriptions` SET `sb_subscriber` = 1, `sb_is_active` = 'N' WHERE `sb_id` = 300;
-- E 
UPDATE `subscriptions` SET `sb_subscriber` = 2, `sb_is_active` = 'Y' WHERE `sb_id` = 300;
DELETE FROM `books` WHERE `b_id` = 1;
set SQL_SAFE_UPDATES = 1;