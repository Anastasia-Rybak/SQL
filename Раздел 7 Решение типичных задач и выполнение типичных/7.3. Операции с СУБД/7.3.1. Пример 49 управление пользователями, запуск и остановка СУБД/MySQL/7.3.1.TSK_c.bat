@Echo Off
rem Задача 7.3.1.с{523}: создать командные файлы для запуска, остановки, перезапуска СУБД.
Set ServiceName=MySQL57


SC queryex "%ServiceName%"|Find "STATE"|Find /v "RUNNING">Nul&&(
    echo %ServiceName% not running 
)||(
    echo "%ServiceName%" working
)
pause