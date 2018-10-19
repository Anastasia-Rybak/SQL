-- Задание 5.1.1.TSK.D: создать хранимую функцию, актуализирующую данные в таблице subscriptions_ready (см. задачу 3.1.2.b{215}) и воз-вращающую число, показывающее изменение количества выдач книг.
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
-- Инициализация данных: 
INSERT INTO `subscriptions_ready` (`sb_id`, `sb_subscriber`, `sb_book`, `sb_start`, `sb_finish`, `sb_is_active`) 
SELECT `sb_id`, `s_name` AS `sb_subscriber`, `b_name` AS `sb_book`, `sb_start`, `sb_finish`, `sb_is_active` 
FROM `books` JOIN `subscriptions` on `b_id` = `sb_book` JOIN `subscribers` on `s_id` = `sb_subscriber`;
DROP FUNCTION IF EXISTS subscriptions_DELTA; 
DELIMITER $$ 
CREATE FUNCTION subscriptions_DELTA() 
RETURNS INT
BEGIN 
	DECLARE old_books_count INT DEFAULT 0; 
    DECLARE new_books_count INT DEFAULT 0; 
    SET old_books_count := (SELECT count(*) FROM `subscriptions_ready`); 
    UPDATE `subscriptions_ready` 
    JOIN (SELECT `sb_id`, `s_name` AS `sb_subscriber`, `b_name` AS `sb_book`, `sb_start`, `sb_finish`, `sb_is_active` 
			FROM `books` JOIN `subscriptions` on `b_id` = `sb_book` JOIN `subscribers` on `s_id` = `sb_subscriber`) AS `src` 
	SET `subscriptions_ready`.`sb_id` = `src`.`sb_id`, 
		`subscriptions_ready`.`sb_subscriber` = `src`.`sb_subscriber`, 
		`subscriptions_ready`.`sb_book` = `src`.`sb_book`, 
        `subscriptions_ready`.`sb_start` = `src`.`sb_start`, 
		`subscriptions_ready`.`sb_finish` = `src`.`sb_finish`, 
		`subscriptions_ready`.`sb_is_active` = `src`.`sb_is_active`;
    SET new_books_count := (SELECT count(*) FROM `subscriptions_ready`); 
    RETURN (new_books_count); 
END; 
$$ 
DELIMITER ;
insert into subscriptions values (500,1,1,'2017-07-07', '2017-08-08','Y');
SELECT subscriptions_DELTA();