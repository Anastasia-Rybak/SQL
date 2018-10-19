-- Задание 5.1.1.TSK.A: создать хранимую функцию, получающую на вход идентификатор читателя и возвращающую список идентификаторов книг, которые он уже прочитал и вернул в библиотеку.
DROP FUNCTION IF EXISTS GET_books; 
DELIMITER $$ 
CREATE FUNCTION GET_books(id int) 
RETURNS VARCHAR(21845) DETERMINISTIC
BEGIN 
	DECLARE books_string VARCHAR(21845) DEFAULT '';
	select group_concat(`b_id`) 
    from (select distinct `s_id`, `b_id` 
		from books 
        join subscriptions on `b_id` = `sb_book` 
        join subscribers on `sb_subscriber` = `s_id` 
        where `s_id` = id and `sb_is_active` = 'N' 
        order by `s_id`,`b_id`) as `data` 
	group by `s_id`
    into books_string;
    RETURN books_string; 
END;
$$
DELIMITER ;
select `s_id`, GET_books(`s_id`)
from `subscribers`;