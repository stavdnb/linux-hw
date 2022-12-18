# **HW-25 LDAP**

## **Задание:**
LDAP
1. Установить FreeIPA;
2. Написать Ansible playbook для конфигурации клиента;
3*. Настроить аутентификацию по SSH-ключам;
4**. Firewall должен быть включен на сервере и на клиенте.

В git - результирующий playbook.

---

## **Выполнено:**

#### Разворачиваем стенд:

```
vagrant up
```

#### Проверяем статус FirewallD и пробуем завести пользователя на ipa сервере:
```
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw25-ldap$ vagrant ssh ipaserver
Last login: Sun Dec 18 16:25:06 2022 from 10.0.2.2
[vagrant@ipaserver ~]$ sudo -i
[root@ipaserver ~]# systemctl status firewalld.service
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2022-12-18 16:22:44 MSK; 5min ago
     Docs: man:firewalld(1)
 Main PID: 706 (firewalld)
    Tasks: 2 (limit: 25005)
   Memory: 37.7M
   CGroup: /system.slice/firewalld.service
           └─706 /usr/libexec/platform-python -s /usr/sbin/firewalld --nofork --nopid

Dec 18 16:22:40 ipaserver.otus.lab systemd[1]: Starting firewalld - dynamic firewall daemon...


[root@ipaserver ~]# ipa user-add --first="Harry" --last="Potter" --cn="Harry Potter" --password magic2 --shell="/bin/bash"
Password: 
Enter Password again to verify: 
------------------
Added user "magic2"
------------------
  User login: magic2
  First name: Harry
  Last name: Potter
  Full name: Harry Potter
  Display name: Harry Potter
  Initials: HP
  Home directory: /home/magic2
  GECOS: Harry Potter
  Login shell: /bin/bash
  Principal name: magic2@OTUS.LAB
  Principal alias: magic2@OTUS.LAB
  User password expiration: 20221218150135Z
  Email address: magic2@otus.lab
  UID: 1057400003
  GID: 1057400003
  Password: True
  Member of groups: ipausers
  Kerberos keys available: True
```

#### Проверяем на клиенте:

```
[vagrant@ipaclient ~]$ su magic2
Password: 
Password expired. Change your password now.
Current Password: 
New password: 
Retype new password: 
bash-4.4$
```

#### Добавляем публичный ключ для jpattan через веб - консоль:

через роль ipaserver в ansible - name ipa user add


#### Проверяем с хостовой машины, пробуя зайти на client:
```
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw25-ldap$ ssh -i ~/.ssh/appuser director@127.0.0.1 -p 2200
Last login: Sun Dec 18 19:33:52 2022 from 10.0.2.2

[director@ipaclient ~]$ 
```

## **Полезное:**

