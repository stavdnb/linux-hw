# **Домашнее задание №21: OSPF**

## **Задание:**

OSPF
- Поднять три виртуалки
- Объединить их разными vlan
1. Поднять OSPF между машинами на базе Quagga
2. Изобразить ассиметричный роутинг
3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным

Формат сдачи:
Vagrantfile + ansible

---

## **Выполнено:**

### Схема сети:

![Схема сети](ospfv2.png)

- Поднимаем стенд:
```
vagrant up
```
```
r1# show ip route ospf
O   172.16.1.0/24 [110/100] is directly connected, enp0s8, weight 1, 00:14:21

r2# show ip route ospf
O   172.16.1.0/24 [110/100] is directly connected, enp0s8, weight 1, 00:18:00
O   172.16.3.0/24 [110/100] is directly connected, enp0s9, weight 1, 00:18:00

r3# show ip route ospf
O   172.16.3.0/24 [110/100] is directly connected, enp0s9, weight 1, 00:22:06
```
```
root@r2:~# systemctl status frr
● frr.service - FRRouting
     Loaded: loaded (/lib/systemd/system/frr.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2022-11-25 19:08:35 MSK; 1h 42min ago
       Docs: https://frrouting.readthedocs.io/en/latest/setup.html
   Main PID: 675 (watchfrr)
     Status: "FRR Operational"
      Tasks: 9 (limit: 1131)
     Memory: 24.8M
     CGroup: /system.slice/frr.service
             ├─675 /usr/lib/frr/watchfrr -d -F traditional zebra ospfd staticd
             ├─704 /usr/lib/frr/zebra -d -F traditional
             ├─709 /usr/lib/frr/ospfd -d -F traditional
             └─713 /usr/lib/frr/staticd -d -F traditional
```             
- Проверяем таблицы маршутизации на машинах:
```
r1# show ip route ospf 
Codes:       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,

O   10.10.1.0/29 [110/20] is directly connected, enp0s8, weight 1, 00:02:23
O   10.10.2.0/29 [110/20] is directly connected, enp0s9, weight 1, 00:02:23
O>* 10.10.3.0/29 [110/40] via 10.10.1.2, enp0s8, weight 1, 00:02:12
  *                       via 10.10.2.3, enp0s9, weight 1, 00:02:12

root@r2:~# ip ro
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100 
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 
10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 100 
10.10.1.0/29 dev enp0s8 proto kernel scope link src 10.10.1.2 
10.10.3.0/29 dev enp0s9 proto kernel scope link src 10.10.3.2 
10.10.20.0/29 dev enp0s10 proto kernel scope link src 10.10.20.2

```

- Проверяем настройку ассиметричной маршутизации:
```

root@r3:~# tracepath 10.10.1.1
 1?: [LOCALHOST]                      pmtu 1500
 1:  10.10.1.1                                             1.895ms reached
 1:  10.10.1.1                                             1.702ms reached
     Resume: pmtu 1500 hops 1 back 1 

```

- Восстанавливаем симметричную маршрутизацию не уменьшая цену интерфейса из предыдущего пункта:
```
root@r1:~# vtysh

Hello, this is FRRouting (version 8.4.1).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

r1# conf t
r1(config)# interface  enp0s8
r1(config-if)# ip ospf  cost  1000
r1(config-if)# exit
r1(config)# exit
r1# exit

root@r3:~# tracepath 10.10.1.1
 1?: [LOCALHOST]                      pmtu 1500
 1:  10.10.1.1                                             1.895ms reached
 1:  10.10.1.1                                             1.702ms reached
     Resume: pmtu 1500 hops 1 back 1 

18:45:25.412515 IP (tos 0xc0, ttl 1, id 12564, offset 0, flags [none], proto OSPF (89), length 68)
    10.10.3.3 > 224.0.0.5: OSPFv2, Hello, length 48
        Router-ID 10.10.5.3, Backbone Area, Authentication Type: none (0)
        Options [External]
          Hello Timer 10s, Dead Timer 40s, Mask 255.255.255.248, Priority 1
          Designated Router 10.10.3.3, Backup Designated Router 10.10.3.2
          Neighbor List:
            10.10.5.2
18:45:25.626675 IP (tos 0xc0, ttl 64, id 10979, offset 0, flags [none], proto ICMP (1), length 576)
    10.10.1.2 > 10.10.2.3: ICMP 10.10.1.2 udp port 44446 unreachable, length 556
        IP (tos 0x0, ttl 1, id 0, offset 0, flags [DF], proto UDP (17), length 1500)
    10.10.2.3.36828 > 10.10.1.2.44446: UDP, length 1472
18:45:29.923207 IP (tos 0xc0, ttl 1, id 12569, offset 0, flags [none], proto OSPF (89), length 68)
    10.10.3.2 > 224.0.0.5: OSPFv2, Hello, length 48
        Router-ID 10.10.5.2, Backbone Area, Authentication Type: none (0)
        Options [External]
          Hello Timer 10s, Dead Timer 40s, Mask 255.255.255.248, Priority 1
          Designated Router 10.10.3.3, Backup Designated Router 10.10.3.2
          Neighbor List:
            10.10.5.3
18:45:35.412124 IP (tos 0xc0, ttl 1, id 12566, offset 0, flags [none], proto OSPF (89), length 68)
    10.10.3.3 > 224.0.0.5: OSPFv2, Hello, length 48
        Router-ID 10.10.5.3, Backbone Area, Authentication Type: none (0)
        Options [External]
          Hello Timer 10s, Dead Timer 40s, Mask 255.255.255.248, Priority 1
          Designated Router 10.10.3.3, Backup Designated Router 10.10.3.2
          Neighbor List:
            10.10.5.2

```

## **Полезное:**

[Методичка от ОТУС](https://github.com/mbfx/otus-linux-adm/blob/master/dynamic_routing_guideline/README.md)
