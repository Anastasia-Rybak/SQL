-- Задание 3.1.1.TSK.B: создать представление, позволяющее получать список читателей с количеством находящихся у каждого читателя на ру-ках книг, но отображающее только таких читателей, по которым имеются задолженности, т.е. на руках у читателя есть хотя бы одна книга, которую он должен был вернуть до наступления текущей даты.
create or replace view `task331b`
as
	select subscribers.s_name, count(subscriptions.b_id) 
    from subscribers join subscriptions using(s_id) 
    where subscriptions.sb_is_active = 'N' and subscriptions.sb_finish < curdate()
    group by subscribers.s_name;
    
select * from `task331b`    