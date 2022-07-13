#/bin/bash

HOSTNAME="copy"
DNS1="192.168.0.3"
GATEWAY="192.168.0.2"
IPADDR="192.168.0.73"
NETMASK="255.255.254.0"

# 固定ip
sed -i "s/^IPADDR=.*/IPADDR=\""${IPADDR}"\"/g" /etc/sysconfig/network-scripts/ifcfg-ens33
sed -i "s/^BOOTPROTO=.*/BOOTPROTO=\""static"\"/g" /etc/sysconfig/network-scripts/ifcfg-ens33
sed -i "s/^NETMASK=.*/NETMASK=\""${NETMASK}"\"/g" /etc/sysconfig/network-scripts/ifcfg-ens33
sed -i "s/^DNS1=.*/DNS1=\""${DNS1}"/g" /etc/sysconfig/network-scripts/ifcfg-ens33
sed -i "s/^GATEWAY=.*/GATEWAY=\""${GATEWAY}"\"/g" /etc/sysconfig/network-scripts/ifcfg-ens33

# 设置hostname
hostnamectl set-hostname ${HOSTNAME}

systemctl restart network