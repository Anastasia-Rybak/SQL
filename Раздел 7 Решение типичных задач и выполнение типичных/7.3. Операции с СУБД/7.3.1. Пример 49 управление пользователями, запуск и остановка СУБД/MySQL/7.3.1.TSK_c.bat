@Echo Off
rem Задача 7.3.1.с{523}: написать командный файл, показывающий, запущена ли в настоящий момент каждая из трех СУБД.
Set ServiceName=MySQL57


SC queryex "%ServiceName%"|Find "STATE"|Find /v "RUNNING">Nul&&(
    echo %ServiceName% not running 
)||(
    echo "%ServiceName%" working
)
pause