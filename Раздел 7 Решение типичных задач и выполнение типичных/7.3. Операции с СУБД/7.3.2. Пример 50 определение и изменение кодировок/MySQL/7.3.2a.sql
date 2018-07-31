-- Задача 7.3.2.a{525}: вывести всю информацию о текущих настройках СУБД относительно кодировок, используемых по умолчанию.
SHOW GLOBAL VARIABLES WHERE `variable_name` LIKE 'character\_set%' OR `variable_name` LIKE 'collat%'
