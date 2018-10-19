-- Задание 3.1.2.TSK.B: создать кэширующее представление, позволяющее получать список всех книг и их жанров (две колонки: первая — название книги, вторая — жанры книги, перечисленные через запятую).
SET foreign_key_checks = 0;
SET SQL_SAFE_UPDATES = 0;
drop table if exists `TableTask312tskb`;
create table  `TableTask312tskb`
(
	`id` int unsigned,
	`name` varchar(150),
    `genres` varchar(1024)
);
insert into `TableTask312tskb`(`id`,`name`, `genres`)
select `b_id`, `b_name`, group_concat(`g_name`) 
from `books` 
	join `m2m_books_genres` using(`b_id`) 
    join `genres` using(`g_id`) 
    group by `books`.`b_id`;    
drop trigger if exists `m2m_books_genres_insert`;
Delimiter $$
create trigger `m2m_books_genres_insert`
after insert on m2m_books_genres
	for each row
		begin
			delete from `TableTask312tskb` where `id` = new.`b_id`;
			insert into `TableTask312tskb`(`id`,`name`, `genres`)
			select `b_id`, `b_name`, group_concat(`g_name`) 
				from `books` 
				join `m2m_books_genres` using(`b_id`) 
				join `genres` using(`g_id`) 
                where `b_id` = new.`b_id`
				group by `books`.`b_id`;
        end;
$$
DELIMITER ;
drop trigger if exists `m2m_books_genres_delete`;
Delimiter $$
create trigger `m2m_books_genres_delete`
after delete on m2m_books_genres
	for each row
		begin
			delete from `TableTask312tskb` where `id` = old.`b_id`;
			insert into `TableTask312tskb`(`id`,`name`, `genres`)
			select `b_id`, `b_name`, group_concat(`g_name`) 
				from `books` 
				join `m2m_books_genres` using(`b_id`) 
				join `genres` using(`g_id`) 
                where `b_id` = old.`b_id`
				group by `books`.`b_id`;
        end;
$$
DELIMITER ;
drop trigger if exists `m2m_books_genres_update`;
Delimiter $$
create trigger `m2m_books_genres_update`
after update on m2m_books_genres
	for each row
		begin
			delete from `TableTask312tskb` where `id` = new.`b_id` or `id` = old.`b_id`;
			insert into `TableTask312tskb`(`id`,`name`, `genres`)
			select `b_id`, `b_name`, group_concat(`g_name`) 
				from `books` 
				join `m2m_books_genres` using(`b_id`) 
				join `genres` using(`g_id`) 
                where `b_id` = new.`b_id` or `b_id` = old.`b_id`
				group by `books`.`b_id`;
        end;
$$
DELIMITER ;
INSERT INTO `library`.`books`(`b_id`,`b_name`, `b_year`, `b_quantity`) VALUES (8, 'Новая книга', 2010, 2);
INSERT INTO `library`.`m2m_books_genres` (`b_id`, `g_id`) VALUES(8,1), (8,2);
UPDATE `library`.`m2m_books_genres` SET `b_id` = 8, `g_id` = 3 WHERE `b_id` = 8 AND `g_id` = 2;
UPDATE `library`.`m2m_books_genres` SET `b_id` = 8, `g_id` = 4 WHERE `b_id` = 1 AND `g_id` = 1;
delete from `library`.`m2m_books_genres` where `b_id` = 8 and `g_id` = 1;
delete from `library`.`m2m_books_genres` where `b_id` = 1 and `g_id` = 5;
SET SQL_SAFE_UPDATES = 1;
SET foreign_key_checks = 1;