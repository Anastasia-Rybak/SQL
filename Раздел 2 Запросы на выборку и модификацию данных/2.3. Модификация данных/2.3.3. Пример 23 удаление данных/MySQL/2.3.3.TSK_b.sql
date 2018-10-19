-- Задание 2.2.3.TSK.B: удалить все книги, относящиеся к жанру «Клас-сика».
SET SQL_SAFE_UPDATES = 0;
DELETE FROM `books` WHERE `b_id` in (select b_id from m2m_books_genres join genres using (g_id) where g_name = 'Классика');
SET SQL_SAFE_UPDATES = 1;