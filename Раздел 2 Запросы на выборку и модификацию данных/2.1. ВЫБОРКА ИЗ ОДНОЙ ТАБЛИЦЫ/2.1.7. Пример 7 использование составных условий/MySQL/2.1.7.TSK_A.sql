-- Задание 2.1.7.TSK.A: показать книги, количество экземпляров которых меньше среднего по библиотеке.
select avg(`b_quantity`) into @a FROM `books`;
SELECT `b_name` FROM `books` where @a >=`b_quantity`