-- Задача 6.2.1.b{431}: написать два запроса, каждый из которых будет счи-тать количество выданных каждому читателю книг, но при этом:
-- • один запрос должен выполняться максимально быстро (даже ценой предоставления не совсем достоверных данных);
-- • другой запрос должен предоставлять гарантированно достоверные данные (даже ценой большого времени выполнения).
SELECT CONNECTION_ID(); 
SET autocommit = 0; 
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 
START TRANSACTION; 
SELECT `sb_subscriber`, COUNT(`sb_book`) AS `sb_has_books` 
FROM `subscriptions` 
WHERE `sb_is_active` = 'Y' 
GROUP BY `sb_subscriber`; 
COMMIT;

SELECT CONNECTION_ID(); 
SET autocommit = 0; 
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION; 
SELECT `sb_subscriber`, COUNT(`sb_book`) AS `sb_has_books` 
FROM `subscriptions` 
WHERE `sb_is_active` = 'Y' 
GROUP BY `sb_subscriber`; 
COMMIT;

SELECT CONNECTION_ID(); 
SET autocommit = 0; 
START TRANSACTION; 
set SQL_SAFE_UPDATES = 0;
UPDATE `subscriptions` 
SET `sb_is_active` = 
	CASE 
		WHEN `sb_is_active` = 'Y' THEN 'N' 
        WHEN `sb_is_active` = 'N' THEN 'Y' 
	END;
set SQL_SAFE_UPDATES = 1;
SELECT SLEEP(10); 
COMMIT;