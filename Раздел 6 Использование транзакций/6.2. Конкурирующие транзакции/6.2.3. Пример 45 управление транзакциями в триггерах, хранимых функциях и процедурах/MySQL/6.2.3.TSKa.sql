-- Задание 6.2.3.TSK.A: создать на таблице subscriptions триггер, опре-деляющий уровень изолированности транзакции, в котором сейчас про-ходит операция обновления, и отменяющий операцию, если уровень изо-лированности транзакции отличен от REPEATABLE READ.
drop TRIGGER if exists `subscriptions_upd_trans`;
DELIMITER $$ 
CREATE TRIGGER `subscriptions_upd_trans` 
AFTER update ON `subscriptions` 
FOR EACH ROW 
	BEGIN 
		DECLARE isolation_level VARCHAR(50); 
        SET isolation_level = ( SELECT `VARIABLE_VALUE` FROM `information_schema`. `session_variables` WHERE `VARIABLE_NAME` = 'tx_isolation' ); 
        IF (isolation_level != 'REPEATABLE-READ') THEN 
			SIGNAL SQLSTATE '45001' 
            SET MESSAGE_TEXT = 'Please, switch your transaction to REPEATABLE READ isolation level and rerun this UPDATE again.', 
            MYSQL_ERRNO = 1001; 
		END IF; 
	END; 
$$ 
DELIMITER ;
SET GLOBAL show_compatibility_56 = ON;
set SQL_SAFE_UPDATES = 0;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; 
update `subscriptions` set `sb_is_active` = 'N' where `sb_id` = 2; 
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
update `subscriptions` set `sb_is_active` = 'N' where `sb_id` = 2;
set SQL_SAFE_UPDATES = 1; 
SET GLOBAL show_compatibility_56 = OFF;