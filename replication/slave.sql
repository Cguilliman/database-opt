-- -- CHANGE REPLICATION SOURCE TO FOR CHANNEL '';

CHANGE MASTER TO MASTER_HOST='mysql-master', 
MASTER_USER='slave', 
MASTER_PASSWORD='master_user_password',
MASTER_LOG_FILE = 'mysql-bin.000001', 
MASTER_LOG_POS = 0;


START SLAVE;