-- Задача 6.2.1.a{428}: написать запросы, которые, будучи выполненными па-раллельно, обеспечивали бы следующий эффект:
-- • первый запрос должен добавлять ко всем датам возврата книг один день и не зависеть от запросов на чтение из таблицы subscriptions (не ждать их завершения);
-- • второй запрос должен читать все даты возврата книг из таблицы subscriptions и не зависеть от первого запроса (не ждать его завер-шения).
SELECT CONNECTION_ID(); 
SET autocommit = 0;
START TRANSACTION; 
set SQL_SAFE_UPDATES = 0;
UPDATE `subscriptions` 
SET `sb_finish` = DATE_ADD(`sb_finish`, INTERVAL 1 DAY); 
set SQL_SAFE_UPDATES = 1;
-- SELECT SLEEP(10); 
COMMIT;

SELECT CONNECTION_ID(); 
SET autocommit = 0;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; 
START TRANSACTION; 
SELECT `sb_finish` FROM `subscriptions`; 
-- SELECT SLEEP(10); 
COMMIT;