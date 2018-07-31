-- Задача 7.3.1.b{523}: сменить созданному в задаче 7.3.1.a пользователю па-роль.
SET PASSWORD FOR 'new_user'@'%' = PASSWORD('some_password')