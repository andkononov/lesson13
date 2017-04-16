# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.define "server" do |server|
    server.vm.provider "virtualbox" do |v|

      v.memory = 3072
      v.cpus = 2
    end
    server.vm.hostname = "puppet"
    server.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "node" do |node|
    node.vm.hostname = "node"
    node.vm.network "private_network", ip: "192.168.33.11"
  end
end
