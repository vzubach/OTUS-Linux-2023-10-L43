!#/bin/bash

mysql -uroot -p"$(echo "$(cat /var/log/mysqld.log | grep 'root@localhost:' | awk '{print $11}')")" --connect-expired-password -e 'ALTER USER USER() IDENTIFIED BY "Password2\#";'
mysql -uroot -p'Password2#' -e 'CHANGE MASTER TO MASTER_HOST = "10.0.26.101", MASTER_PORT = 3306, MASTER_USER = "repl", MASTER_PASSWORD = "\!OtusLinux2018", MASTER_AUTO_POSITION = 1;'
mysql -uroot -p'Password2#' -e 'START SLAVE;'