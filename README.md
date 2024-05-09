### OTUS-Linux-2023-10-L43 | MySQL | Репликация

В репозитории Vagrantfile и окружение ansible разворачивают два сервера MySQL. Происходит настройка мастер и slave серверов, импортируется БД и настраивается репликация БД между двумя серверами.<br>
- **Проверяем статус slave-сервера:**
```
mysql> SHOW SLAVE STATUS\G        
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.0.26.101
                  Master_User: repl
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000002
          Read_Master_Log_Pos: 119570
               Relay_Log_File: mysql2-relay-bin.000002
                Relay_Log_Pos: 119783
        Relay_Master_Log_File: mysql-bin.000002
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
				Last_IO_Errno: 0
				Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
           Retrieved_Gtid_Set: 1e4faa4b-0dde-11ef-8109-5254004d77d3:1-39
            Executed_Gtid_Set: 1e092edf-0dde-11ef-8017-5254004d77d3:1,1e4faa4b-0dde-11ef-8109-5254004d77d3:1-39

```
- **Проверяем содержимое БД на мастер и slave-серверах:**
```
[root@mysql1 ~]# mysql -uroot -p'Password2#'

mysql> USE bet;

Database changed
mysql> show tables;
+------------------+
| Tables_in_bet    |
+------------------+
| bookmaker        |
| competition      |
| events_on_demand |
| market           |
| odds             |
| outcome          |
| v_same_event     |
+------------------+
7 rows in set (0.00 sec)

```
```
[vagrant@mysql2 ~]$ mysql -uroot -p'Password2#'

mysql> use bet;

Database changed
mysql> show tables;
+---------------+
| Tables_in_bet |
+---------------+
| bookmaker     |
| competition   |
| market        |
| odds          |
| outcome       |
+---------------+
5 rows in set (0.00 sec)

```
Согласно заданию на вспомогательный сервер не реплицируются таблицы: v_same_event и events_on_demand.<br>
- **Добавим несколько записей в таблицу bookmaker на мастер-сервере**
```
mysql> SELECT @@server_id;
+-------------+
| @@server_id |
+-------------+
|           1 |
+-------------+
1 row in set (0.00 sec)

mysql> INSERT INTO bookmaker (id,bookmaker_name) VALUES(1,'1xbet');
Query OK, 1 row affected (0.00 sec)

mysql> INSERT INTO bookmaker (id,bookmaker_name) VALUES(2,'2xbet');
Query OK, 1 row affected (0.01 sec)

mysql> INSERT INTO bookmaker (id,bookmaker_name) VALUES(7,'7xbet');
Query OK, 1 row affected (0.00 sec)

mysql> SELECT * FROM bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  1 | 1xbet          |
|  2 | 2xbet          |
|  7 | 7xbet          |
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
7 rows in set (0.00 sec)

mysql> 
```
Добавлено 3 новых записи: 1xbet, 2xbet и 7xbet
- **Проверяем репликацию таблицы на slave-сервере**
```
mysql> SELECT @@server_id;
+-------------+
| @@server_id |
+-------------+
|           2 |
+-------------+
1 row in set (0.00 sec)

mysql> 
mysql> SELECT * FROM bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  1 | 1xbet          |
|  2 | 2xbet          |
|  7 | 7xbet          |
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
7 rows in set (0.00 sec)

mysql> 
SHOW SLAVE STATUS\G
*************************** 1. row ***************************
    Retrieved_Gtid_Set: 1e4faa4b-0dde-11ef-8109-5254004d77d3:1-42
     Executed_Gtid_Set: 1e092edf-0dde-11ef-8017-5254004d77d3:1,1e4faa4b-0dde-11ef-8109-5254004d77d3:1-42

mysql> 
```
Записи 1xbet, 2xbet и 7xbet успешно реплицировались на slave-сервер. Также увеличились значения Retrieved_Gtid_Set.