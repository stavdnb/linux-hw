# **Домашнее задание №8: Инициализация системы. Systemd**

 **Задание:**

**Выполнение:**

Поднимаем стенд:
```
vagrant up
vagrant ssh
sudo -s
```

1. Создание сервиса, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig

Проверяем работу сервиса и видим что раз в 30 секунд:
```
root@stavos2:/home/stavdnb/vagrant_new/systemd# vagrant ssh
Last login: Wed Aug 17 19:41:54 2022 from 10.0.2.2
[vagrant@newvm ~]$ systemctl status watchlog.timer
● watchlog.timer - Run watchlog script every 30 second
   Loaded: loaded (/etc/systemd/system/watchlog.timer; enabled; vendor preset: disabled)
   Active: active (waiting) since Wed 2022-08-17 19:41:49 UTC; 1min 16s ago

[root@newvm vagrant]# tail -f /var/log/messages
Aug 17 19:45:41 newvm start-jira.sh: Server startup logs are located in /opt/atlassian/jira/logs/catalina.out
Aug 17 19:45:41 newvm start-jira.sh: Tomcat started.
Aug 17 19:45:41 newvm systemd: Started Atlassian Jira.
Aug 17 19:46:21 newvm systemd: Starting My watchlog service...
```

2. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами.
Для запуска нескольких экземпляров сервиса будем использовать шаблон httpd@ в конфигурации файла окружений.

Проверяем работу экземпляров сервиса:
```
[root@newvm vagrant]# systemctl status httpd@first
● httpd@first.service - The Apache HTTP Server
   Loaded: loaded (/etc/systemd/system/httpd@.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2022-08-17 19:41:51 UTC; 8min ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 4695 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /system.slice/system-httpd.slice/httpd@first.service
           ├─4695 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           ├─4696 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           ├─4698 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           ├─4699 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           ├─4700 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           ├─4701 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND
           └─4702 /usr/sbin/httpd -f conf/first.conf -DFOREGROUND

[root@newvm vagrant]# systemctl status httpd@second
● httpd@second.service - The Apache HTTP Server
   Loaded: loaded (/etc/systemd/system/httpd@.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2022-08-17 19:41:53 UTC; 10min ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 4809 (httpd)
   Status: "Total requests: 0; Current requests/sec: 0; Current traffic:   0 B/sec"
   CGroup: /system.slice/system-httpd.slice/httpd@second.service
           ├─4809 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           ├─4810 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           ├─4811 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           ├─4812 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           ├─4813 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           ├─4814 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND
           └─4815 /usr/sbin/httpd -f conf/second.conf -DFOREGROUND

[root@newvm vagrant]# sudo ss -tnulp | grep httpd
tcp    LISTEN     0      128    [::]:9000               [::]:*                   users:(("httpd",pid=4815,fd=4),("httpd",pid=4814,fd=4),("httpd",pid=4813,fd=4),("httpd",pid=4812,fd=4),("httpd",pid=4811,fd=4),("httpd",pid=4810,fd=4),("httpd",pid=4809,fd=4))
tcp    LISTEN     0      128    [::]:80                 [::]:*                   users:(("httpd",pid=4702,fd=4),("httpd",pid=4701,fd=4),("httpd",pid=4700,fd=4),("httpd",pid=4699,fd=4),("httpd",pid=4698,fd=4),("httpd",pid=4696,fd=4),("httpd",pid=4695,fd=4))

```

3. Создание unit-файл(ы) для сервиса Jira:

Проверяем работу сервиса:
```
[root@newvm vagrant]# systemctl status jira
● jira.service - Atlassian Jira
   Loaded: loaded (/etc/systemd/system/jira.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2022-08-17 19:55:45 UTC; 1min 59s ago
  Process: 5788 ExecStart=/opt/atlassian/jira/bin/start-jira.sh (code=exited, status=0/SUCCESS)
 Main PID: 5821 (java)
   CGroup: /system.slice/jira.service
           └─5821 /opt/atlassian/jira/jre//bin/java -Djava.util.logging.config.file=/opt/atlassian/jira/co...


```

Проверяем работу опции Restart=on-failure ( т.к. нам необходимо, чтобы сервис перезапускался при падении):
```
[root@newvm vagrant]# kill -9 6107
[root@newvm vagrant]# systemctl status jira
● jira.service - Atlassian Jira
   Loaded: loaded (/etc/systemd/system/jira.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2022-08-17 20:04:33 UTC; 11s ago
  Process: 6128 ExecStart=/opt/atlassian/jira/bin/start-jira.sh (code=exited, status=0/SUCCESS)
 Main PID: 6321 (java)
   CGroup: /system.slice/jira.service
           └─6321 /opt/atlassian/jira/jre//bin/java -Djava.util.logging.config.file=/opt/atlassian/jira/co...
```

Проверяем установку Limit* для сервиса:
```
[root@newvm vagrant]# cat /proc/6321/limits
Limit                     Soft Limit           Hard Limit           Units     
Max cpu time              unlimited            unlimited            seconds   
Max file size             unlimited            unlimited            bytes     
Max data size             10737418240          21474836480          bytes     
Max stack size            8388608              unlimited            bytes     
Max core file size        0                    unlimited            bytes     
Max resident set          unlimited            unlimited            bytes     
Max processes             657                  657                  processes 
Max open files            8192                 8192                 files     
Max locked memory         65536                65536                bytes     
Max address space         5368709120           6442450944           bytes     
Max file locks            unlimited            unlimited            locks     
Max pending signals       657                  657                  signals   
Max msgqueue size         819200               819200               bytes     
Max nice priority         18                   19                   
Max realtime priority     0                    0                    
Max realtime timeout      unlimited            unlimited            us   
```

## **Полезное:**
