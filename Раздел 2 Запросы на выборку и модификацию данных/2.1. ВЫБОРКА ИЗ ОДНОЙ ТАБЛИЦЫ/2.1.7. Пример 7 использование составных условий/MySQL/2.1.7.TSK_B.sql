-- Задание 2.1.7.TSK.B: показать идентификаторы и даты выдачи книг за первый год работы библиотеки (первым годом работы библиотеки считать все даты с первой выдачи книги по 31-е декабря (включительно) того года, когда библиотека начала работать).
select min(`sb_start`) into @d FROM `subscriptions`;
select `b_id`, `sb_start` from `subscriptions` where year(@d) = year(`sb_start`)