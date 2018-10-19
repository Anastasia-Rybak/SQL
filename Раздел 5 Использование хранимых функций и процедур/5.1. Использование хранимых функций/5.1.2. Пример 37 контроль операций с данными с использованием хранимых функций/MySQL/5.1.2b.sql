-- Задача 5.1.2.b{373}: создать хранимую функцию, автоматизирующую про-верку условий задачи 4.2.2.a{338}, т.е. возвращающую 1, если имя читателя содержит хотя бы два слова и одну точку, и 0, если это условие нарушено.
DROP FUNCTION IF EXISTS CHECK_SUBSCRIBER_NAME; 
DELIMITER $$ 
CREATE FUNCTION CHECK_SUBSCRIBER_NAME
(subscriber_name VARCHAR(150)) 
RETURNS INT DETERMINISTIC 
BEGIN 
	IF ((CAST(subscriber_name AS CHAR CHARACTER SET cp1251) REGEXP CAST('^[a-zA-Zа-яА-ЯёЁ]+[\ ]{1}([a-zA-Zа-яА-ЯёЁ]{1,2}[.]{1}){1,}$' AS CHAR CHARACTER SET cp1251)) = 0) THEN 
		RETURN 0; 
	ELSE 
		RETURN 1; 
	END IF; 
END; 
$$ 
DELIMITER ;
SELECT CHECK_SUBSCRIBER_NAME('Иванов'), 
		CHECK_SUBSCRIBER_NAME('Иванов И'), 
        CHECK_SUBSCRIBER_NAME('Иванов И.'), 
        CHECK_SUBSCRIBER_NAME('Иванов И. И.'), 
        CHECK_SUBSCRIBER_NAME('Иванов И.И.'),
        CHECK_SUBSCRIBER_NAME('Иванов И.И. ');