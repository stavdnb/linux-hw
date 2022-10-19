# **HW-15 PAM**

## **Задание:**
1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников
* дать конкретному пользователю права работать с докером
и возможность рестартить докер сервис

---

## **Выполнено:**

- Для проверки работы запрета всем пользователям входить в систему
задаем выходные дни в файле  [pam_role/vars/main.yml](pam_role/vars/main.yml).
Например, сегодня пятница, считаем что 5 и 6 дни недели - выходные.

Так как на момент проверки у нас четверг ,то меняем в файле [pam_role/vars/main.yml](pam_role/vars/main.yml)
```
saturday: 4
sunday: 5
```

- Поднимаем стенд:
```
vagrant up
```

- Проверяем. user1 не входит в группу admin, user2 входит в группу admin. 
Пароль для обоих пользователей и ansible-vault указан в файле passwd
```
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw15-pam$ date
Thu 20 Oct 00:23:10 MSK 2022
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw15-pam$ ssh user1@10.10.10.101
user1@10.10.10.101's password:
/usr/local/bin/test_login.sh failed: exit code 1
Connection closed by 10.10.10.101 port 22
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw15-pam$ ssh user2@10.10.10.101
user2@10.10.10.101's password:
Last login: Thu Oct 20 00:12:20 2022 from 10.10.10.1
[user2@testpam ~]$
``` 
так как у на все еще четверг , добавляем user1 в группу админ, заходим под ним и проверяем работу настроенной через Polkitd возможность  рестартить docker

```
usermod -aG admin user1
```
результат
```
[user1@testpam ~]$ service docker status | grep PID
Redirecting to /bin/systemctl status docker.service
 Main PID: 4957 (dockerd)
[user1@testpam ~]$ service docker restart
Redirecting to /bin/systemctl restart docker.service
[user1@testpam ~]$ service docker status | grep PID
Redirecting to /bin/systemctl status docker.service
 Main PID: 27129 (dockerd)
```

