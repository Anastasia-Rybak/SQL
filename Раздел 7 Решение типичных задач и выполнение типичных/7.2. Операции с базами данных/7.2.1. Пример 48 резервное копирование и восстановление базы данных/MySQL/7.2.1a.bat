@echo off
rem «адача 7.2.1.a{516}: написать командный файл дл€ автоматизации создани€ резервной копии базы данных.
cd /d C:\Program Files (x86)\MySQL\MySQL Server 5.7\bin
mysqldump -uroot -pm19n28j375k library --result-file=D:\SQL\Dump\MySQL\dump.sql