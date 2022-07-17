#/bin/bash

HOSTNAME="copy"
DNS1="192.168.19.2"
GATEWAY="192.168.19.2"
IPADDR="192.168.19.128"
NETMASK="255.255.255.0"

# 固定ip
echo "DNS1=\"${DNS1}\"" >> /etc/sysconfig/network-scripts/ifcfg-ens33
echo "GATEWAY=\"${GATEWAY}\"" >> /etc/sysconfig/network-scripts/ifcfg-ens33
echo "IPADDR=\"${IPADDR}\"" >> /etc/sysconfig/network-scripts/ifcfg-ens33
echo "NETMASK=\"${NETMASK}\"" >> /etc/sysconfig/network-scripts/ifcfg-ens33

# 设置hostname
hostnamectl set-hostname ${HOSTNAME}

systemctl restart network