# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  # define box to use
  config.vm.box = 'sbeliakou/centos-7.2-x86_64'

  # define puppet master server
  config.vm.define 'master' do |master|
    master.vm.hostname = 'master.lab'
    master.vm.network 'private_network', ip: '192.0.0.100'
    master.vm.provider 'virtualbox' do |v|
      v.name = 'master'
      v.memory = 4096
      v.cpus = 2
      v.linked_clone = true
    end
    master.vm.provision 'shell', inline: <<-SHELL
      nmcli connection reload
      systemctl restart network.service
      grep client /etc/hosts
      [ $? -ne 0 ] && echo "192.0.0.105 client.lab" >> /etc/hosts
      /bin/cp /vagrant/hosts /etc/
	    yum install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
      yum install -y http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-redhat94-9.4-2.noarch.rpm
      yum install -y puppetserver
      systemctl enable puppetserver
      /bin/cp /vagrant/site.pp /etc/puppetlabs/code/environments/production/manifests
      /bin/cp /vagrant/autosign.conf /etc/puppetlabs/puppet/
      /bin/cp /vagrant/server_puppet.conf /etc/puppetlabs/puppet/puppet.conf
      mkdir -p /etc/puppetlabs/code/environments/prod/{manifests,modules}
      /bin/cp /vagrant/prod_site.pp /etc/puppetlabs/code/environments/prod/manifests/site.pp
      systemctl restart puppetserver
      source ~/.bashrc
      yum install postgresql94-server postgresql94-contrib -y
      /usr/pgsql-9.4/bin/postgresql94-setup initdb
      yes | cp /vagrant/pg_hba.conf /var/lib/pgsql/9.4/data/
      systemctl enable postgresql-9.4.service
      systemctl start postgresql-9.4.service
      cd /
      sudo -u postgres psql -c "create user puppetdb password 'puppetdb'"
      sudo -u postgres psql -c "create database puppetdb owner puppetdb"
      puppet module install puppetlabs-puppetdb --version 5.1.2
      puppet module install puppetlabs-mysql --version 3.10.0 --environment prod
      puppet module install puppetlabs-apache --version 1.11.0
      puppet module install spotify-puppetexplorer --version 1.1.1
      puppet module install puppet-nginx --version 0.6.0 --environment prod
      puppet agent -t
      systemctl stop iptables
      SHELL
  end

  # define puppet client vm
  config.vm.define 'client' do |client|
    client.vm.hostname = 'client.lab'
    client.vm.network 'private_network', ip: '192.0.0.105'
    client.vm.provider 'virtualbox' do |v|
      v.name = 'client'
      v.memory = 1024
      v.cpus = 1
      v.linked_clone = true
    end
    client.vm.provision 'shell', inline: <<-SHELL
      nmcli connection reload
      systemctl restart network.service
      grep master /etc/hosts
      [ $? -ne 0 ] && echo "192.0.0.100 master.lab" >> /etc/hosts
      yum install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
      yum install -y puppet-agent
      /bin/cp /vagrant/client_puppet.conf /etc/puppetlabs/puppet/puppet.conf
      source ~/.bashrc
      puppet agent -t
    SHELL
  end
end
