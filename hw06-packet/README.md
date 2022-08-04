
 - доставлен компилятор gcc
 - установлена требуемая версия openssl , с игнорированием протухшего серта

 - Протестировано, работает

```
root@Graylog2 ~]# systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2022-08-04 21:42:48 MSK; 6min ago
     Docs: http://nginx.org/en/docs/
  Process: 106267 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
 Main PID: 106268 (nginx)
   CGroup: /system.slice/nginx.service
           ├─106268 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
           └─106269 nginx: worker process
```
инициировали репозиторий

```
[root@Graylog2 ~]# createrepo /usr/share/nginx/html/repo
Spawning worker 0 with 1 pkgs
Spawning worker 1 with 1 pkgs
Spawning worker 2 with 0 pkgs
Spawning worker 3 with 0 pkgs

Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs complete
```
ну и финалочка

```
[root@Graylog2 yum.repos.d]# yum repolist enabled | grep otus
otus                        otus-linux                                         2
[root@Graylog2 yum.repos.d]# yum list | grep otus
percona-release.noarch                   0.1-6                           otus
[root@Graylog2 yum.repos.d]# yum install percona-release -y
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.axelname.ru
 * epel: mirror.logol.ru
 * extras: mirror.corbina.net
 * updates: centos.linux.edu.lv
Resolving Dependencies
--> Running transaction check
---> Package percona-release.noarch 0:0.1-6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=====================================================================================================================
 Package                            Arch                      Version                  Repository               Size
=====================================================================================================================
Installing:
 percona-release                    noarch                    0.1-6                    otus                     14 k

Transaction Summary
=====================================================================================================================
Install  1 Package

Total download size: 14 k
Installed size: 16 k
Downloading packages:
percona-release-0.1-6.noarch.rpm                                                              |  14 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : percona-release-0.1-6.noarch                                                                      1/1
  Verifying  : percona-release-0.1-6.noarch                                                                      1/1

Installed:
  percona-release.noarch 0:0.1-6

Complete!
```