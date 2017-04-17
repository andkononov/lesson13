systemctl stop firewalld 
systemctl disable firewalld
/bin/cp /vagrant/hosts /etc/
yum install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum install -y puppet-agent
/bin/cp /vagrant/puppet.conf.client /etc/puppetlabs/puppet/puppet.conf
source ~/.bashrc
systemctl restart network
#puppet agent -t
