# **HW-17 Backup**
## **Задание:**
Настраиваем бэкапы
Настроить стенд Vagrant с двумя виртуальными машинами: backup_server и client

Настроить удаленный бекап каталога /etc c сервера client при помощи borgbackup. Резервные копии должны соответствовать следующим критериям:

- Директория для резервных копий /var/backup. Это должна быть отдельная точка монтирования. В данном случае для демонстрации размер не принципиален, достаточно будет и 2GB.
- Репозиторий дле резервных копий должен быть зашифрован ключом или паролем - на ваше усмотрение
- Имя бекапа должно содержать информацию о времени снятия бекапа
- Глубина бекапа должна быть год, хранить можно по последней копии на конец месяца, кроме последних трех. Последние три месяца должны содержать копии на каждый день. Т.е. должна быть правильно настроена политика удаления старых бэкапов
- Резервная копия снимается каждые 5 минут. Такой частый запуск в целях демонстрации.
- Написан скрипт для снятия резервных копий. Скрипт запускается из соответствующей Cron джобы, либо systemd timer-а - на ваше усмотрение.
- Настроено логирование процесса бекапа. Для упрощения можно весь вывод перенаправлять в logger с соответствующим тегом. Если настроите не в syslog, то обязательна ротация логов

Запустите стенд на 30 минут. Убедитесь что резервные копии снимаются. Остановите бекап, удалите (или переместите) директорию /etc и восстановите ее из бекапа. Для сдачи домашнего задания ожидаем настроенные стенд, логи процесса бэкапа и описание процесса восстановления.

---

## **Выполнено:**

- Поднимаем стенд
```
vagrant up
```

- Проверяем:
```
root@stavos2:/home/stavdnb/vagrant_new/backup# vagrant ssh backupclient
Last login: Mon Oct 31 16:00:57 2022 from 10.0.2.2
[vagrant@backupclient ~]$ sudo -i
[root@backupclient ~]# systemctl status backup
● backup.service - My backup service
   Loaded: loaded (/etc/systemd/system/backup.service; static; vendor preset: disabled)
   Active: inactive (dead) since Mon 2022-10-31 16:01:24 UTC; 3min 1s ago
  Process: 5108 ExecStart=/opt/backup.sh (code=exited, status=0/SUCCESS)
 Main PID: 5108 (code=exited, status=0/SUCCESS)

Oct 31 16:00:58 backupclient systemd[1]: Starting My backup service...
Oct 31 16:01:04 backupclient backup.sh[5108]: borg 1.1.18
Oct 31 16:01:04 backupclient backup.sh[5108]: Starting backup for 2022-10-31-backupclient
Oct 31 16:01:07 backupclient backup.sh[5108]: Creating archive at "backup@backupserver:/var/backup/backupclient-etc::etc_backup-2...-01-05"
Oct 31 16:01:21 backupclient backup.sh[5108]: Completed backup for 2022-10-31-backupclient
Oct 31 16:01:24 backupclient backup.sh[5108]: Keeping archive: etc_backup-2022-10-31_16-01-05       Mon, 2022-10-31 16:01:07 [f0c...2eea2d]
Oct 31 16:01:24 backupclient backup.sh[5108]: terminating with success status, rc 0
Oct 31 16:01:24 backupclient systemd[1]: Started My backup service.
Hint: Some lines were ellipsized, use -l to show in full.
[root@backupclient ~]# journalctl -u backup
-- Logs begin at Mon 2022-10-31 15:37:48 UTC, end at Mon 2022-10-31 16:02:24 UTC. --
Oct 31 16:00:58 backupclient systemd[1]: Starting My backup service...
Oct 31 16:01:04 backupclient backup.sh[5108]: borg 1.1.18
Oct 31 16:01:04 backupclient backup.sh[5108]: Starting backup for 2022-10-31-backupclient
Oct 31 16:01:07 backupclient backup.sh[5108]: Creating archive at "backup@backupserver:/var/backup/backupclient-etc::etc_backup-2022-10-31_
Oct 31 16:01:21 backupclient backup.sh[5108]: Completed backup for 2022-10-31-backupclient
Oct 31 16:01:24 backupclient backup.sh[5108]: Keeping archive: etc_backup-2022-10-31_16-01-05       Mon, 2022-10-31 16:01:07 [f0c7de367f964
Oct 31 16:01:24 backupclient backup.sh[5108]: terminating with success status, rc 0
Oct 31 16:01:24 backupclient systemd[1]: Started My backup service.
[root@backupclient ~]# systemctl status backup.timer
● backup.timer - Run backup script every 5 minutes
   Loaded: loaded (/etc/systemd/system/backup.timer; enabled; vendor preset: disabled)
   Active: active (waiting) since Mon 2022-10-31 16:00:56 UTC; 5min ago

Oct 31 16:00:56 backupclient systemd[1]: Started Run backup script every 5 minutes.
[root@backupclient ~]# systemctl list-timers
NEXT                         LEFT     LAST                         PASSED    UNIT                         ACTIVATES
Mon 2022-10-31 16:05:58 UTC  12s ago  Mon 2022-10-31 16:06:11 UTC  9ms ago   backup.timer                 backup.service
Tue 2022-11-01 15:53:33 UTC  23h left Mon 2022-10-31 15:53:33 UTC  12min ago systemd-tmpfiles-clean.timer systemd-tmpfiles-clean.service

2 timers listed.
Pass --all to see loaded but inactive timers, too.
[root@backupclient ~]# systemctl stop backup.timer
[root@backupclient ~]# borg list backup@backupserver:/var/backup/client-etc
Enter passphrase for key ssh://backup@backupserver/var/backup/backupclient-etc: 
etc_backup-2022-10-31_16-06-18       Mon, 2022-10-31 16:06:20 [285ce0206315379935be004ba904a9c96124b1031c0b5fdbfc6dec3840488efa]
```

- полностью удалять /etc/ это долгий путь, для примера удалим например /etc/cifs-utils и восстановим туда же


```
[root@backupclient ~]# rm -rf /etc/cifs-utils/
[root@backupclient ~]# ls -l /etc/ | grep cifs
[root@backupclient ~]#
[root@backupclient ~]# cd /
[root@backupclient /]# borg extract backup@backupserver:/var/backup/backupclient-etc::etc_backup-2022-10-31_16-06-18 etc/cifs-utils
Enter passphrase for key ssh://backup@backupserver/var/backup/backupclient-etc: 
[root@backupclient /]# ls -l /etc/ | grep cifs
drwxr-xr-x.  2 root root       26 Apr 30  2020 cifs-utils
[root@backupclient /]# 
```


**Полезное:**

при сносе /etc/

https://github.com/stavdnb/linux-hw/tree/master/hw07-initrd



[Central repository Borg server with Ansible or Salt](https://borgbackup.readthedocs.io/en/stable/deployment/central-backup-server.html)

