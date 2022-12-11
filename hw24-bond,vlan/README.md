# **HW-24 Сетевые пакеты. VLAN'ы. LACP**

## **Задание:**
Строим бонды и вланы
в Office1 в тестовой подсети появляется сервера с доп интерфесами и адресами
в internal сети testLAN
- testClient1 - 10.10.10.254
- testClient2 - 10.10.10.254
- testServer1- 10.10.10.1
- testServer2- 10.10.10.1

развести вланами
testClient1 <-> testServer1
testClient2 <-> testServer2

между centralRouter и inetRouter
"пробросить" 2 линка (общая inernal сеть) и объединить их в бонд
проверить работу c отключением интерфейсов

для сдачи - вагрант файл с требуемой конфигурацией
Разворачиваться конфигурация должна через ансибл

---

## **Выполнено:**

- Поднимаем стенд:
```
vagrant up
```

- Проверяем настройку vlan:
```
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw24-bond,vlan$ vagrant ssh testClient1
Last login: Sun Dec 11 23:11:30 2022 from 10.0.2.2
[vagrant@testClient1 ~]$ nmcli con
NAME                UUID                                  TYPE      DEVICE   
Wired connection 1  cac367bc-71cb-3f9e-bd34-e496b7249609  ethernet  eth1     
System eth0         5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0     
vlan100             9237d6bd-1f74-48f7-8a59-1908888db511  vlan      eth1.100 

[vagrant@testClient1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:1f:f4:e5 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute eth0
       valid_lft 86202sec preferred_lft 86202sec
    inet6 fe80::5054:ff:fe1f:f4e5/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:e8:5f:d9 brd ff:ff:ff:ff:ff:ff
4: eth1.100@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:e8:5f:d9 brd ff:ff:ff:ff:ff:ff
    inet 10.10.10.1/24 brd 10.10.10.255 scope global noprefixroute eth1.100
       valid_lft forever preferred_lft forever
    inet6 fe80::6dd8:1db2:9011:81fc/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

[vagrant@testClient1 ~]$ ping 10.10.10.254
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=3.94 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=1.03 ms
...

root@s01-deron lab24]# vagrant ssh testServer1
Last login: Fri Jan  8 14:50:50 2021 from 10.0.2.2
[vagrant@testServer1 ~]$ nmcli con
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  a1297d59-98a7-3de4-bb83-0ca009a68620  ethernet  eth1
System eth0         5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0
vlan100             ecec62c4-bbb6-4f3c-b3a4-af17776ae437  vlan      eth1.100

[vagrant@testServer1 ~]$ sudo -s

[root@testServer1 vagrant]# tcpdump -nvvv -ieth1.100 icmp
tcpdump: listening on eth1.100, link-type EN10MB (Ethernet), capture size 262144 bytes
15:00:28.714010 IP (tos 0x0, ttl 64, id 22050, offset 0, flags [DF], proto ICMP (1), length 84)
    10.10.10.1 > 10.10.10.254: ICMP echo request, id 3264, seq 127, length 64
15:00:28.714042 IP (tos 0x0, ttl 64, id 28059, offset 0, flags [none], proto ICMP (1), length 84)
    10.10.10.254 > 10.10.10.1: ICMP echo reply, id 3264, seq 127, length 64
15:00:29.715034 IP (tos 0x0, ttl 64, id 22942, offset 0, flags [DF], proto ICMP (1), length 84)

stavdnb@stavos2:~/linux-hw-new/linux-hw/hw24-bond,vlan$ vagrant ssh testServer1
Last login: Sun Dec 11 23:11:29 2022 from 10.0.2.2
[vagrant@testServer1 ~]$ sudo -i
[root@testServer1 ~]# nmcli con
NAME                UUID                                  TYPE      DEVICE   
System eth0         5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0     
vlan100             9cfc976f-66c2-4c5c-b7b2-aba87e55b764  vlan      eth1.100
[vagrant@testClient2 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:4d:77:d3 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85702sec preferred_lft 85702sec
    inet6 fe80::5054:ff:fe4d:77d3/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:1b:39:0c brd ff:ff:ff:ff:ff:ff
    inet6 fe80::60a1:6388:55b8:584d/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: eth1.101@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:1b:39:0c brd ff:ff:ff:ff:ff:ff
    inet 10.10.10.1/24 brd 10.10.10.255 scope global noprefixroute eth1.101
       valid_lft forever preferred_lft forever
    inet6 fe80::9d6a:a921:567b:e4c/64 scope link noprefixroute
       valid_lft forever preferred_lft forever

[vagrant@testClient2 ~]$ ping 10.10.10.254
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=0.612 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=0.447 ms
64 bytes from 10.10.10.254: icmp_seq=3 ttl=64 time=0.409 ms

[root@testServer1 ~]# tcpdump -nvvv -i eth1.100 icmp
dropped privs to tcpdump
tcpdump: listening on eth1.100, link-type EN10MB (Ethernet), capture size 262144 bytes
23:20:15.274078 IP (tos 0x0, ttl 64, id 55895, offset 0, flags [DF], proto ICMP (1), length 84)
    10.10.10.1 > 10.10.10.254: ICMP echo request, id 4285, seq 1, length 64
23:20:15.274127 IP (tos 0x0, ttl 64, id 15814, offset 0, flags [none], proto ICMP (1), length 84)
    10.10.10.254 > 10.10.10.1: ICMP echo reply, id 4285, seq 1, length 64
23:20:16.275735 IP (tos 0x0, ttl 64, id 56437, offset 0, flags [DF], proto ICMP (1), length 84)

stavdnb@stavos2:~/linux-hw-new/linux-hw/hw24-bond,vlan$ vagrant ssh testClient2
Last login: Sun Dec 11 23:11:29 2022 from 10.0.2.2
[vagrant@testClient2 ~]$ nmcli con
NAME                UUID                                  TYPE      DEVICE   
System eth0         5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0     
vlan101             d4e3ffb7-6bcc-4c0c-89a0-136bb6be015c  vlan      eth1.101

[vagrant@testClient2 ~]$ ip a | grep eth1
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
4: eth1.101@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    inet 10.10.10.1/24 brd 10.10.10.255 scope global noprefixroute eth1.101

[vagrant@testClient2 ~]$ ping 10.10.10.254
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=2.19 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=1.18 ms

stavdnb@stavos2:~/linux-hw-new/linux-hw/hw24-bond,vlan$ vagrant ssh testServer2
Last login: Sun Dec 11 23:11:30 2022 from 10.0.2.2
[vagrant@testServer2 ~]$ sudo -i
[root@testServer2 ~]# nmcli con
NAME                UUID                                  TYPE      DEVICE   
System eth0         5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0     
vlan101             964883a0-048b-4ec3-ba33-c92404d7580c  vlan      eth1.101

[root@testServer2 ~]# tcpdump -nvvv -ieth1.101 icmp
dropped privs to tcpdump
tcpdump: listening on eth1.101, link-type EN10MB (Ethernet), capture size 262144 bytes
23:25:45.809995 IP (tos 0x0, ttl 64, id 54354, offset 0, flags [DF], proto ICMP (1), length 84)
    10.10.10.1 > 10.10.10.254: ICMP echo request, id 4283, seq 1, length 64
23:25:45.810042 IP (tos 0x0, ttl 64, id 38116, offset 0, flags [none], proto ICMP (1), length 84)

```

- Проверяем настройку бонда:
```
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw24-bond,vlan$ vagrant ssh inetRouter
Last login: Sun Dec 11 23:11:21 2022 from 10.0.2.2
[vagrant@inetRouter ~]$ nmcli con
NAME         UUID                                  TYPE      DEVICE 
System eth0  5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0   
Team0        13a514ee-1f4d-4ab4-afbb-ee9568a269f6  bond      Team0  
Team-Port0   4fa6ce4e-cc0e-494d-9020-98b46ae33364  ethernet  eth1   
Team-Port1   75d5af83-01ef-47e0-8982-b6aeb0d5a627  ethernet  eth2  
[vagrant@inetRouter ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:1f:f4:e5 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute eth0
       valid_lft 84835sec preferred_lft 84835sec
    inet6 fe80::5054:ff:fe1f:f4e5/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master Team0 state UP group default qlen 1000
    link/ether 08:00:27:08:f5:bc brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master Team0 state UP group default qlen 1000
    link/ether 08:00:27:08:f5:bc brd ff:ff:ff:ff:ff:ff
5: Team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:08:f5:bc brd ff:ff:ff:ff:ff:ff
    inet 10.10.255.1/30 brd 10.10.255.3 scope global noprefixroute Team0
       valid_lft forever preferred_lft forever
    inet6 fe80::70b:a0dd:6ffb:d1f4/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

[vagrant@inetRouter ~]$ ping  10.10.255.2
PING 10.10.255.2 (10.10.255.2) 56(84) bytes of data.
64 bytes from 10.10.255.2: icmp_seq=1 ttl=64 time=1.20 ms
64 bytes from 10.10.255.2: icmp_seq=2 ttl=64 time=2.15 ms
64 bytes from 10.10.255.2: icmp_seq=3 ttl=64 time=1.04 ms

...
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw24-bond,vlan$ vagrant ssh centralRouterLast login: Sun Dec 11 23:11:22 2022 from 10.0.2.2
[vagrant@centralRouter ~]$ sudo -i
[root@centralRouter ~]# nmcli con
NAME                UUID                                  TYPE      DEVICE   
Team0               63da41f0-809c-4e2d-805e-a17965e42c2e  bond      Team0    
System eth0         5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0     
vlan100             01d963b3-5f14-40a7-9643-3011dfa13cb2  vlan      eth3.100 
vlan101             6d985df4-a8cb-4c70-b3f2-33a05f349292  vlan      eth3.101 
Wired connection 1  b6b99aa8-a42c-3a84-aa41-5707d84ddfb5  ethernet  eth1     
Wired connection 3  86be8fcd-b288-3553-8606-053b2d27ca42  ethernet  eth3     
Team-Port1          15c860d9-b7ec-40ee-924f-000f444010ae  ethernet  eth2  

[root@centralRouter ~]# tcpdump -nvvv -iTeam0 icmp
dropped privs to tcpdump
tcpdump: listening on Team0, link-type EN10MB (Ethernet), capture size 262144 bytes
23:30:41.152163 IP (tos 0x0, ttl 64, id 61987, offset 0, flags [DF], proto ICMP (1), length 84)
    10.10.255.1 > 10.10.255.2: ICMP echo request, id 5778, seq 1, length 64
23:30:41.152209 IP (tos 0x0, ttl 64, id 32525, offset 0, flags [none], proto ICMP (1), length 84)
    10.10.255.2 > 10.10.255.1: ICMP echo reply, id 5778, seq 1, length 64
23:30:42.155034 IP (tos 0x0, ttl 64, id 62244, offset 0, flags [DF], proto ICMP (1), length 84)


[root@centralRouter ~]# ip l set down eth1
[root@centralRouter ~]# ip a

3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
    link/ether 08:00:27:1e:72:b7 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master Team0 state UP group default qlen 1000
    link/ether 08:00:27:21:aa:d1 brd ff:ff:ff:ff:ff:ff
16: Team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:21:aa:d1 brd ff:ff:ff:ff:ff:ff
    inet 10.10.255.2/30 brd 10.10.255.3 scope global noprefixroute Team0
       valid_lft forever preferred_lft forever
    inet6 fe80::5330:885:1779:6c17/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
[root@centralRouter ~]# tcpdump -nvvv -iTeam0 icmp
dropped privs to tcpdump
tcpdump: listening on Team0, link-type EN10MB (Ethernet), capture size 262144 bytes
23:45:45.045951 IP (tos 0x0, ttl 64, id 38190, offset 0, flags [DF], proto ICMP (1), length 84)
    10.10.255.1 > 10.10.255.2: ICMP echo request, id 5789, seq 1, length 64
23:45:45.045995 IP (tos 0x0, ttl 64, id 1791, offset 0, flags [none], proto ICMP (1), length 84)
    10.10.255.2 > 10.10.255.1: ICMP echo reply, id 5789, seq 1, length 64

```

## **Полезное:**

