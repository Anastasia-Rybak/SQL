create or replace view `task331a1`
as
	SELECT DISTINCT `a_id`, `g_id` FROM `m2m_books_genres` JOIN `m2m_books_authors` USING (`b_id`) ;
    
create or replace view `task331a`
as
	SELECT `a_id`, `a_name`, COUNT(`g_id`) AS `genres_count` FROM `task331a1`  JOIN `authors` USING (`a_id`) GROUP BY `a_id` HAVING `genres_count` > 1;
    
select * from `task331a`	