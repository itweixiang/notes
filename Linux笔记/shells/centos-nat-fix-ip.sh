#/bin/bash

HOSTNAME="copy"
DNS1="192.168.19.2"
GATEWAY="192.168.19.2"
IPADDR="192.168.19.128"
NETMASK="255.255.255.0"
NETCARK="ens192"

# 固定ip
sed -i "s/^BOOTPROTO=.*/BOOTPROTO=\""static"\"/g" /etc/sysconfig/network-scripts/ifcfg-${NETCARK}
echo "DNS1=\"${DNS1}\"" >> /etc/sysconfig/network-scripts/ifcfg-${NETCARK}
echo "GATEWAY=\"${GATEWAY}\"" >> /etc/sysconfig/network-scripts/ifcfg-${NETCARK}
echo "IPADDR=\"${IPADDR}\"" >> /etc/sysconfig/network-scripts/ifcfg-${NETCARK}
echo "NETMASK=\"${NETMASK}\"" >> /etc/sysconfig/network-scripts/ifcfg-${NETCARK}

# 设置hostname
hostnamectl set-hostname ${HOSTNAME}

systemctl restart network