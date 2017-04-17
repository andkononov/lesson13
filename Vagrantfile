# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.define "dns" do |dns|
    dns.vm.box = "sbeliakou/centos-7.2-x86_64-minimal"
    dns.vm.hostname = "dns.kuzniatsou.local"
    dns.vm.synced_folder "vagrant_shares/dns", "/tmp/dns"
    dns.vm.network "private_network", ip: "192.168.33.99"
    dns.vm.provider "virtualbox" do |vb|
      vb.memory = "512"
      vb.cpus = "1"
    dns.vm.provision "shell", path: "./vagrant_scripts/dns.sh"
    end
  end

  config.vm.define "master1" do |master1|
    master1.vm.box = "sbeliakou/centos-7.2-x86_64-minimal"
    master1.vm.hostname = "master1.kuzniatsou.local"
    master1.vm.synced_folder "vagrant_shares/master", "/tmp/master1"
    master1.vm.network "private_network", ip: "192.168.33.190"
    master1.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "2"
    master1.vm.provision "shell", path: "./vagrant_scripts/master.sh"
    end
  end

    config.vm.define "node1" do |node1|
    node1.vm.box = "sbeliakou/centos-7.2-x86_64-minimal"
    node1.vm.hostname = "node1.kuzniatsou.local"
    node1.vm.synced_folder "vagrant_shares/node1", "/tmp/node1"
    node1.vm.network "private_network", ip: "192.168.33.91"
    node1.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "1"
    node1.vm.provision "shell", path: "./vagrant_scripts/node1.sh"
    end
  end

  config.vm.define "node2" do |node2|
    node2.vm.box = "sbeliakou/centos-7.2-x86_64-minimal"
    node2.vm.hostname = "node2.kuzniatsou.local"
    node2.vm.synced_folder "vagrant_shares/node2", "/tmp/node2"
    node2.vm.network "private_network", ip: "192.168.33.92"
    node2.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "1"
    node2.vm.provision "shell", path: "./vagrant_scripts/node2.sh"
    end
  end
end
