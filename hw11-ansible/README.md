# **HW-11 Ansible**

## **Задание:**
Первые шаги с Ansible
Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере используя Ansible необходимо развернуть nginx со следующими условиями:
- необходимо использовать модуль yum/apt
- конфигурационные файлы должны быть взяты из шаблона jinja2 с перемененными
- после установки nginx должен быть в режиме enabled в systemd
- должен быть использован notify для старта nginx после установки
- сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible

Домашнее задание считается принятым, если:
- предоставлен Vagrantfile и готовый playbook/роль ( инструкция по запуску стенда, если посчитаете необходимым )
- после запуска стенда nginx доступен на порту 8080
- при написании playbook/роли соблюдены перечисленные в задании условия
Критерии оценки: Ставим 5 если создан playbook
Ставим 6 если написана роль

---

## **Выполнено:**

Поднимаем стенд:
```
vagrant up
vagrant ssh
sudo -s
```

Проверяем работу установленного и сконфигурированного nginx:
```
root@stavos2:/home/stavdnb/vagrant_new/ansible# vagrant ssh
Last login: Sun Sep 25 16:51:50 2022 from 10.0.2.2
[vagrant@testvm ~]$ sudo -s
[root@testvm vagrant]# ss -tulnp | grep nginx
tcp    LISTEN     0      128       *:8080                  *:*                   users:(("nginx",pid=4323,fd=6),("nginx",pid=4248,fd=6))
[root@testvm vagrant]# curl http://localhost:8080
# Ansible managed
<h1> Welcome to testvm </h1>
[root@testvm vagrant]# curl -i http://localhost:8080
HTTP/1.1 200 OK
Server: nginx/1.20.1
Date: Sun, 25 Sep 2022 16:53:37 GMT
Content-Type: text/html
Content-Length: 47
Last-Modified: Sun, 25 Sep 2022 16:51:47 GMT
Connection: keep-alive
ETag: "63308723-2f"
Accept-Ranges: bytes

# Ansible managed
<h1> Welcome to testvm </h1>
```


## **Полезное:**

