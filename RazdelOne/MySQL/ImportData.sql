set sql_safe_updates = 0;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/authors.csv' 
REPLACE
INTO TABLE authors 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(`a_id`, `a_name`);

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/books.csv'
REPLACE 
INTO TABLE books 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/genres.csv'
REPLACE 
INTO TABLE genres 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(`g_id`, `g_name`);

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/subscribers.csv'
REPLACE 
INTO TABLE subscribers 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(`s_id`, `s_name`);

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/m2m_books_genres.csv'
REPLACE 
INTO TABLE m2m_books_genres 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/m2m_books_authors.csv'
REPLACE 
INTO TABLE m2m_books_authors 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/subscriptions.csv'
REPLACE 
INTO TABLE subscriptions 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/site_pages.csv'
REPLACE 
INTO TABLE site_pages 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/cities.csv'
REPLACE 
INTO TABLE cities 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/connections.csv'
REPLACE 
INTO TABLE connections 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/rooms.csv'
REPLACE 
INTO TABLE rooms 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/computers.csv'
REPLACE 
INTO TABLE computers 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

UPDATE `subscribers` LEFT JOIN (SELECT `sb_subscriber`, MAX(`sb_start`) AS `last_visit` FROM `subscriptions` GROUP BY `sb_subscriber`) AS `prepared_data` on `s_id` = `sb_subscriber` SET `s_last_visit` = `last_visit`;
UPDATE `subscribers` JOIN (SELECT `sb_subscriber`, COUNT(`sb_id`) AS `s_has_books` FROM `subscriptions` WHERE `sb_is_active` = 'Y' GROUP BY `sb_subscriber`) AS `prepared_data` ON `s_id` = `sb_subscriber` SET `s_books` = `s_has_books`;
UPDATE `genres` JOIN (SELECT `g_id`, COUNT(`b_id`) AS `g_has_books` FROM `m2m_books_genres` GROUP BY `g_id`) AS `prepared_data` USING (`g_id`) SET `g_books` = `g_has_books`;
UPDATE `authors` LEFT JOIN (select `a_id`, MAX(`last_issue`) as `max_issue` from `authors` join `m2m_books_authors` using(`a_id`) join (SELECT `sb_book`, MAX(`sb_start`) AS `last_issue` FROM `subscriptions` GROUP BY `sb_book`) AS `prepared_data` on `b_id` = `sb_book` group by `a_id`) as `final_data` using(`a_id`) SET `a_last_issue` = `max_issue`;
UPDATE `subscribers` left JOIN (SELECT `sb_subscriber`, count(`sb_start`) AS `count_books` FROM `subscriptions` GROUP BY `sb_subscriber`) AS `prepared_data` on `s_id` = `sb_subscriber` SET `s_count_books` = ifnull(`count_books`, 0);
set sql_safe_updates = 1;