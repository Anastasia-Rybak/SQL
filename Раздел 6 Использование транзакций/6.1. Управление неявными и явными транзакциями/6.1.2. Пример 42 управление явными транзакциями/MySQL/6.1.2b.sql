-- Задача 6.1.2.b{425}: создать хранимую процедуру, которая:
-- • изменяет все даты возврата книг на «плюс три месяца»;
-- • отменяет совершённое действие, если по итогу выполнения операции среднее время чтения книги превысит 4 месяца.
drop procedure if exists CHANGE_DATES;
DELIMITER $$ 
CREATE PROCEDURE CHANGE_DATES() 
BEGIN 
	SELECT 'Starting transaction...'; 
    START TRANSACTION; 
    UPDATE `subscriptions` 
    SET `sb_finish` = DATE_ADD(`sb_finish`, INTERVAL 3 MONTH); 
    SET @avg_read = (SELECT AVG(DATEDIFF(`sb_finish`, `sb_start`)) FROM `subscriptions`); 
    IF (@avg_read > 120) THEN 
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
CALL CHANGE_DATES();
set sql_safe_updates = 1;