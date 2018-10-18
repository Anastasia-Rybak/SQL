-- Задание 6.1.2.TSK.B: создать хранимую процедуру, которая: 
-- • увеличивает значение поля b_quantity для всех книг в два раза;
-- • отменяет совершённое действие, если по итогу выполнения операции среднее количество экземпляров книг превысит значение 50.
drop procedure if exists CHANGE_quantity;
DELIMITER $$ 
CREATE PROCEDURE CHANGE_quantity() 
BEGIN 
	SELECT 'Starting transaction...'; 
    START TRANSACTION; 
    UPDATE `books` 
    SET `b_quantity` = `b_quantity` * 2;
    SET @avg_read = (SELECT AVG(`b_quantity`) FROM `books`); 
    IF (@avg_read > 50) THEN 
		SELECT 'Rolling transaction back...'; 
		ROLLBACK; 
	ELSE 
		SELECT 'Committing transaction...'; 
        COMMIT; 
	END IF; 
END;
$$ 
DELIMITER ;
set sql_safe_updates = 0;
CALL CHANGE_quantity();
set sql_safe_updates = 1;