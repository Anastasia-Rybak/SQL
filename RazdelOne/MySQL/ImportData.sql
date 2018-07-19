LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/authors.csv' 
INTO TABLE authors 
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/books.csv' 
INTO TABLE books 
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/genres.csv' 
INTO TABLE genres 
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/subscribers.csv' 
INTO TABLE subscribers 
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/m2m_books_genres.csv' 
INTO TABLE m2m_books_genres 
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/m2m_books_authors.csv' 
INTO TABLE m2m_books_authors 
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

LOAD DATA INFILE 'D:/SQL/RazdelOne/MySQL/CSVForImport/subscriptions.csv' 
INTO TABLE subscriptions 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;