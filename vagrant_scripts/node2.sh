#!/bin/bash


echo -e 'DNS1="192.168.33.99"\nDNS2="10.0.2.3"\nPEERDNS="no"' >> /etc/sysconfig/network-scripts/ifcfg-enp0s3
systemctl restart network

rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum install -y puppet
/bin/cp /tmp/node2/puppet.conf /etc/puppetlabs/puppet/


systemctl restart puppet
source ~/.bashrc
puppet resource service puppet ensure=running

#puppet agent -tv --debug
