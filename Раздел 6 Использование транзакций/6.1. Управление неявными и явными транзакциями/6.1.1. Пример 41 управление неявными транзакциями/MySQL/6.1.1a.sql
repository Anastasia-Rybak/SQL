-- Задача 6.1.1.a{408}: продемонстрировать поведение СУБД при выполнении операций модификации данных в случаях, когда режим автоподтвержде-ния неявных транзакций включён и выключен.
-- Автоподтверждение выключено: 
SET autocommit = 0; 
SELECT COUNT(*) FROM `subscribers`; -- 4 
INSERT INTO `subscribers` (`s_name`) VALUES ('Иванов И.И.'); 
SELECT COUNT(*) FROM `subscribers`; -- 5 
ROLLBACK; 
SELECT COUNT(*) FROM `subscribers`; -- 4 
-- Автоподтверждение включено: 
SET autocommit = 1; 
SELECT COUNT(*) FROM `subscribers`; -- 4 
INSERT INTO `subscribers` (`s_name`) VALUES ('Иванов И.И.'); 
SELECT COUNT(*) FROM `subscribers`; -- 5 
ROLLBACK; 
SELECT COUNT(*) FROM `subscribers`; -- 5