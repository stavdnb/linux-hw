#!/bin/bash

cd  /root/

yum install -y \
    redhat-lsb-core \
    wget \
    rpmdevtools \
    rpm-build \
    createrepo \
    yum-utils \
    git \
    gcc

wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm

wget wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1a.tar.gz --no-check-certificate

tar -xvf openssl-1.1.1a.tar.gz

rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

yum-builddep -y /root/rpmbuild/SPECS/nginx.spec


sed -i "s/\-\-with\-debug/\-\-with\-openssl\=\/home\/vagrant\/openssl\-1\.1\.1k/" /root/rpmbuild/SPECS/nginx.spec

rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec

yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm

systemctl start nginx

systemctl status nginx

mkdir -p /usr/share/nginx/html/repo

cp /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/

chmod +w /usr/share/nginx/html/repo

wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm

createrepo /usr/share/nginx/html/repo

sed -i "/index  index.html index.htm;/a \        autoindex on;" /etc/nginx/conf.d/default.conf

nginx -t

nginx -s reload

cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF