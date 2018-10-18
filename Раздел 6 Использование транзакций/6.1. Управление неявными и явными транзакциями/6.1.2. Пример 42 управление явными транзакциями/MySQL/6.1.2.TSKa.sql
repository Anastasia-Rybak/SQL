-- Задание 6.1.2.TSK.A: создать хранимую процедуру, которая:
-- • добавляет каждой книге два случайных жанра;
-- • отменяет совершённые действия, если в процессе работы хотя бы одна операция вставки завершилась ошибкой в силу дублирования значения первичного ключа таблицы m2m_books_genres (т.е. у такой книги уже был такой жанр).
drop procedure if exists TWO_RANDOM_GENRES;
DELIMITER $$ 
CREATE PROCEDURE TWO_RANDOM_GENRES() 
BEGIN
	DECLARE has_error INT DEFAULT 0;
    DECLARE continue HANDLER FOR 1062 SET has_error = 1;
	SELECT 'Starting transaction...'; 
    START TRANSACTION; 
    Books: BEGIN 
		DECLARE b_id_value INT DEFAULT 0; 
        DECLARE books_done INT DEFAULT 0; 
		DECLARE books_cursor CURSOR FOR SELECT `b_id` FROM `books`; 
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET books_done = 1; 
		OPEN books_cursor; 
		read_books_loop: LOOP FETCH books_cursor INTO b_id_value; 
			IF books_done THEN 
				LEAVE read_books_loop; 
			END IF; 
			GENRES: BEGIN 
				DECLARE g_id_value INT DEFAULT 0; 
				DECLARE genres_done INT DEFAULT 0; 
				DECLARE genres_cursor CURSOR FOR SELECT `g_id` FROM `genres` ORDER BY RAND() LIMIT 2; 
				DECLARE CONTINUE HANDLER FOR NOT FOUND SET genres_done = 1; 
				OPEN genres_cursor; 
				read_genres_loop: LOOP FETCH genres_cursor INTO g_id_value; 
					IF genres_done THEN 
						LEAVE read_genres_loop; 
					END IF; 
					INSERT INTO `m2m_books_genres` (`b_id`, `g_id`) 
					VALUES (b_id_value, g_id_value); 
				END LOOP read_genres_loop; 
				CLOSE genres_cursor; 
			END GENRES; 
		END LOOP read_books_loop; 
		CLOSE books_cursor; 
	END Books;
    IF (has_error = 1) THEN 
		SELECT 'Rolling transaction back...'; 
        ROLLBACK; 
	ELSE 
		SELECT 'Committing transaction...'; 
        COMMIT; 
	END IF; 
END; 
$$ 
DELIMITER ;
CALL TWO_RANDOM_GENRES();
SELECT * FROM `m2m_books_genres`;