-- Задача 4.1.2.b{305}: модифицировать схему базы данных «Библиотека» та-ким образом, чтобы таблица genres хранила информацию о том, сколько в настоящий момент книг относится к каждому жанру.
-- Задание 4.1.2.TSK.A: доработать триггеры из решений{292}, {305} задач 4.1.2.a{292} и 4.1.2.b{292} таким образом, чтобы ни при каких манипуляциях с данными значения полей s_books (в таблице subscribers) и g_books (в таблице genres) не могли оказаться отрицательными.
drop TRIGGER if exists `g_has_books_on_m2m_b_g_ins`;
drop TRIGGER if exists `g_has_books_on_m2m_b_g_upd`;
drop TRIGGER if exists `g_has_books_on_m2m_b_g_del`;
drop TRIGGER if exists `g_has_books_on_books_del`;
DELIMITER $$ 
-- Реакция на добавление связи между книгами и жанрами: 
CREATE TRIGGER `g_has_books_on_m2m_b_g_ins` 
AFTER INSERT ON `m2m_books_genres` 
FOR EACH ROW 
	BEGIN 
		UPDATE `genres` 
        SET `g_books` = `g_books` + 1 
        WHERE `g_id` = NEW.`g_id`; 
	END; 
$$ 
-- Реакция на обновление связи между книгами и жанрами: 
CREATE TRIGGER `g_has_books_on_m2m_b_g_upd` 
AFTER UPDATE ON `m2m_books_genres` 
FOR EACH ROW 
	BEGIN 
		UPDATE `genres` 
        SET `g_books` = if(`g_books` <= 1, 0,`g_books` - 1)
        WHERE `g_id` = OLD.`g_id`; 
        UPDATE `genres` 
        SET `g_books` = `g_books` + 1 
        WHERE `g_id` = NEW.`g_id`; 
	END; 
$$
-- Реакция на удаление связи между книгами и жанрами: 
CREATE TRIGGER `g_has_books_on_m2m_b_g_del` 
AFTER DELETE ON `m2m_books_genres` 
FOR EACH ROW 
	BEGIN 
		UPDATE `genres` 
        SET `g_books` = if(`g_books` <= 1, 0,`g_books` - 1)
        WHERE `g_id` = OLD.`g_id`; 
	END; 
$$
-- Реакция на удаление книги: 
CREATE TRIGGER `g_has_books_on_books_del` 
BEFORE DELETE ON `books` 
FOR EACH ROW 
	BEGIN 
		UPDATE `genres` 
        SET `g_books` = if(`g_books` <= 1, 0,`g_books` - 1)
        WHERE `g_id` IN (SELECT `g_id` FROM `m2m_books_genres` WHERE `b_id` = OLD.`b_id`); 
	END; 
$$ 
DELIMITER ;
set SQL_SAFE_UPDATES = 0;
INSERT INTO `m2m_books_genres` (`b_id`, `g_id`) VALUES (1, 4), (2, 4);
UPDATE `m2m_books_genres` SET `b_id` = 3 WHERE `b_id` = 1 AND `g_id` = 4; 
UPDATE `m2m_books_genres` SET `b_id` = 4 WHERE `b_id` = 2 AND `g_id` = 4;
UPDATE `m2m_books_genres` SET `g_id` = 5 WHERE `b_id` = 3 AND `g_id` = 4; 
UPDATE `m2m_books_genres` SET `g_id` = 5 WHERE `b_id` = 4 AND `g_id` = 4;
UPDATE `m2m_books_genres` SET `b_id` = 1, `g_id` = 4 WHERE `b_id` = 3 AND `g_id` = 5; 
UPDATE `m2m_books_genres` SET `b_id` = 2, `g_id` = 4 WHERE `b_id` = 4 AND `g_id` = 5;
DELETE FROM `m2m_books_genres` WHERE `b_id` = 1 AND `g_id` = 4; 
DELETE FROM `m2m_books_genres` WHERE `b_id` = 2 AND `g_id` = 4;
DELETE FROM `books` WHERE `b_id` IN (1, 2);
set SQL_SAFE_UPDATES = 1;