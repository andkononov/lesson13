#!/bin/bash

yum install bind bind-utils -y


/bin/cp -f /tmp/dns/named.conf /etc/named.conf
/bin/cp -f /tmp/dns/forward.kuzniatsou /var/named/forward.kuzniatsou
/bin/cp -f /tmp/dns/reverse.kuzniatsou /var/named/reverse.kuzniatsou
#/bin/cp -f /tmp/dns/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf
#/bin/cp -f /tmp/dns/ifcfg-enp0s3 /etc/sysconfig/network-scripts/ifcfg-enp0s3
#/bin/cp -f /tmp/dns/ifcfg-enp0s8 /etc/sysconfig/network-scripts/ifcfg-enp0s8
echo -e 'DNS1="192.168.33.99"\nDNS2="10.0.2.3"\nPEERDNS="no"' >> /etc/sysconfig/network-scripts/ifcfg-enp0s3

systemctl enable named
#systemctl start named

chgrp named -R /var/named
chown -v root:named /etc/named.conf
restorecon -rv /var/named
restorecon /etc/named.conf


#cp -f /tmp/dns/resolv.conf /etc/resolv.conf

systemctl restart network
systemctl restart named

