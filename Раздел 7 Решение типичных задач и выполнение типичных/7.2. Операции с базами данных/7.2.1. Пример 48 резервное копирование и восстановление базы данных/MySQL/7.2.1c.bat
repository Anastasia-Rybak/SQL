@echo off
rem «адача 7.2.1.c{519}: написать командный файл дл¤ автоматизации созда-ни¤ рабочей копии базы данных.
cd /d C:\Program Files (x86)\MySQL\MySQL Server 5.7\bin
mysqldump -uroot -pm19n28j375k library --result-file=D:\SQL\Dump\MySQL\dump.sql
mysql -uroot -pm19n28j375k -e "DROP SCHEMA `library_copy`;";
mysql -uroot -pm19n28j375k -e "CREATE SCHEMA `library_copy` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;";
mysql -uroot -pm19n28j375k library_copy < D:\SQL\Dump\MySQL\dump.sql