# **HW-20 IPTABLES**

**ИНФОРМАЦИЯ ДЛЯ ПРОВЕРЯЮЩЕГО** 
Из-за того,что стенд создавался внутри корп. сети ( :) прошу понять и простить ) , которая использует 10.10.0.0/16, поэтому адреса из примеров изменены.

## **Задание:**
Сценарии iptables
1) реализовать knocking port
- centralRouter может попасть на ssh inetrRouter через knock скрипт
пример в материалах
2) добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост
3) запустить nginx на centralServer
4) пробросить 80й порт на inetRouter2 8080
5) дефолт в инет оставить через inetRouter

* реализовать проход на 80й порт без маскарадинга

---

## **Выполнено:**

- Поднимаем стенд:
```
vagrant up
```

- Проверяем работу knocking port:
```
root@stavos2:/home/stavdnb/linux-hw-new/linux-hw/hw20-iptables# vagrant ssh centralRouter
Last login: Thu Nov 17 00:41:03 2022 from 10.0.2.2
[vagrant@centralRouter ~]$ sudo -i
[root@centralRouter ~]# ssh vagrant@10.10.255.1
ssh: connect to host 10.10.255.1 port 22: Connection refused

[root@centralRouter ~]# cd /home/vagrant/
[root@centralRouter vagrant]# ./knock.sh

Starting Nmap 6.40 ( http://nmap.org ) at 2022-11-17 00:48 MSK
Warning: 10.10.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 10.10.255.1
Host is up (0.0010s latency).
PORT     STATE    SERVICE
8881/tcp filtered unknown
MAC Address: 08:00:27:DF:CB:0A (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.41 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2022-11-17 00:48 MSK
Warning: 10.10.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 10.10.255.1
Host is up (0.00098s latency).
PORT     STATE    SERVICE
7777/tcp filtered cbt
MAC Address: 08:00:27:DF:CB:0A (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.32 seconds

Starting Nmap 6.40 ( http://nmap.org ) at 2022-11-17 00:48 MSK
Warning: 10.10.255.1 giving up on port because retransmission cap hit (0).
Nmap scan report for 10.10.255.1
Host is up (0.00098s latency).
PORT     STATE    SERVICE
9991/tcp filtered issa
MAC Address: 08:00:27:DF:CB:0A (Cadmus Computer Systems)

Nmap done: 1 IP address (1 host up) scanned in 0.33 seconds
Warning: Permanently added '10.10.255.1' (ECDSA) to the list of known hosts.
vagrant@10.10.255.1's password: 
Last login: Thu Nov 17 00:40:58 2022 from 10.0.2.2
[vagrant@inetRouter ~]$
```

- Проверяем c хостовой машины проброс порта 10.10.10.100:8080->10.10.0.2:80
```
root@stavos2:/home/stavdnb/linux-hw-new/linux-hw/hw20-iptables# curl -I 10.10.10.100:8080
HTTP/1.1 200 OK
Server: nginx/1.20.1
Date: Wed, 16 Nov 2022 22:04:41 GMT
Content-Type: text/html
Content-Length: 4833
Last-Modified: Fri, 16 May 2014 15:12:48 GMT
Connection: keep-alive
ETag: "53762af0-12e1"
Accept-Ranges: bytes
```
## **Полезное:**

