#!/bin/bash

rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum install -y puppet
echo -e 'DNS1="192.168.33.99"\nDNS2="10.0.2.3"\nPEERDNS="no"' >> /etc/sysconfig/network-scripts/ifcfg-enp0s3

/bin/cp /tmp/master/autosign.conf /etc/puppetlabs/puppet/

systemctl restart network
systemctl restart puppet
source ~/.bashrc
puppet resource service puppet ensure=running
puppet resource package puppetserver ensure=installed
puppet resource service puppetserver ensure=running
puppet module install puppetlabs-mysql --version 3.10.0

/bin/cp /tmp/master/site.pp /etc/puppetlabs/code/environments/production/manifests/site.pp