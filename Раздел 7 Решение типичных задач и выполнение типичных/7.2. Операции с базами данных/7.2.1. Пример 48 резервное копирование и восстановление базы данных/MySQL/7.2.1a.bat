@echo off
rem ������ 7.2.1.a{516}: �������� ��������� ���� ��� ������������� �������� ��������� ����� ���� ������.
cd /d C:\Program Files (x86)\MySQL\MySQL Server 5.7\bin
mysqldump -uroot -pm19n28j375k library --result-file=D:\SQL\Dump\MySQL\dump.sql