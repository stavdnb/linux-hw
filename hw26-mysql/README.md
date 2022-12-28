# **HW-26: Репликация MySQL**

## **Задание:**
настроить реплику

В материалах приложены ссылки на вагрант для репликации и дамп базы bet.dmp Базу развернуть на мастере и настроить так, чтобы реплицировались таблицы: | bookmaker | | competition | | market | | odds | | outcome

Настроить GTID репликацию x варианты которые принимаются к сдаче
- рабочий вагрантафайл
- скрины или логи SHOW TABLES
- конфиги
- пример в логе изменения строки и появления строки на реплике
---

## **Выполнено:**
- Поднимаем стенд:
```
vagrant up
```
- Проверяем  master:
```
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw26-mysql$ vagrant ssh master
Last login: Wed Dec 28 11:34:00 2022 from 10.0.2.2
[vagrant@master ~]$ sudo -i 
[root@master ~]# mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.7.40-43-log Percona Server (GPL), Release 43, Revision c1b94a6cfd7

Copyright (c) 2009-2021 Percona LLC and/or its affiliates
Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql> USE bet;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
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

mysql> SELECT * FROM bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
4 rows in set (0.00 sec)

mysql> SELECT @@server_id;
+-------------+
| @@server_id |
+-------------+
|           1 |
+-------------+
1 row in set (0.00 sec)

mysql> \q
Bye
[root@master vagrant]# exit
exit
[vagrant@master ~]$ exit
logout
Connection to 127.0.0.1 closed
```

- Проверяем slave:
```
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw26-mysql$ vagrant ssh slave
Last login: Wed Dec 28 11:34:14 2022 from 10.0.2.2
[vagrant@slave ~]$ sudo -i 
[root@slave ~]# mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 5.7.40-43-log Percona Server (GPL), Release 43, Revision c1b94a6cfd7

Copyright (c) 2009-2021 Percona LLC and/or its affiliates
Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql> SELECT @@server_id;
+-------------+
| @@server_id |
+-------------+
|           2 |
+-------------+
1 row in set (0.00 sec)

mysql> USE bet;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SHOW TABLES;
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

mysql> SELECT * FROM bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
4 rows in set (0.00 sec)

mysql> SHOW SLAVE STATUS\G
Query OK, 0 rows affected (0.00 sec)

mysql> SHOW SLAVE STATUS\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.10.11.150
                  Master_User: repl
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000001
          Read_Master_Log_Pos: 119198
               Relay_Log_File: slave-relay-bin.000002
                Relay_Log_Pos: 414
        Relay_Master_Log_File: mysql-bin.000001
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: bet.events_on_demand,bet.v_same_event
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 119198
              Relay_Log_Space: 621
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 1
                  Master_UUID: 73c1423a-86a3-11ed-93c2-5254001ff4e5
             Master_Info_File: /var/lib/mysql/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 73c1423a-86a3-11ed-93c2-5254001ff4e5:1-38
                Auto_Position: 1
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
1 row in set (0.00 sec)
```

- Вносим изменения на master:
```
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw26-mysql$ vagrant ssh master
Last login: Wed Dec 28 19:33:17 2022 from 10.0.2.2
[vagrant@master ~]$ sudo -i
[root@master vagrant]# mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 5.7.33-36-log Percona Server (GPL), Release 36, Revision 7e403c5

mysql> USE bet;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> INSERT INTO bookmaker (id,bookmaker_name) VALUES(1,'1xbet');
Query OK, 1 row affected (0.00 sec)

mysql> SELECT * FROM bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  1 | 1xbet          |
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
5 rows in set (0.00 sec)
mysql> \q
Bye

[root@master vagrant]# mysqlbinlog  --base64-output=decode-rows --verbose /var/lib/mysql/mysql-bin.000001

BEGIN
/*!*/;
# at 119336
#221228 20:07:24 server id 1  end_log_pos 119463 CRC32 0x6ba70429      Query   thread_id=8     exec_time=0     error_code=0
SET TIMESTAMP=1672258044/*!*/;
INSERT INTO bookmaker (id,bookmaker_name) VALUES(1,'1xbet')
/*!*/;
# at 119463
#221228 20:07:24 server id 1  end_log_pos 119494 CRC32 0xf163040a      Xid = 644
COMMIT/*!*/;
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;

[root@master vagrant]# exit
exit
[vagrant@master ~]$ exit
logout
Connection to 127.0.0.1 closed.
```

- Проверяем репликацию на slave:
```
[root@slave ~]# mysql

mysql> USE bet;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT * FROM bookmaker;
+----+----------------+
| id | bookmaker_name |
+----+----------------+
|  1 | 1xbet          |
|  4 | betway         |
|  5 | bwin           |
|  6 | ladbrokes      |
|  3 | unibet         |
+----+----------------+
5 rows in set (0.00 sec)

mysql> \q
Bye

[root@slave vagrant]# mysqlbinlog  --base64-output=decode-rows --verbose /var/lib/mysql/mysql-bin.000001
BEGIN
/*!*/;
# at 419
#221228 20:07:24 server id 1  end_log_pos 450 CRC32 0xae599c9a Xid = 400
COMMIT/*!*/;
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;

```

## **Полезное:**

Помимо прочего столкнулся с проблемой Host '127.0.0.1' is not allowed to connect to this MySQL server

Сначала он лез по IPv6 , но после отключения продолжилось, помогло решение добавления в модуль подключения по сокету
```
login_unix_socket: "/var/lib/mysql/mysql.sock"
```
login_unix_socket: "/var/lib/mysql/mysql.sock"

https://www.linuxandubuntu.com/home/sqlstatehy000-1130-host-not-allowed-to-connect-to-this-mysql-server

https://docs.ansible.com/ansible/latest/collections/community/mysql/mysql_user_module.html