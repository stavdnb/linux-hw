# **HW-10 Bash**

## **Задание:**
Пишем скрипт
написать скрипт для крона
который раз в час присылает на заданную почту
- X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
- Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
- все ошибки c момента последнего запуска
- список всех кодов возврата с указанием их кол-ва с момента последнего запуска

## **Выполнено:**

- Для проверки достаточно использовать [Vagrantfile](Vagrantfile)

- Результат вывода сообщения из /var/spool/mail/vagrant:

```
[root@testbash vagrant]# cat /var/spool/mail/vagrant
From root@testbash.localdomain  Sun Sep  4 19:37:57 2022
Return-Path: <root@testbash.localdomain>
X-Original-To: vagrant@localhost.localdomain
Delivered-To: vagrant@localhost.localdomain
Received: by localhost.localdomain (Postfix, from userid 0)
	id 411364087ADD; Sun,  4 Sep 2022 19:37:57 +0000 (UTC)
Date: Sun, 04 Sep 2022 19:37:57 +0000
To: vagrant@localhost.localdomain
Subject: HTTPD usage report from 14/Aug/2019:04:12:10 to
 15/Aug/2019:00:25:46
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20220904193757.411364087ADD@testbash.localdomain>
From: root@testbash.localdomain (root)

=============================================
HTTPD usage report
Analyze period is from 14/Aug/2019:04:12:10 to 15/Aug/2019:00:25:46
=============================================
10 top IP addresses
90 93.158.167.130
78 109.236.252.130
74 212.57.117.19
66 188.43.241.106
62 87.250.233.68
48 62.75.198.172
44 148.251.223.21
40 185.6.8.9
34 217.118.66.161
32 95.165.18.146
---------------------------------------------
10 top requested addresses
314 /
240 /wp-login.php
114 /xmlrpc.php
52 /robots.txt
24 /favicon.ico
18 /wp-includes/js/wp-embed.min.js?ver=5.0.4
14 /wp-admin/admin-post.php?page=301bulkoptions
14 /1
12 /wp-content/uploads/2016/10/robo5.jpg
12 /wp-content/uploads/2016/10/robo4.jpg
---------------------------------------------
All errors since the last launch
102 404
14 400
6 500
4 499
2 405
2 403
---------------------------------------------
A list of all return codes indicating their number since the last launch
996 200
190 301
102 404
36 400
6 500
4 499
2 405
2 403
2 304
---------------------------------------------

[root@testbash vagrant]#
