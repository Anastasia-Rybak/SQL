-- Задача 2.1.6.b{36}: показать все книги в библиотеке в порядке убывания их года издания.
SELECT `b_name`, `b_year` FROM `books` ORDER BY `b_year` DESC