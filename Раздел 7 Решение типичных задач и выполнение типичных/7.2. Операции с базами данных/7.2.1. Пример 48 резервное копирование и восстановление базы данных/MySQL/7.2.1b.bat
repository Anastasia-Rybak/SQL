@echo off
rem ������ 7.2.1.b{518}: �������� ��������� ���� ��� ������������� ������-�������� ���� ������ �� ��������� �����.
cd /d C:\Program Files (x86)\MySQL\MySQL Server 5.7\bin
mysql -uroot -pm19n28j375k -e "DROP SCHEMA `library`;";
mysql -uroot -pm19n28j375k -e "CREATE SCHEMA `library` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;";
mysql -uroot -pm19n28j375k library < D:\SQL\Dump\MySQL\dump.sql