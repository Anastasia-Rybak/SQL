-- Задание 2.3.5.TSK.B: обновить все имена авторов, добавив в конец имени « [+]», если в библиотеке есть более трёх книг этого автора, или добавив в конец имени « [-]» в противном случае.
SET SQL_SAFE_UPDATES = 0;
update authors set a_name = case when a_id in (select `id` from (select a_id as `id`, count(*) as `count` from m2m_books_authors group by a_id having count > 1 ) as alias) then (select concat(a_name, ' [+]')) else (select concat(a_name, ' [-]')) end;
SET SQL_SAFE_UPDATES = 1;