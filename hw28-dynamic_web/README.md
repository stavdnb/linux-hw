# **HW-28: Динамический веб**

## **Задание:**
развернуть стенд с веб приложениями в vagrant
Варианты стенда

nginx + php-fpm (laravel/wordpress) + python (flask/django) + js(react/angular)

nginx + java (tomcat/jetty/netty) + go + ruby

можно свои комбинации

Реализации на выбор
- на хостовой системе через конфиги в /etc
- деплой через docker-compose

Для усложнения можно попросить проекты у коллег с курсов по разработке

К сдаче примается
vagrant стэнд с проброшенными на локалхост портами
каждый порт на свой сайт
через нжинкс
---

## **Выполнено:**

#### Поднимаем стенд:
```
vagrant up
```

#### Docker не брал, так активно использую на работе, моя связка vagrant+ansible, stack (react,laravel,flask,nginx) 

#### Проверяем:
curl 192.168.213.28:8081/dweb
<h1>Hello MOTO!!!</h1><p>Powered by Laravel</p>

curl 192.168.213.28:8082
<h1 style='color:blue'>Hello MOTO!!!</h1><p>Powered by Flask</p>

curl 192.168.213.28:8083
<!doctype html><html lang="en"><head><meta charset="utf-8"/><link rel="icon" href="/favicon.ico"/><meta name="viewport" content="width=device-width,initial-scale=1"/><meta name="theme-color" content="#000000"/><meta name="description" content="Web site created using create-react-app"/><link rel="apple-touch-icon" href="/logo192.png"/><link rel="manifest" href="/manifest.json"/><title>React App</title><script defer="defer" src="/static/js/main.106c5f57.js"></script><link href="/static/css/main.073c9b0a.css" rel="stylesheet"></head><body><noscript>You need to enable JavaScript to run this app.</noscript><div id="root"></div></body></html>


## **Полезное:**

https://laravel.su/docs/8.x/routing