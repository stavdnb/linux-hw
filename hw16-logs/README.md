# **HW-16 Сбор и анализ логов**

## **Задание:**
Настраиваем центральный сервер для сбора логов
в вагранте поднимаем 2 машины web и log
на web поднимаем nginx
на log настраиваем центральный лог сервер на любой системе на выбор
- journald
- rsyslog
- elk

настраиваем аудит следящий за изменением конфигов нжинкса

все критичные логи с web должны собираться и локально и удаленно
все логи с nginx должны уходить на удаленный сервер (локально только критичные)
логи аудита должны также уходить на удаленную систему


* развернуть еще машину elk
и таким образом настроить 2 центральных лог системы elk И какую либо еще
в elk должны уходить только логи нжинкса
во вторую систему все остальное
Критерии оценки: 4 - если присылают только логи скриншоты без вагранта
5 - за полную настройку
6 - если выполнено задание со звездочкой

---

## **Выполнено:**

- Поднимаем стенд
```
vagrant up
```

- Проверяем критичные логи с web
```
root@stavos2:/home/stavdnb/vagrant_new/log# vagrant ssh web
Last login: Wed Oct 26 22:29:01 2022 from 10.0.2.2
[root@web ~]# logger -p crit Testing critical error
[root@web ~]# tail /var/log/messages
Oct 26 22:31:56 localhost vagrant: Testing critical error

[root@log ~]# journalctl -D /var/log/journal/remote/ --follow
-- Logs begin at Wed 2022-10-26 22:03:54 UTC. --
Oct 26 22:31:56 web vagrant[5537]: Testing critical error
```

- Проверяем логи nginx
```
[root@web vagrant]# curl localhost

[root@log vagrant]# journalctl -D /var/log/journal/remote/ --follow
Oct 26 22:34:38 web nginx[5276]: web nginx: ::1 - - [26/Oct/2022:22:34:38 +0000] "GET / HTTP/1.1" 200 4833 "-" "curl/7.29.0" "-"

[root@web vagrant]# curl localhost/not_exist

[root@log vagrant]# journalctl -D /var/log/journal/remote/ --follow
Oct 26 22:39:40 web nginx[5276]: web nginx: 2022/10/26 22:39:40 [error] 5276#5276: *2 open() "/usr/share/nginx/html/not_exist" failed (2: No such file or directory), client: ::1, server: _, request: "GET /not_exist HTTP/1.1", host: "localhost"
Oct 26 22:39:40 web nginx[5276]: web nginx: ::1 - - [26/Oct/2022:22:39:40 +0000] "GET /not_exist HTTP/1.1" 404 3650 "-" "curl/7.29.0" "-"
```
меняем прослушиваем порт на 8888 и проверяем, что крит логи и локально и удаленно
```
[root@web vagrant]# vi /etc/nginx/nginx.conf
[root@web vagrant]# systemctl restart nginx

Broadcast message from systemd-journald@web (Wed 2022-10-26 22:50:47 UTC):

nginx[5653]: 2022/10/26 22:50:47 [emerg] 5653#5653: bind() to 0.0.0.0:8888 failed (13: Permission denied)


[root@web vagrant]# tail /var/log/nginx/error.log
2022/10/26 22:50:47 [emerg] 5653#5653: bind() to 0.0.0.0:8888 failed (13: Permission denied)
```

- Проверяем логи аудита
```
[root@web vagrant]# touch /etc/nginx/nginx.conf.touch
[root@web vagrant]# ausearch -k nginx_config_changed
----
time->Wed Oct 26 22:53:45 2022
type=PROCTITLE msg=audit(1666824825.465:2174): proctitle=746F756368002F6574632F6E67696E782F6E67696E782E636F6E662E746F756368
type=PATH msg=audit(1666824825.465:2174): item=1 name="/etc/nginx/nginx.conf.touch" inode=67521919 dev=08:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:httpd_config_t:s0 objtype=CREATE cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=PATH msg=audit(1666824825.465:2174): item=0 name="/etc/nginx/" inode=67521908 dev=08:01 mode=040755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=PARENT cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=CWD msg=audit(1666824825.465:2174):  cwd="/home/vagrant"
type=SYSCALL msg=audit(1666824825.465:2174): arch=c000003e syscall=2 success=yes exit=3 a0=7ffc52c947a5 a1=941 a2=1b6 a3=7ffc52c92b20 items=2 ppid=5625 pid=5659 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=10 comm="touch" exe="/usr/bin/touch" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="nginx_config_changed"


[root@log vagrant]# ausearch -k nginx_config_changed
time->Wed Oct 26 22:53:45 2022
node=web type=PROCTITLE msg=audit(1666824825.465:2174): proctitle=746F756368002F6574632F6E67696E782F6E67696E782E636F6E662E746F756368
node=web type=PATH msg=audit(1666824825.465:2174): item=1 name="/etc/nginx/nginx.conf.touch" inode=67521919 dev=08:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:httpd_config_t:s0 objtype=CREATE cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
node=web type=PATH msg=audit(1666824825.465:2174): item=0 name="/etc/nginx/" inode=67521908 dev=08:01 mode=040755 ouid=0 ogid=0 rdev=00:00 obj=system_u:object_r:httpd_config_t:s0 objtype=PARENT cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
node=web type=CWD msg=audit(1666824825.465:2174):  cwd="/home/vagrant"
node=web type=SYSCALL msg=audit(1666824825.465:2174): arch=c000003e syscall=2 success=yes exit=3 a0=7ffc52c947a5 a1=941 a2=1b6 a3=7ffc52c92b20 items=2 ppid=5625 pid=5659 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=10 comm="touch" exe="/usr/bin/touch" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key="nginx_config_changed"
```

## **Полезное:**

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-defining_audit_rules_and_controls

https://docs.nginx.com/nginx/admin-guide/monitoring/logging/

https://www.server-world.info/en/note?os=CentOS_7&p=audit&f=2

https://bugzilla.redhat.com/show_bug.cgi?id=973697

```
# journalctl --field=_TRANSPORT - все доступные транспорты
# journalctl _TRANSPORT=syslog - то, что пришло через syslog
# journalctl _TRANSPORT=syslog -o verbose - структурированные данные
# journalctl -p crit
 -p
  emerg (0)
  alert (1) - PRIORITY=1
  crit (2) - PRIORITY=1
  err (3) - PRIORITY=3
  warning (4)
  notice (5)
  info (6)
  debug (7)
# journactl -u mysqld.service -f - отслеживание лога mysql (аналог tail -f)
# journalctl _UID=0 - все с UID 0
# journalctl --list-boots - показать время ребутов сервера (если нет директории то будет показан только последний)
# journalctl -b -2 - показать логи второго бута
```
