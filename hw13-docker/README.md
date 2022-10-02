# **HW-13 Docker** 

## **Задание:**
Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен
отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx)
Определите разницу между контейнером и образом
Вывод опишите в домашнем задании.
Ответьте на вопрос: Можно ли в контейнере собрать ядро?
Собранный образ необходимо запушить в docker hub и дать ссылку на ваш
репозиторий.

Задание со * (звездочкой)
Создайте кастомные образы nginx и php, объедините их в docker-compose.
После запуска nginx должен показывать php info.
Все собранные образы должны быть в docker hub

---

## **Выполнено:**


### **1. Создан свой кастомный образ nginx на базе alpine.**

- Для создания образа подготовлен следующий [Dockerfile](Dockerfile).

- Создаем образ:
```
docker build -t stavdock/nginx:custom .
```
- Запускаем контейнер и проверяем работу:
```
docker run -d -p 80:80 stavdock/nginx:custom


root@stavos2:/home/stavdnb/linux-hw-new/linux-hw# date 
Sun  2 Oct 19:16:22 UTC 2022
root@stavos2:/home/stavdnb/linux-hw-new/linux-hw# curl localhost
<html>
<head>
<title>HELLO MOTO</title>
</head>
<body>
<h1>Welcome to Homework </h1>
</body>
</html>
```

- Выкладываем в [Docker Hub](https://hub.docker.com/r/stavdock/nginx)


### **2. Выводы про разницу между контейнером и образом:**
Образ докера являются основой контейнеров. 
Образ - это упорядоченная коллекция изменений корневой файловой системы и соответствующих параметров 
выполнения для использования в среде выполнения контейнера. 
Образ не имеет состояния и никогда не изменяется.

**Контейнер - это исполняемый (остановленный) экземпляр образа docker.** 

Контейнер Docker состоит из:
- Docker образа 
- Среды выполнения
- Стандартного набора инструкций
Концепция заимствована из морских контейнеров, которые определяют стандарт для доставки товаров по всему миру. 
Docker определяет стандарт для отправки программного обеспечения.

(*) Взято из [Docker Glossary](https://docs.docker.com/glossary/)

Хотелось бы еще добавить, что из одного образа можно запустить множество контейнеров.

### **3. Ответьте на вопрос: Можно ли в контейнере собрать ядро?**

- Собрать возможно - [https://github.com/moul/docker-kernel-builde](https://github.com/moul/docker-kernel-builder). 

### **4. Задание со * (звездочкой)**

- Запускаем и проверяем
```
root@stavos2:/home/stavdnb/linux-hw-new/linux-hw/hw13-docker/nginx-php-fpm# docker-compose up -d
Creating network "nginx-php-fpm_front_end" with the default driver
Creating phpfpm ... done
Creating nginx  ... done
```

```
root@stavos2:/home/stavdnb/linux-hw-new/linux-hw/hw13-docker/nginx-php-fpm# curl localhost | grep "PHP Version"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<a href="http://www.php.net/"><img border="0" y5PnsrJ136bUa8pxu69BklmANWwDRkgR1wmwVaglyi3Nz6JLQ+ZG5NxQsgNdAhmIfJN7wxgoWg9fxzPQ+c/g9YAIXgeUKCyipJO4uR/wswAOIwB/5IgxvbAAAAAElFTkSuQmCC" alt="PHP logo" /></a><h1 class="p">PHP Version 8.1.10</h1>
<tr><td class="e">PHP Version </td><td class="v">8.1.10 </td></tr>
100 83647    0 83647    0     0  13.2M      0 --:--:-- --:--:-- --:--:-- 13.2M
```




## **Полезное:**

https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

https://habr.com/ru/company/ruvds/blog/439980/