-- Задача 7.4.1.b{532}: оформить решение задачи 7.4.1.а в виде функции, по-лучающей на вход дату и возвращающей результат в виде одной строки (а не двух отдельных колонок).
SET GLOBAL log_bin_trust_function_creators = 1;
drop function if exists GetWeekAndDay;

DELIMITER $$
CREATE FUNCTION GetWeekAndDay (date_var DATE) 
RETURNS CHAR(4) 
BEGIN 
	DECLARE day_number TINYINT; -- номер дня недели (4) 
	DECLARE week_number TINYINT; -- номер полной недели месяца (3) 
	DECLARE current_wn TINYINT; -- номер в году недели, -- к которой относится -- анализируемая дата (42)
	DECLARE first_dom_wn TINYINT; -- номер в году недели, к которой относится -- первый день месяца, к которому относится -- анализируемая дата (39) 
    DECLARE current_dom TINYINT; -- номер дня в месяце (20) 
    SET day_number = WEEKDAY(date_var) + 1; -- нумерация идёт с 0, -- потому нужен +1 (3+1 = 4) 
    SET current_dom = DAY(date_var); -- (20) 
    SET current_wn = WEEK(date_var, 5); -- про "5" см. документацию (42) 
    SET first_dom_wn = WEEK(date_var - INTERVAL current_dom-1 DAY, 5); -- (39) 
    SET week_number = current_wn - first_dom_wn; -- (3) 
    IF WEEKDAY(date_var - INTERVAL current_dom-1 DAY) <= WEEKDAY(date_var) 
		THEN 
			SET week_number = week_number + 1; 
	END IF;
RETURN CONCAT('W', week_number, 'D', day_number); -- W3D4 
END;
$$ DELIMITER ;

SELECT `sb_id`, `sb_start`, GetWeekAndDay(`sb_start`) AS `DW` FROM `subscriptions`
