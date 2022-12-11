# **Домашнее задание №23: DNS- настройка и обслуживание**

## **Задание:**

настраиваем split-dns
взять стенд https://github.com/erlong15/vagrant-bind
добавить еще один сервер client2
завести в зоне dns.lab
имена
web1 - смотрит на клиент1
web2 смотрит на клиент2

завести еще одну зону newdns.lab
завести в ней запись
www - смотрит на обоих клиентов

настроить split-dns
клиент1 - видит обе зоны, но в зоне dns.lab только web1

клиент2 видит только dns.lab

*) настроить все без выключения selinux
Критерии оценки: 4 - основное задание сделано, но есть вопросы
5 - сделано основное задание
6 - выполнено задания со звездочкой

---

## **Выполнено:**

#### Как поднять стенд
```
vagrant up
```

#### Проверяем на client:
```
[root@client ~]# date
Sun 11 Dec 16:43:48 UTC 2022

[root@client ~]# ping www.newdns.lab
PING www.newdns.lab (10.10.50.15) 56(84) bytes of data.
64 bytes from web1.dns.lab (10.10.50.15): icmp_seq=1 ttl=64 time=0.032 ms
^C

[root@client ~]# ping web1.dns.lab
PING web1.dns.lab (10.10.50.15) 56(84) bytes of data.
64 bytes from web1.dns.lab (10.10.50.15): icmp_seq=1 ttl=64 time=0.028 ms
^C

ping web2.dns.lab
ping: web2.dns.lab: Name or service not known

```


#### Проверяем на client2:
```

[root@client2 ~]# ping www.newdns.lab
ping: www.newdns.lab: Name or service not known
[root@client2 ~]# ping web1.dns.lab
PING web1.dns.lab (10.10.50.15) 56(84) bytes of data.
64 bytes from web1.dns.lab (10.10.50.15): icmp_seq=1 ttl=64 time=3.08 ms
root@client2 ~]# ping web2.dns.lab
PING web2.dns.lab (10.10.50.22) 56(84) bytes of data.
64 bytes from web2.dns.lab (10.10.50.22): icmp_seq=1 ttl=64 time=0.031 ms

```
*
**selinux сконфигурирован**

## **Полезное:**


