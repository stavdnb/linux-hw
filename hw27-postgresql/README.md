# **HW-27: PostgreSQL**

## **Задание:**
репликация postgres
- Настроить hot_standby репликацию с использованием слотов
- Настроить правильное резервное копирование

Для сдачи работы присылаем ссылку на репозиторий, в котором должны обязательно быть
- Vagranfile (2 машины)
- плейбук Ansible
- конфигурационные файлы postgresql.conf, pg_hba.conf и recovery.conf,
- конфиг barman, либо скрипт резервного копирования.

Команда "vagrant up" должна поднимать машины с настроенной репликацией и резервным копированием.
Рекомендуется в README.md файл вложить результаты (текст или скриншоты) проверки работы репликации и резервного копирования.


---

## **Выполнено:**

- Поднимаем стенд:
```
vagrant up
```

- Проверяем созданные слоты:
```
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw27-postgresql$ vagrant ssh master
Last login: Fri Jan  6 16:58:26 2023 from 10.0.2.2
[vagrant@master ~]$ sudo -i 
[root@master ~]# su postgres
bash-4.4$ psql
could not change directory to "/root": Permission denied
psql (11.18)
Type "help" for help.

postgres=# \x
Expanded display is on.
postgres=# select * from pg_replication_slots;
-[ RECORD 1 ]-------+-------------
slot_name           | standby_slot
plugin              | 
slot_type           | physical
datoid              | 
database            | 
temporary           | f
active              | t
active_pid          | 27882
xmin                | 
catalog_xmin        | 
restart_lsn         | 0/12000140
confirmed_flush_lsn | 
-[ RECORD 2 ]-------+-------------
slot_name           | barman
plugin              | 
slot_type           | physical
datoid              | 
database            | 
temporary           | f
active              | t
active_pid          | 28420
xmin                | 
catalog_xmin        | 
restart_lsn         | 0/12000000
confirmed_flush_lsn | 

postgres=#
```

- Проверяем статус репликации:
```
postgres=# select * from pg_stat_replication;
-[ RECORD 1 ]----+------------------------------
pid              | 27882
usesysid         | 16384
usename          | replica
application_name | walreceiver
client_addr      | 10.10.11.151
client_hostname  | 
client_port      | 59208
backend_start    | 2023-01-06 13:58:17.836787+00
backend_xmin     | 
state            | streaming
sent_lsn         | 0/12000140
write_lsn        | 0/12000140
flush_lsn        | 0/12000140
replay_lsn       | 0/12000140
write_lag        | 
flush_lag        | 
replay_lag       | 
sync_priority    | 0
sync_state       | async
-[ RECORD 2 ]----+------------------------------
pid              | 28420
usesysid         | 16386
usename          | streaming_barman
application_name | barman_receive_wal
client_addr      | 10.10.11.152
client_hostname  | 
client_port      | 40552
backend_start    | 2023-01-06 14:00:04.440955+00
backend_xmin     | 
state            | streaming
sent_lsn         | 0/12000140
write_lsn        | 0/12000140
flush_lsn        | 0/12000000
replay_lsn       | 
write_lag        | 00:00:01.941263
flush_lag        | 02:31:10.64688
replay_lag       | 02:31:42.183043
sync_priority    | 0
sync_state       | async

postgres-# \q
bash-4.4$ exit
exit
[root@master vagrant]# exit
exit
[vagrant@master ~]$ exit
logout
Connection to 127.0.0.1 closed.
```

- Проверяем статус работы сервера бэкапа: 
```
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw27-postgresql$ vagrant ssh backup
Last login: Fri Jan  6 16:59:17 2023 from 10.0.2.2
[vagrant@backup ~]$ sudo -i
[root@backup ~]# su barman
bash-4.4$ barman check master
/usr/local/lib64/python3.6/site-packages/psycopg2/__init__.py:144: UserWarning: The psycopg2 wheel package will be renamed from release 2.8; in order to keep installing from binary please use "pip install psycopg2-binary" instead. For details see: <http://initd.org/psycopg/docs/install.html#binary-install-from-pypi>.
  """)
Server master:
        PostgreSQL: OK
        superuser or standard user with backup privileges: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        backup minimum size: OK (0 B)
        wal maximum age: OK (no last_wal_maximum_age provided)
        wal size: OK (0 B)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 0 backups, expected at least 0)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK (no system Id stored on disk)
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archive_mode: OK
        archive_command: OK
        continuous archiving: OK
        archiver errors: OK
```

- Создаем бекап:
```
bash-4.4$ barman backup master --wait
/usr/local/lib64/python3.6/site-packages/psycopg2/__init__.py:144: UserWarning: The psycopg2 wheel package will be renamed from release 2.8; in order to keep installing from binary please use "pip install psycopg2-binary" instead. For details see: <http://initd.org/psycopg/docs/install.html#binary-install-from-pypi>.
  """)
Starting backup using postgres method for server master in /var/lib/barman/master/base/20230106T193411
Backup start at LSN: 0/12000140 (000000010000000000000012, 00000140)
Starting backup copy via pg_basebackup for 20230106T193411
Copy done (time: 8 seconds)
Finalising the backup.
This is the first backup for server master
WAL segments preceding the current backup have been found:
        000000010000000000000011 from server master has been removed
Backup size: 302.8 MiB
Backup end at LSN: 0/14000060 (000000010000000000000014, 00000060)
Backup completed (start time: 2023-01-06 19:34:11.895306, elapsed time: 10 seconds)
Waiting for the WAL file 000000010000000000000014 from server 'master'
Processing xlog segments from streaming for master
        000000010000000000000012
        000000010000000000000013
        000000010000000000000014

bash-4.4$ barman list-backup master
/usr/local/lib64/python3.6/site-packages/psycopg2/__init__.py:144: UserWarning: The psycopg2 wheel package will be renamed from release 2.8; in order to keep installing from binary please use "pip install psycopg2-binary" instead. For details see: <http://initd.org/psycopg/docs/install.html#binary-install-from-pypi>.
  """)
master 20230106T193411 - Fri Jan  6 16:34:20 2023 - Size: 334.8 MiB - WAL Size: 0 B

bash-4.4$ barman check master
/usr/local/lib64/python3.6/site-packages/psycopg2/__init__.py:144: UserWarning: The psycopg2 wheel package will be renamed from release 2.8; in order to keep installing from binary please use "pip install psycopg2-binary" instead. For details see: <http://initd.org/psycopg/docs/install.html#binary-install-from-pypi>.
  """)
Server master:
        PostgreSQL: OK
        superuser or standard user with backup privileges: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        backup minimum size: OK (302.8 MiB)
        wal maximum age: OK (no last_wal_maximum_age provided)
        wal size: OK (0 B)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 1 backups, expected at least 0)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archive_mode: OK
        archive_command: OK
        continuous archiving: OK
        archiver errors: OK
```

## **Полезное:**

