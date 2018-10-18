-- Задача 6.1.2.a{419}: создать хранимую процедуру, которая:
-- • добавляет каждому читателю три случайных книги с датой выдачи, равной текущей дате, и датой возврата, равной «текущая дата плюс месяц»;
-- • отменяет совершённые действия, если по итогу выполнения операции хотя бы у одного читателя на руках окажется более десяти книг.
drop procedure if exists THREE_RANDOM_BOOKS;
DELIMITER $$ 
CREATE PROCEDURE THREE_RANDOM_BOOKS() 
BEGIN 
	SELECT 'Starting transaction...'; 
    START TRANSACTION; 
    USERS: BEGIN 
		DECLARE s_id_value INT DEFAULT 0; 
        DECLARE subscribers_done INT DEFAULT 0; 
		DECLARE subscribers_cursor CURSOR FOR SELECT `s_id` FROM `subscribers`; 
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET subscribers_done = 1; 
		OPEN subscribers_cursor; 
		read_users_loop: LOOP FETCH subscribers_cursor INTO s_id_value; 
			IF subscribers_done THEN 
				LEAVE read_users_loop; 
			END IF; 
			BOOKS: BEGIN 
				DECLARE b_id_value INT DEFAULT 0; 
				DECLARE books_done INT DEFAULT 0; 
				DECLARE books_cursor CURSOR FOR SELECT `b_id` FROM `books` ORDER BY RAND() LIMIT 3; 
				DECLARE CONTINUE HANDLER FOR NOT FOUND SET books_done = 1; 
				OPEN books_cursor; 
				read_books_loop: LOOP FETCH books_cursor INTO b_id_value; 
					IF books_done THEN 
						LEAVE read_books_loop; 
					END IF; 
					INSERT INTO `subscriptions` (`sb_subscriber`, `sb_book`, `sb_start`, `sb_finish`, `sb_is_active`) 
					VALUES (s_id_value, b_id_value, NOW(), NOW() + INTERVAL 1 MONTH, 'Y'); 
				END LOOP read_books_loop; 
				CLOSE books_cursor; 
			END BOOKS; 
		END LOOP read_users_loop; 
		CLOSE subscribers_cursor; 
	END USERS;
	IF EXISTS (SELECT 1 FROM `subscriptions` WHERE `sb_is_active`='Y' GROUP BY `sb_subscriber` HAVING COUNT(1)>10 LIMIT 1) THEN 
		SELECT 'Rolling transaction back...'; 
        ROLLBACK; 
	ELSE 
		SELECT 'Committing transaction...'; 
        COMMIT; 
	END IF; 
END; 
$$ 
DELIMITER ;
CALL THREE_RANDOM_BOOKS();
SELECT * FROM `subscriptions`;