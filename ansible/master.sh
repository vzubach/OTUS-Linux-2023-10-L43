!#/bin/bash

mysql -uroot -p"$(echo "$(cat /var/log/mysqld.log | grep 'root@localhost:' | awk '{print $11}')")" --connect-expired-password -e 'ALTER USER USER() IDENTIFIED BY "Password2\#";'
mysql -uroot -p'Password2#' -e 'CREATE DATABASE bet;'
mysql -uroot -p'Password2#' -D bet < /vagrant/bet.dmp
mysql -uroot -p'Password2#' -e 'USE bet;CREATE USER 'repl'@"\%" IDENTIFIED BY "\!OtusLinux2018";'
mysql -uroot -p'Password2#' -e 'USE bet;GRANT REPLICATION SLAVE ON *.* TO 'repl'@"%" IDENTIFIED BY "\!OtusLinux2018";'
