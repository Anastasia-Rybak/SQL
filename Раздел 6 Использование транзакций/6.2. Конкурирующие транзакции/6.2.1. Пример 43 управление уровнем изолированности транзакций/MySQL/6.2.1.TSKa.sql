-- Задание 6.2.1.TSK.A: написать запросы, которые, будучи выполненными параллельно, обеспечивали бы следующий эффект:
-- • первый запрос должен считать количество выданных на руки и возвра-щённых в библиотеку книг и не зависеть от запросов на обновление таблицы subscriptions (не ждать их завершения);
-- • второй запрос должен инвертировать значения поля sb_is_active таблицы subscriptions с Y на N и наоборот и не зависеть от первого запроса (не ждать его завершения).
SELECT CONNECTION_ID(); 
SET autocommit = 0;
START TRANSACTION; 
select count(*) from subscriptions where sb_is_active = 'N';
-- SELECT SLEEP(10); 
COMMIT;

SELECT CONNECTION_ID(); 
SET autocommit = 0;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; 
START TRANSACTION; 
set SQL_SAFE_UPDATES = 0;
UPDATE `subscriptions` 
SET `sb_is_active` = 
	CASE 
		WHEN `sb_is_active` = 'Y' THEN 'N' 
        WHEN `sb_is_active` = 'N' THEN 'Y' 
	END;
set SQL_SAFE_UPDATES = 1;
-- SELECT SLEEP(10); 
COMMIT;