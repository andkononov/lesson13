# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  # define box to use
  config.vm.box = 'centos7'

  # define puppet master server
  config.vm.define 'master' do |master|
    master.vm.hostname = 'master.lab'
    master.vm.network 'private_network', ip: '192.168.0.100'
    master.vm.provider 'virtualbox' do |v|
      v.name = 'master'
      v.memory = 4096
      v.cpus = 2
      v.linked_clone = true
    end
    master.vm.provision 'shell', inline: <<-SHELL
      systemctl stop firewalld
      systemctl disable firewalld
      /bin/cp /vagrant/hosts /etc/
      yum install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
      yum install -y http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-redhat94-9.4-2.noarch.rpm
      yum install -y puppetserver
      systemctl enable puppetserver
      /bin/cp /vagrant/site.pp /etc/puppetlabs/code/environments/production/manifests
      /bin/cp /vagrant/autosign.conf /etc/puppetlabs/puppet/
      /bin/cp /vagrant/puppet.conf.serevr /etc/puppetlabs/puppet/puppet.conf
      mkdir -p /etc/puppetlabs/code/environments/prod/{manifests,modules}
      /bin/cp /vagrant/site.pp.prod /etc/puppetlabs/code/environments/prod/manifests/site.pp
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
      SHELL
  end

  # define puppet client vm
  config.vm.define 'agent' do |agent|
    agent.vm.hostname = 'agent'
    agent.vm.network 'private_network', ip: '192.168.0.101'
    agent.vm.provider 'virtualbox' do |v|
      v.name = 'agent'
      v.memory = 2048
      v.cpus = 1
      v.linked_clone = true
    end
    agent.vm.provision 'shell', inline: <<-SHELL
      systemctl stop firewalld
      systemctl disable firewalld
      /bin/cp /vagrant/hosts /etc/
      yum install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
      yum install -y puppet-agent
      /bin/cp /vagrant/puppet.conf.client /etc/puppetlabs/puppet/puppet.conf
      source ~/.bashrc
      puppet agent -t
    SHELL
  end
end
