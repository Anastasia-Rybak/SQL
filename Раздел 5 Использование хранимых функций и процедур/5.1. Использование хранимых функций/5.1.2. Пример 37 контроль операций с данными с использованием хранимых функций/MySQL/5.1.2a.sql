-- Задача 5.1.2.a{370}: создать хранимую функцию, автоматизирующую про-верку условий задачи 4.2.1.a{315}, т.е. возвращающую значение 1 (все условия выполнены) или -1, -2, -3 (если хотя бы одно условие нарушено, модуль числа соответствует номеру условия) в зависимости от того, вы-полняются ли следующие условия:
-- • дата выдачи книги не может находиться в будущем;
-- • дата возврата книги не может находиться в прошлом (только в случае вставки данных);
-- • дата возврата книги не может быть меньше даты выдачи книги.
drop function if exists CHECK_SUBSCRIPTION_DATES;
DELIMITER $$ 
CREATE FUNCTION CHECK_SUBSCRIPTION_DATES
(sb_start DATE, sb_finish DATE, is_insert INT) 
RETURNS INT DETERMINISTIC 
BEGIN 
	DECLARE result INT DEFAULT 1;
    -- Блокировка выдач книг с датой выдачи в будущем 
    IF (sb_start > CURDATE()) THEN 
		SET result = -1; 
	END IF; 
    -- Блокировка выдач книг с датой возврата в прошлом. 
    IF ((sb_finish < CURDATE()) AND (is_insert = 1)) THEN 
		SET result = -2; 
	END IF;
    -- Блокировка выдач книг с датой возврата меньшей, чем дата выдачи. 
    IF (sb_finish < sb_start) THEN 
		SET result = -3; 
	END IF; 
    RETURN result; 
END; 
$$ 
DELIMITER ;
SELECT CHECK_SUBSCRIPTION_DATES('2025-01-01', '2026-01-01', 1); 
SELECT CHECK_SUBSCRIPTION_DATES('2025-01-01', '2026-01-01', 0); 
SELECT CHECK_SUBSCRIPTION_DATES('2005-01-01', '2006-01-01', 1); 
SELECT CHECK_SUBSCRIPTION_DATES('2005-01-01', '2006-01-01', 0); 
SELECT CHECK_SUBSCRIPTION_DATES('2005-01-01', '2004-01-01', 1); 
SELECT CHECK_SUBSCRIPTION_DATES('2005-01-01', '2004-01-01', 0);