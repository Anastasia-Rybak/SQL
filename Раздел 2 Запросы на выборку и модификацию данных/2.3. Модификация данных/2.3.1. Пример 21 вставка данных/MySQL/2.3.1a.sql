-- Задача 2.3.1.a{182}: добавить в базу данных информацию о том, что чита-тель с идентификатором 4 взял 15-го января 2016-го года в библиотеке книгу с идентификатором 3 и обещал вернуть её 30-го января 2016-го года.
INSERT INTO `subscriptions` (`sb_id`, `s_id`, `b_id`, `sb_start`, `sb_finish`, `sb_is_active`) VALUES (4, 4, 3, '2016-01-15', '2016-01-30', 'N')