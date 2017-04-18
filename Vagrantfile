# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.define "puppet-serv" do |serv|
	serv.vm.hostname = "puppet-serv.minsk.epam.com"
	serv.vm.box = "centos7"
	serv.vm.network "private_network", ip: "192.168.10.30"
	serv.vm.provider "virtualbox" do |server|
	  server.name = "puppet-serv"
	  server.cpus = 2
	  server.memory = 3000
	end
	
	serv.vm.provision "shell", inline: <<-SHELL
	sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
	sudo yum install -y puppetserver
	sudo systemctl restart network
 	sudo cp /vagrant/autosign.conf /etc/puppetlabs/puppet 	
	sudo systemctl start puppetserver
	source ~/.bashrc
        puppet module install puppetlabs-mysql --version 3.10.0
	sudo cp /vagrant/site.pp /etc/puppetlabs/code/environments/production/manifests
	echo " === Provision puppet-serv.minsk.epam.com complete === "
	SHELL
  end

  config.vm.define "node1" do |node1|
	node1.vm.hostname = "node1.minsk.epam.com"
	node1.vm.box = "centos7"
	node1.vm.network "private_network", ip: "192.168.10.40"
	node1.vm.provider "virtualbox" do |node|
	  node.name = "node1"
	  node.cpus = 1
	  node.memory = 1024

	end
	
	node1.vm.provision "shell", inline: <<-SHELL
	sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
	yum install -y puppet-agent
	sudo systemctl restart network
	echo "server = puppet-serv.minsk.epam.com" >> /etc/puppetlabs/puppet/puppet.conf
	echo "192.168.10.30 puppet-serv.minsk.epam.com" >> /etc/hosts
	sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
	echo " === Provision node1.minsk.epam.com complete === "
	SHELL

  end
 
end
