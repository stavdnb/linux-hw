# **HW-14 Prometheus** 

## **Задание:**
Настройка мониторинга
Настроить дашборд с 4-мя графиками
1) память
2) процессор
3) диск
4) сеть

настроить на одной из систем
- zabbix (использовать screen (комплексный экран))
- prometheus - grafana

* использование систем примеры которых не рассматривались на занятии
- список возможных систем был приведен в презентации

в качестве результата прислать скриншот экрана - дашборд должен содержать в названии имя приславшего

---

## **Выполнено:**


1. В папке server лежит docker-compose файл, который поднимает сервисы, и находятся папки пробрасываемые в контейнер.

В данном наборе есть все нужное для мониторинга хостов и контейнеров, а также оповещение alertmanager.

Для развертывания используем ** docker-compose up -d ** 

```
stavdnb@stavos2:~/linux-hw-new/linux-hw/hw14-prometheus/server$ docker ps
CONTAINER ID   IMAGE                              COMMAND                  CREATED          STATUS                    PORTS                                                                                                                                                                            NAMES
a068dba8e262   gcr.io/cadvisor/cadvisor:v0.43.0   "/usr/bin/cadvisor -…"   46 seconds ago   Up 41 seconds (healthy)   8080/tcp                                                                                                                                                                         cadvisor
380541cd5c25   caddy:2.3.0                        "caddy run --config …"   46 seconds ago   Up 41 seconds             80/tcp, 443/tcp, 0.0.0.0:3000->3000/tcp, :::3000->3000/tcp, 0.0.0.0:9090-9091->9090-9091/tcp, :::9090-9091->9090-9091/tcp, 2019/tcp, 0.0.0.0:9093->9093/tcp, :::9093->9093/tcp   caddy
4b1dc70f60e8   prom/node-exporter:v1.3.0          "/bin/node_exporter …"   46 seconds ago   Up 41 seconds             9100/tcp                                                                                                                                                                         nodeexporter
ccabd5b13e56   prom/prometheus:v2.31.1            "/bin/prometheus --c…"   46 seconds ago   Up 41 seconds             9090/tcp                                                                                                                                                                         prometheus
c5672280b050   prom/pushgateway:v1.4.2            "/bin/pushgateway"       46 seconds ago   Up 41 seconds             9091/tcp                                                                                                                                                                         pushgateway
44660e6efc87   prom/alertmanager:v0.23.0          "/bin/alertmanager -…"   46 seconds ago   Up 41 seconds             9093/tcp                                                                                                                                                                         alertmanager
d416921ee661   grafana/grafana:8.3.0              "/run.sh"                46 seconds ago   Up 41 seconds             3000/tcp                                                                                                                                                                         grafana
```

2. На хост с которого собираемся собирать данные, также запускаем docker-compose файл, с заранее описанными сервисами, в данном примере только node exporter
```
rem-sdo1@rem-s1:~$ docker ps
CONTAINER ID   IMAGE                              COMMAND                  CREATED        STATUS                  PORTS                    NAMES
aabde1346eb9   prom/node-exporter:v1.3.0          "/bin/node_exporter …"   25 seconds ago   21 seconds ago            0.0.0.0:9501->9100/tcp   nodeexporter

```

3. Заходим в grafana. Настраиваем Data source и [Dashboard](https://grafana.com/grafana/dashboards/12486).

![image](https://user-images.githubusercontent.com/85901437/195193053-6717dde6-7b40-44e9-8933-2980950449b1.png)

## **Полезное:**

