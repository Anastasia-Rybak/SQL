-- Задание 5.1.2.TSK.B: создать хранимую функцию, автоматизирующую проверку условий задачи 4.2.1.b{315}, т.е. возвращающую 1, если у чита-теля на руках сейчас менее десяти книг, и 0 в противном случае.
DROP FUNCTION IF EXISTS CHECK_books_count; 
DELIMITER $$ 
CREATE FUNCTION CHECK_books_count
(subscriber_id int) 
RETURNS INT reads sql data 
BEGIN
 	declare result int default 0;
    set result = (SELECT COUNT(`sb_book`)
					FROM `subscriptions` 
					WHERE `sb_is_active` = 'Y' AND `sb_subscriber` = subscriber_id 
                    GROUP BY `sb_subscriber`);
	if result < 2 then 
		return 1;
	else
		return 0;
	end if;
END; 
$$ 
DELIMITER ;
select CHECK_books_count(4);