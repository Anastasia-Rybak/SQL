LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/authors.csv' 
REPLACE
INTO TABLE authors 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

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
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/subscribers.csv'
REPLACE 
INTO TABLE subscribers 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

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

INSERT INTO `library`.`site_pages` (`sp_id`, `sp_name`) VALUES ('1', 'Главная');

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