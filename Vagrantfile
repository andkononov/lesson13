# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # vagrant box
  config.vm.box = "centos/7"
  
  # provisioning puppet server  
  config.vm.define "server" do |server|
    server.vm.hostname = "server.bm"
    server.vm.network :private_network, ip: "192.168.20.100"
    server.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 2
    end
    server.vm.provision "shell", inline: <<-SHELL
      # update hosts file
      echo "192.168.20.100 server.bm" >> /etc/hosts
      echo "192.168.20.10  agent1.bm" >> /etc/hosts
      echo "192.168.20.11  agent2.bm" >> /etc/hosts
      # install puppet server
      rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
      yum install puppetserver -y
      # start puppet server
      systemctl start puppetserver.service
      # create environment 'prod'
      mkdir -p /etc/puppetlabs/code/environments/prod/{modules,manifests}
      # install the modules
      source ~/.bashrc
      puppet module install puppetlabs-mysql --version 3.10.0
      puppet module install puppetlabs-puppetdb --version 5.1.2
      puppet module install puppetlabs-apache --version 1.11.0
      puppet module install spotify-puppetexplorer --version 1.1.1
      puppet resource package puppetdb-termini ensure=latest
      puppet module install puppetlabs-mysql --version 3.10.0 --environment prod
      puppet module install puppet-nginx --version 0.6.0 --environment prod
      # create production/site.pp
      /bin/cp /vagrant/productionsite.pp /etc/puppetlabs/code/environments/production/manifests/site.pp
      # create prod/site.pp
      /bin/cp /vagrant/prodsite.pp /etc/puppetlabs/code/environments/prod/manifests/site.pp  
      # create autosign.conf
      echo '*.bm' >> /etc/puppetlabs/puppet/autosign.conf
      # update puppet.conf 
      echo 'codedir = /etc/puppetlabs/code'	 
      echo 'storeconfigs = true' >> /etc/puppetlabs/puppet/puppet.conf
      echo 'storeconfigs_backend = puppetdb' >> /etc/puppetlabs/puppet/puppet.conf
      echo 'reports = store,puppetdb' >> /etc/puppetlabs/puppet/puppet.conf
      # create routes.yaml
      echo '---' > /etc/puppetlabs/puppet/routes.yaml
      echo 'master:' >> /etc/puppetlabs/puppet/routes.yaml
      echo '  facts:' >> /etc/puppetlabs/puppet/routes.yaml
      echo '    terminus: puppetdb' >> /etc/puppetlabs/puppet/routes.yaml
      echo '    cache: yaml' >> /etc/puppetlabs/puppet/routes.yaml
      # change ownership   
      chown -R puppet:puppet /etc/puppetlabs
      # restart network service
      systemctl restart network.service
      # restart puppet server
      systemctl restart puppetserver.service
      # apply main manifests
      source ~/.bashrc
      puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
      # disable iptables.service
      systemctl stop iptables
    SHELL
  end
end

  # provisioning puppet agent1  
  config.vm.define "agent1" do |agent|
    agent.vm.hostname = "agent1.bm"
    agent.vm.network :private_network, ip: "192.168.20.10"
    agent.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 1
    end
    agent.vm.provision "shell", inline: <<-SHELL
      # update hosts file
      echo "192.168.20.100 server.bm" >> /etc/hosts
      echo "192.168.20.10  agent1.bm" >> /etc/hosts
      echo "192.168.20.11  agent2.bm" >> /etc/hosts
      # install puppet-agent
      rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
      yum install puppet-agent -y
      # update puppet.conf
      echo "server = server.bm" >> /etc/puppetlabs/puppet/puppet.conf
      echo "environment = production" >> /etc/puppetlabs/puppet/puppet.conf
      # restart network service
      systemctl restart network.service
      # start puppet server
      #source ~/.bashrc 
      #puppet resource service puppet ensure=running enable=true
      #puppet agent -t 
    SHELL
  end
  
  # provisioning puppet agent2  
  config.vm.define "agent2" do |agent|
    agent.vm.hostname = "agent2.bm"
    agent.vm.network :private_network, ip: "192.168.20.11"
    agent.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 1
    end
    agent.vm.provision "shell", inline: <<-SHELL
      # update hosts file
      echo "192.168.20.100 server.bm" >> /etc/hosts
      echo "192.168.20.10  agent1.bm" >> /etc/hosts
      echo "192.168.20.11  agent2.bm" >> /etc/hosts
      # install puppet-agent
      rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
      yum install puppet-agent -y
      # update puppet.conf
      echo "server = server.bm" >> /etc/puppetlabs/puppet/puppet.conf
      echo "environment = prod" >> /etc/puppetlabs/puppet/puppet.conf
      # restart network service
      systemctl restart network.service
      # start puppet server
      #source ~/.bashrc
      #puppet resource service puppet ensure=running enable=true
      #puppet agent -t
    SHELL
  end  
end

