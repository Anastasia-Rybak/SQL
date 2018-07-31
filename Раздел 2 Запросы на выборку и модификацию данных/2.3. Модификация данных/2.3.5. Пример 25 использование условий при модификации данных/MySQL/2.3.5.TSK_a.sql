-- Задание 2.3.5.TSK.A: добавить в базу данных читателей с именами «Си-доров С.С.», «Иванов И.И.», «Орлов О.О.»; если читатель с таким именем уже существует, добавить в конец имени нового читателя порядковый но-мер в квадратных скобках (например, если при добавлении читателя «Си-доров С.С.» выяснится, что в базе данных уже есть четыре таких чита-теля, имя добавляемого должно превратиться в «Сидоров С.С. [5]»).
SET SQL_SAFE_UPDATES = 0;
insert into subscribers (s_id, s_name)  values (null, 
	case 
    when exists(select s_id from subscribers as subscr where subscr.s_name = 'Иванов И.И.')     
    then (select concat('Иванов И.И.', ' [', (select count(*) from subscribers as subscrib where subscrib.s_name = 'Иванов И.И.') ,']'))
    else (select 'Иванов И.И.') 
    end),
	(null, 
	case 
    when exists(select s_id from subscribers as subscr where subscr.s_name = 'Орлов О.О.')     
    then (select concat('Орлов О.О.', ' [', (select count(*) from subscribers as subscrib where subscrib.s_name = 'Орлов О.О.') ,']'))
    else (select 'Орлов О.О.') 
    end);
SET SQL_SAFE_UPDATES = 1;