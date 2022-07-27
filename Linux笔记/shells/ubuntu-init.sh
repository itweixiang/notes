#/bin/bash

# 更新内核和lib
apt update -y

# 更新常用软件
apt install git vim net-tools wget -y

# 关闭交换区
echo 0 | sudo tee /proc/sys/vm/swappiness

# overcommit
echo 1 | sudo tee /proc/sys/vm/overcommit_memory

# 关闭防火墙
systemctl stop firewall

# 禁止防火墙开机自启
systemctl disable firewall

# 最小版安装默认没有selinux
# 关闭selinux
# setenforce 0
# 永久关闭selinux
# echo "SELINUX=disabled
# SELINUXTYPE=targeted" > /etc/selinux/config

# 重启
shutdown -r now