@echo off
rem Задача 7.3.1.с{523}: создать командные файлы для запуска, остановки, перезапуска СУБД.

rem Остановка 
net stop MySQL57 
rem Запуск 
net start MySQL57
pause