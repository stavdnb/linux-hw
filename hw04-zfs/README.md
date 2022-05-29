# Homework-04 ZFS
 Собираем группы из дисков 

все действия делаем под рутом

 sudo -i

    lsblk
    zpool create otus1 mirror /dev/sdb /dev/sdc
    zpool create otus2 mirror /dev/sdd /dev/sde
    zpool create otus3 mirror /dev/sdf /dev/sdg
    zpool create otus4 mirror /dev/sdh /dev/sdi
    zpool list



Устанавливаем сжатие на получившиеся группы

    zfs set compression=lzjb otus1
    zfs set compression=lz4 otus2
    zfs set compression=gzip-9 otus3
    zfs set compression=zle otus4


    zfs get all | grep compression
```
[root@server ~]# zfs get all | grep compression
otus1  compression           lzjb                   local
otus2  compression           lz4                    local
otus3  compression           gzip-9                 local
otus4  compression           zle                    local
```
скачиваем файл для каждой
```
    for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
```

 ls -l /otus*

 zfs list

```
[root@server ~]# zfs list
NAME    USED  AVAIL     REFER  MOUNTPOINT
otus1  21.6M   810M     21.5M  /otus1
otus2  17.6M   814M     17.6M  /otus2
otus3  10.8M   821M     10.7M  /otus3
otus4  39.0M   793M     39.0M  /otus4
```

**Просмотреть список пулов**
 zpool list
```
[root@server ~]# zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
otus1   960M  21.6M   938M        -         -     0%     2%  1.00x    ONLINE  -
otus2   960M  17.7M   942M        -         -     0%     1%  1.00x    ONLINE  -
otus3   960M  10.8M   949M        -         -     0%     1%  1.00x    ONLINE  -
otus4   960M  39.1M   921M        -         -     0%     4%  1.00x    ONLINE  -
```

С помощью команды ZFS import собираем пул ZFS

```
zpool import -d zpoolexport/ otus

zpool status
```
С помощью комманд определяем 

размер хранилища,тип пула,какое сжатие используется,контр.сумма,значение recordsize

```
zpool get size otus
zfs get type otus
zfs get compression otus
zfs get checksum otus
zfs get recordsize otus
```
Восстановили файл из снэпшота, нашли ссылку на репозиторий
```
[root@server ~]# zfs receive otus/test@today < otus_task2.file
[root@server ~]# find /otus/test -name "secret_message"
/otus/test/task1/file_mess/secret_message
[root@server ~]# cat /otus/test/task1/file_mess/secret_message
https://github.com/sindresorhus/awesome
[root@server ~]# date
Sun 29 May 22:17:36 UTC 2022
```
