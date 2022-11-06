# **HW-19 DHCP,PXE**


## **Задание:**
Настройка PXE сервера для автоматической установки
Цель: Отрабатываем навыки установки и настройки DHCP, TFTP, PXE загрузчика и автоматической загрузки
1. Следуя шагам из документа https://docs.centos.org/en-US/8-docs/advanced-install/assembly_preparing-for-a-network-install установить и настроить загрузку по сети для дистрибутива CentOS8
В качестве шаблона воспользуйтесь репозиторием https://github.com/nixuser/virtlab/tree/main/centos_pxe
2. Поменять установку из репозитория NFS на установку из репозитория HTTP
3. Настроить автоматическую установку для созданного kickstart файла (*) Файл загружается по HTTP
* 4. автоматизировать процесс установки Cobbler cледуя шагам из документа https://cobbler.github.io/quickstart/

Критерии оценки: 
1. ссылка на репозиторий github.
2. Vagrantfile с шагами установки необходимых компонентов
3. Исходный код scripts для настройки сервера (если необходимо)
4. Если какие-то шаги невозможно или сложно автоматизировать, то инструкции по ручным шагам для настройки

---

## **Выполнено:**
- Готовим стенд по методичке, копирую файлы из ручного вариант в темплейты

- настраиваем авто-установку с помощью кикстартер фала конфигурации и кидаем его на хост через ansible 

- Настраиваем в Vagrantfile provisioning через ansible 

- Поднимаем стенд:

```
vagrant up
```
- Проверяем доступность 

```
stavdnb@stavos2:~$ curl -I 127.0.0.1:8081/centos8/ks.cfg
HTTP/1.1 200 OK
Date: Sun, 06 Nov 2022 23:22:10 GMT
Server: Apache/2.4.37 (centos)
Last-Modified: Sun, 06 Nov 2022 22:40:25 GMT
ETag: "716-5ecd4fe38d72e"
Accept-Ranges: bytes
Content-Length: 1814
```
- скриншоты с virtualbox не смог сделать, нет десктопной версии на работе))

## **Полезное:**

[Preparing to install from the network using PXE](https://docs.centos.org/en-US/8-docs/advanced-install/assembly_preparing-for-a-network-install/)

**IMAGE**

https://download.fosc.space/seeding/CentOS-8.4.2105-x86_64-dvd1/https://download.fosc.space/seeding/CentOS-8.4.2105-x86_64-dvd1/
