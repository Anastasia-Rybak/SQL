-- Задача 7.3.1.a{522}: создать нового пользователя СУБД и предоставить ему полный набор прав на базу данных «Библиотека».
CREATE USER 'new_user'@'%' IDENTIFIED BY 'new_password'; 
GRANT ALL PRIVILEGES ON `library`.* TO 'new_user'@'%';