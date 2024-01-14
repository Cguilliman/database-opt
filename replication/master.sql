CREATE USER 'slave'@'%' IDENTIFIED WITH mysql_native_password BY 'master_user_password';
GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%';
FLUSH PRIVILEGES;

-- USE master_db; 
-- FLUSH TABLES WITH READ LOCK;
