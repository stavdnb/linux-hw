#!/bin/bash

yum install -y nfs-utils
systemctl enable rpcbind
systemctl enable nfs-server
systemctl start rpcbind
systemctl start nfs-server

systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-port=111/tcp
firewall-cmd --permanent --add-port=2049/tcp
firewall-cmd --permanent --add-port=2049/udp
firewall-cmd --permanent --zone=public --add-service=nfs
firewall-cmd --permanent --zone=public --add-service=mountd
firewall-cmd --permanent --zone=public --add-service=rpc-bind
firewall-cmd --reload

mkdir -p /upload/nfs
chmod -R 777 /upload/nfs

echo '/upload/nfs *(rw,root_squash)' >> /etc/exports

exportfs -r

touch /upload/nfs/test.txt
 