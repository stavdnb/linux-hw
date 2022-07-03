
 - выполнены задания по методичке
 - Добавлены скрипты для server и client
 - Установка nfs
 - Настройка шары
 - На клиенте добавлены mount и automount, в конфиге изменена версия nfs на 3
 - Протестировано, работает

```
[vagrant@nfsc ~]$ mount | grep nfs
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
nfsd on /proc/fs/nfsd type nfsd (rw,relatime)
192.168.50.10:/upload/nfs on /mnt/upload type nfs (rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.50.10,mountvers=3,mountport=20048,mountproto=udp,local_lock=none,addr=192.168.50.10)
[vagrant@nfsc ~]$ ls /mnt/upload/
test.txt
[vagrant@nfsc ~]$ date
Sun  3 Jul 21:04:53 UTC 2022
```
