#!/bin/bash
yum update -y
yum install -y epel-release
yum install -y \
git \
wget \
gcc \
zlib-devel \
openssl-devel \
make \
pcre-devel \
libxml2-devel \
libxslt-devel \
libgcrypt-devel \
gd-devel \
perl-ExtUtils-Embed \
GeoIP-data \
GeoIP \
GeoIP-devel 
git clone https://github.com/vermyter/rnd.git  /opt/rnd/
wget https://nginx.org/download/nginx-1.21.1.tar.gz 
tar zxvf nginx-1.21.1.tar.gz
cd nginx-1.21.1
./configure \
--prefix=/opt/nginx \
--sbin-path=/opt/nginx/sbin/nginx
--conf-path=/opt/rnd/nginx.conf \
--pid-path=/var/run/nginx.pid \
--user=nginx \
--group=nginx \
--build=CentOS \
--builddir=nginx-1.21.1 \
--with-http_ssl_module
make
make install
useradd --system --home /var/cache/nginx --shell /sbin/nologin --comment "nginx user" --user-group nginx
mkdir -p /var/cache/nginx
chown -R nginx:nginx /var/cache/nginx
chown -R nginx:nginx /opt/nginx/conf.d
chown -R nginx:nginx /opt/rnd/
cp /opt/rnd/etc/systemd/system/nginx.service /etc/systemd/system/nginx.service
cp /opt/rnd/etc/systemd/system/gitclone.service /etc/systemd/system/gitclone.service
cp /opt/rnd/etc/systemd/system/remperm.service /etc/systemd/system/remperm.service
cp /opt/rnd/etc/systemd/system/rsyncrnd.service /etc/systemd/system/rsyncrnd.service
chown -R nginx:nginx /etc/systemd/system/nginx.service
systemctl daemon-reload
systemctl start nginx
systemctl enable nginx
systemctl enable gitclone
systemctl enable remperm
systemctl enable rsyncrnd
tee /etc/selinux/config <<EOF
SELINUX=disabled
EOF
tee /etc/motd <<EOF
 #######################################
 #    THIS IS A TESTWELCOME MESSAGE    #
 #######################################
EOF
reboot