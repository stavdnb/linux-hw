# **Домашнее задание №22: Мосты, туннели и VPN**

## **Задание:**
1. Между двумя виртуалками поднять vpn в режимах
- tun
- tap
Прочуствовать разницу.

2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку

3*. Самостоятельно изучить, поднять ocserv и подключиться с хоста к виртуалке

---

## **Выполнено:**
1. Проверка ТАР, в файле provision/group_vars/all/all.yml присваиваем переменной net_dev значение **tap** 

2. Поднимаем стенд 
```vagrant up```

3. Заходим на сервера и проверяем , что интерефейсы создались и маршруты прописались:
``` 
[vagrant@client ~]$ date
Sun Dec  4 12:12:46 UTC 2022
vagrant@client ~]$ ip a | grep -A 2 ^.: | grep tap0
4: tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 100
    inet 10.10.10.2/24 brd 10.10.10.255 scope global tap0
[vagrant@client ~]$ ip ro
default via 10.0.2.2 dev eth0 proto dhcp metric 100 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100 
10.10.10.0/24 dev tap0 proto kernel scope link src 10.10.10.2 
10.10.11.0/24 dev eth1 proto kernel scope link src 10.10.11.20 metric 101 

[root@vpnserver ~]# ip ro
default via 10.0.2.2 dev eth0 proto dhcp metric 100 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 metric 100 
10.10.10.0/24 dev tap0 proto kernel scope link src 10.10.10.1 
10.10.11.0/24 dev eth1 proto kernel scope link src 10.10.11.100 metric 101 
```

4. На openvpn клиенте запускаем iperf3 в режиме клиента и замеряем
скорость в туннеле:
```
[root@vpnserver ~]# iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.10.2, port 46192
[  5] local 10.10.10.1 port 5201 connected to 10.10.10.2 port 46194
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.01   sec  2.28 MBytes  18.8 Mbits/sec

[root@client ~]# iperf3 -c 10.10.10.1
Connecting to host 10.10.10.1, port 5201
[  5] local 10.10.10.2 port 46194 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  2.71 MBytes  22.7 Mbits/sec    3   87.7 KBytes       
[  5]   1.00-2.02   sec  3.37 MBytes  27.8 Mbits/sec    0    110 KBytes       
[  5]   2.02-3.01   sec  3.28 MBytes  27.7 Mbits/sec    2   96.8 KBytes       
[  5]   3.01-4.00   sec  3.04 MBytes  25.9 Mbits/sec    1   83.9 KBytes       
[  5]   4.00-5.00   sec  3.25 MBytes  27.2 Mbits/sec    0    107 KBytes       
[  5]   5.00-6.01   sec  3.51 MBytes  29.2 Mbits/sec    3   95.5 KBytes       
[  5]   6.01-7.01   sec  3.23 MBytes  27.2 Mbits/sec    2   83.9 KBytes       
[  5]   7.01-8.03   sec  3.24 MBytes  26.7 Mbits/sec    0    106 KBytes       
[  5]   8.03-9.01   sec  3.10 MBytes  26.5 Mbits/sec    1   94.2 KBytes       
[  5]   9.01-10.02  sec  3.35 MBytes  27.8 Mbits/sec    3   81.3 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.02  sec  32.1 MBytes  26.9 Mbits/sec   15             sender
[  5]   0.00-10.08  sec  31.8 MBytes  26.5 Mbits/sec                  receiver

iperf Done.
```

5. На openvpn сервере запускаем:
```
[root@vpnserver ~]# ping 10.10.10.2
PING 10.10.10.2 (10.10.10.2) 56(84) bytes of data.
64 bytes from 10.10.10.2: icmp_seq=1 ttl=64 time=2.21 ms
64 bytes from 10.10.10.2: icmp_seq=2 ttl=64 time=1.57 ms
```

6. На клиенте проверяем, что туннель через tap работает на L2:
```
[root@client ~]# tcpdump -i tap0 -q -e
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on tap0, link-type EN10MB (Ethernet), capture size 262144 bytes
16:21:00.313814 22:0b:37:1c:3e:49 (oui Unknown) > ea:30:0b:26:e6:23 (oui Unknown), IPv4, length 98: 10.10.10.1 > client: ICMP echo request, id 40459, seq 11, length 64
16:21:00.313844 ea:30:0b:26:e6:23 (oui Unknown) > 22:0b:37:1c:3e:49 (oui Unknown), IPv4, length 98: client > 10.10.10.1: ICMP echo reply, id 40459, seq 11, length 64
```

7. Присваиваем в файле provision/group_vars/all/all.yml переменной net_dev значение **tun** (Layer3) и выполняем провижн стенда ```vagrant provision```

8. Проверяем на сервере:
```
[vagrant@vpnserver ~]$ ip l
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:4d:77:d3 brd ff:ff:ff:ff:ff:ff
3: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN mode DEFAULT group default qlen 100
    link/none
4: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:35:27:94 brd ff:ff:ff:ff:ff:ff
```

9. Замеряем скорость на клиенте:
```
[root@client ~]# iperf3 -c 10.10.10.1
Connecting to host 10.10.10.1, port 5201
[  5] local 10.10.10.2 port 56254 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.01   sec  3.25 MBytes  26.9 Mbits/sec    7   93.8 KBytes       
[  5]   1.01-2.00   sec  3.12 MBytes  26.4 Mbits/sec    0    115 KBytes       
[  5]   2.00-3.01   sec  3.31 MBytes  27.7 Mbits/sec    2    103 KBytes       
[  5]   3.01-4.02   sec  3.32 MBytes  27.5 Mbits/sec    1   89.8 KBytes       
[  5]   4.02-5.01   sec  3.36 MBytes  28.5 Mbits/sec    0    114 KBytes       
[  5]   5.01-6.03   sec  3.26 MBytes  26.9 Mbits/sec    1    100 KBytes       
[  5]   6.03-7.01   sec  3.26 MBytes  27.9 Mbits/sec    2   85.9 KBytes       
[  5]   7.01-8.00   sec  3.29 MBytes  27.6 Mbits/sec    0    110 KBytes       
[  5]   8.00-9.01   sec  3.26 MBytes  27.1 Mbits/sec    2   97.8 KBytes       
[  5]   9.01-10.01  sec  3.34 MBytes  28.0 Mbits/sec    3   83.2 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.01  sec  32.8 MBytes  27.5 Mbits/sec   18             sender
[  5]   0.00-10.15  sec  32.5 MBytes  26.9 Mbits/sec                  receiver
iperf Done.
```
*Скорость в туннеле через TUN незначительно быстрее,если необходима L2 связанность, тогда используем TAP*

10. Запускаем на сервере:
```
[root@vpnserver ~]# ping 10.10.10.2
PING 10.10.10.2 (10.10.10.2) 56(84) bytes of data.
64 bytes from 10.10.10.2: icmp_seq=1 ttl=64 time=1.70 ms
64 bytes from 10.10.10.2: icmp_seq=2 ttl=64 time=2.03 ms
64 bytes from 10.10.10.2: icmp_seq=3 ttl=64 time=2.18 ms
```

11. Проверяем на клиенте, что tun работает только на L3:
```
tcpdump -i tun0 -q -e
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on tun0, link-type RAW (Raw IP), capture size 262144 bytes
16:44:32.949457 ip: 10.10.10.1 > client: ICMP echo request, id 4938, seq 8, length 64
16:44:32.949497 ip: client > 10.10.10.1: ICMP echo reply, id 4938, seq 8, length 64
16:44:33.011713 ip: client > ip6-allrouters: ICMP6, router solicitation, length 8
```

12. Поднимаем стенд RAS на базе OpenVPN
```
cd ras
vagrant up
```

13. Включаем клиента и смотрим состояние подключения с tail -f :
```
Sun Dec  4 21:13:43 2022 SENT CONTROL [server]: 'PUSH_REQUEST' (status=1)
Sun Dec  4 21:13:43 2022 PUSH: Received control message: 'PUSH_REPLY,route 10.10.11.0 255.255.255.0,route 10.10.10.0 255.255.255.0,topology net30,ping 10,ping-restart 120,ifconfig 10.10.10.6 10.10.10.5,peer-id 0,cipher AES-256-GCM'
Sun Dec  4 21:13:43 2022 OPTIONS IMPORT: timers and/or timeouts modified
Sun Dec  4 21:13:43 2022 OPTIONS IMPORT: --ifconfig/up options modified
Sun Dec  4 21:13:43 2022 OPTIONS IMPORT: route options modified
Sun Dec  4 21:13:43 2022 OPTIONS IMPORT: peer-id set
Sun Dec  4 21:13:43 2022 OPTIONS IMPORT: adjusting link_mtu to 1625
Sun Dec  4 21:13:43 2022 OPTIONS IMPORT: data channel crypto options modified
Sun Dec  4 21:13:43 2022 Data Channel: using negotiated cipher 'AES-256-GCM'
Sun Dec  4 21:13:43 2022 Outgoing Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Sun Dec  4 21:13:43 2022 Incoming Data Channel: Cipher 'AES-256-GCM' initialized with 256 bit key
Sun Dec  4 21:13:43 2022 ROUTE_GATEWAY 10.0.2.2/255.255.255.0 IFACE=eth0 HWADDR=08:00:27:8c:00:e6
Sun Dec  4 21:13:43 2022 TUN/TAP device tun0 opened
Sun Dec  4 21:13:43 2022 TUN/TAP TX queue length set to 100
Sun Dec  4 21:13:43 2022 /sbin/ip link set dev tun0 up mtu 1500
Sun Dec  4 21:13:43 2022 /sbin/ip addr add dev tun0 local 10.10.10.6 peer 10.10.10.5
Sun Dec  4 21:13:43 2022 /sbin/ip route add 10.10.11.0/24 via 10.10.10.5
Sun Dec  4 21:13:43 2022 /sbin/ip route add 10.10.10.0/24 via 10.10.10.5
Sun Dec  4 21:13:43 2022 WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this
Sun Dec  4 21:13:43 2022 Initialization Sequence Completed
```

## **Полезное:**

[Reference manual for OpenVPN 2.4](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/)
ДЛЯ OPENCONNECT 

https://aeb-blog.ru/linux/ustanovka-openconnect-servera-v-sentos-7/
https://itsecforu.ru/2018/09/14/настройка-openconnect-vpn-server-ocserv-на-ubuntu-16-04-17-10-с-lets-encrypt/