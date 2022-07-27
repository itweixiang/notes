#/bin/bash

HOSTNAME="svn"
DNS1="192.168.0.3"
GATEWAY="192.168.0.2"
IPADDR="192.168.0.84"
NETMASK="255.255.254.0"
NETCARD="ens160"

echo "network:
  ethernets:
    ${NETCARD}:  #配置的网卡的名称
      dhcp4: no  #dhcp4关闭
      addresses: [${IPADDR}/24]  #设置本机IP及掩码，/24即表示24位掩码255.255.255.0
      gateway4: ${GATEWAY}  #网关IP，设置为和物理机相同
      nameservers:
        addresses: [${DNS1}]  #设置DNS，与物理机相同
  version: 2" > /etc/netplan/00-installer-config.yaml


hostnamectl set-hostname ${HOSTNAME}