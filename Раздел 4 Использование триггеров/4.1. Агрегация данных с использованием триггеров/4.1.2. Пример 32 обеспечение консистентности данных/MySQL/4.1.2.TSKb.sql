-- Задание 4.1.2.TSK.B: модифицировать схему базы данных «Библиотека» таким образом, чтобы таблица subscribers хранила информацию о том, сколько раз читатель брал в библиотеке книги (этот счётчик должен инкрементироваться каждый раз, когда читателю выдаётся книга; умень-шение значения этого счётчика не предусмотрено).
drop TRIGGER if exists `TSK412B_ins`;
drop TRIGGER if exists `TSK412B_del`;
drop TRIGGER if exists `TSK412B_upd`;
drop TRIGGER if exists `TSK412B_del2`;
DELIMITER $$ 
-- Реакция на добавление выдачи книги: 
CREATE TRIGGER `TSK412B_ins` 
AFTER INSERT ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		UPDATE `subscribers` 
        SET `s_count_books` = `s_count_books` + 1 
        WHERE `s_id` = NEW.`sb_subscriber`; 
	END; 
$$ 
-- Реакция на удаление выдачи книги: 
CREATE TRIGGER `TSK412B_del` 
AFTER DELETE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		UPDATE `subscribers` 
        SET `s_count_books` = if(`s_count_books` <= 1, 0,`s_count_books` - 1)
        WHERE `s_id` = OLD.`sb_subscriber`;
	END; 
$$
-- Реакция на обновление выдачи книги: 
CREATE TRIGGER `TSK412B_upd` 
AFTER UPDATE ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		IF (OLD.`sb_subscriber` != NEW.`sb_subscriber`) THEN 
			UPDATE `subscribers` 
			SET `s_count_books` = if(`s_count_books` <= 1, 0,`s_count_books` - 1)
			WHERE `s_id` = OLD.`sb_subscriber`; 
			UPDATE `subscribers` 
			SET `s_count_books` = `s_count_books` + 1 
			WHERE `s_id` = NEW.`sb_subscriber`; 
		END IF; 
	END;
$$ 
-- Реакция на удаление книги: 
CREATE TRIGGER `TSK412B_del2` 
BEFORE DELETE ON `books` 
FOR EACH ROW 
	BEGIN 
		UPDATE `subscribers` 
        JOIN (SELECT `sb_subscriber`, COUNT(`sb_book`) AS `delta` FROM `subscriptions` WHERE `sb_book` = OLD.`b_id` GROUP BY `sb_subscriber`) AS `prepared_data` ON `s_id` = `sb_subscriber` 
        SET `s_count_books` = if((`s_count_books` - `delta`) <= 0, 0, `s_count_books` - `delta`); 
	END; 
$$
DELIMITER ;
set SQL_SAFE_UPDATES = 0;
INSERT INTO `subscriptions` VALUES (200, 1, 1, '2011-01-12', '2011-02-12', 'Y'), (201, 2, 1, '2011-01-12', '2011-02-12', 'N');
DELETE FROM `subscriptions` WHERE `sb_id` IN ( 200, 201 );
INSERT INTO `subscriptions` VALUES (300, 1, 1, '2011-01-12', '2011-02-12', 'Y');
UPDATE `subscriptions` SET `sb_subscriber` = 2 WHERE `sb_id` = 300;
DELETE FROM `books` WHERE `b_id` = 1;
set SQL_SAFE_UPDATES = 1;