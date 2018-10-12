-- select * from `information_schema`.TABLE_CONSTRAINTS;
-- SHOW FUNCTION status WHERE name = 'CHECK_books_count';
DROP PROCEDURE if exists SHOW_TABLE_OBJECTS2; 
DELIMITER $$ 
CREATE PROCEDURE SHOW_TABLE_OBJECTS2 (IN func_name VARCHAR(150)) 
BEGIN 
	
	select table_name, constraint_name 
    from `information_schema`.TABLE_CONSTRAINTS
    where TABLE_SCHEMA in (select distinct SPECIFIC_SCHEMA from `information_schema`.PARAMETERS where SPECIFIC_NAME = func_name and ROUTINE_TYPE = 'function')
    and CONSTRAINT_TYPE = 'FOREIGN KEY';
END; 
$$ 
DELIMITER ;
CALL SHOW_TABLE_OBJECTS2('CHECK_books_count');