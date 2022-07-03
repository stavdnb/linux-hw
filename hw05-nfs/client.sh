#!/bin/bash

yum install -y nfs-utils
sed -i 's/# Nfsvers=4/Nfsvers=3/' /etc/nfsmount.conf
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

# echo '192.168.50.10:/upload/nfs /mnt nfs rw,sync,hard,intr 0 0' >> /etc/fstab

cat > /etc/systemd/system/mnt-upload.mount <<EOF
[Unit]
Description=Mount NFS Share
After=network.target multi-user.target
[Mount]
What=192.168.50.10:/upload/nfs
Where=/mnt/upload
Type=nfs
Option=defaults
[Install]
WantedBy=default.target
EOF

cat > /etc/systemd/system/mnt-upload.automount <<EOF
[Unit]
Description=automount /mnt/upload
After=network.target multi-user.target
[Automount]
Where=/mnt/upload
[Install]
WantedBy=default.target
EOF

systemctl daemon-reload
systemctl enable mnt-upload.mount
systemctl start mnt-upload.mount


# Requires=network-online.service
# After=network-online.service
