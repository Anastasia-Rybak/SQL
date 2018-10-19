-- Задача 5.1.1.a{353}: создать хранимую функцию, получающую на вход даты выдачи и возврата книги и возвращающую разницу между этими датами в днях, а также слова « [OK]», « [NOTICE]», « [WARNING]», соответ-ственно, если разница в днях составляет менее десяти, от десяти до тридцати и более тридцати дней.
drop function if exists READ_DURATION_AND_STATUS;
DELIMITER $$ 
CREATE FUNCTION READ_DURATION_AND_STATUS
(start_date DATE, finish_date DATE) 
RETURNS VARCHAR(150) DETERMINISTIC 
BEGIN 
	DECLARE days INT; 
    DECLARE message VARCHAR(150); 
    SET days = DATEDIFF(finish_date, start_date); 
    CASE 
		WHEN (days<10) THEN 
			SET message = ' OK'; 
		WHEN ((days>=10) AND (days<=30)) THEN 
			SET message = ' NOTICE'; 
		WHEN (days>30) THEN 
			SET message = ' WARNING'; 
	END CASE; 
	RETURN CONCAT(days, message); 
END
$$ 
DELIMITER ;
SELECT `sb_id`, `sb_start`, `sb_finish`, READ_DURATION_AND_STATUS(`sb_start`, `sb_finish`) AS `rdns` 
FROM `subscriptions` 
WHERE `sb_is_active` = 'Y';