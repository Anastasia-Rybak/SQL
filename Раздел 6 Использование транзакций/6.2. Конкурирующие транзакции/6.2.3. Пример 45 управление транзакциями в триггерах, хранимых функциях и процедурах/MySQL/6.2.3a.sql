-- Задача 6.2.3.a{465}: создать на таблице books триггер, определяющий уро-вень изолированности транзакции, в котором сейчас проходит операция вставки, и отменяющий операцию, если уровень изолированности тран-закции отличен от SERIALIZABLE.
drop TRIGGER if exists `books_ins_trans`;
DELIMITER $$ 
CREATE TRIGGER `books_ins_trans` 
AFTER INSERT ON `books` 
FOR EACH ROW 
	BEGIN 
		DECLARE isolation_level VARCHAR(50); 
        SET isolation_level = ( SELECT `VARIABLE_VALUE` FROM `information_schema`. `session_variables` WHERE `VARIABLE_NAME` = 'tx_isolation' ); 
        IF (isolation_level != 'SERIALIZABLE') THEN 
			SIGNAL SQLSTATE '45001' 
            SET MESSAGE_TEXT = 'Please, switch your transaction to SERIALIZABLE isolation level and rerun this INSERT again.', 
            MYSQL_ERRNO = 1001; 
		END IF; 
	END; 
$$ 
DELIMITER ;
SET GLOBAL show_compatibility_56 = ON;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; 
INSERT INTO `books` (`b_name`, `b_year`, `b_quantity`) 
VALUES ('И ещё одна книга', 1985, 2); 
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE; 
INSERT INTO `books` (`b_name`, `b_year`, `b_quantity`) 
VALUES ('И ещё одна книга', 1985, 2);
SET GLOBAL show_compatibility_56 = OFF;