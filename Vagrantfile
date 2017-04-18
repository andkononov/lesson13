# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
   config.vm.define "master" do |master|
      master.vm.hostname = "master"
      master.vm.box = "centos/7"
      master.vm.network "private_network", ip: "192.168.33.33"
      master.vm.provider "virtualbox" do |vm|
       vm.memory = "4096"
       vm.cpus = "2"
      end
      master.vm.synced_folder "shares/master", "/tmp/configs"
      master.vm.provision "shell", path: "/home/student/cm/puppet/lab12/server/provision_scripts/master.sh"
   end

  config.vm.define "client" do |client|
      client.vm.hostname = "client"
      client.vm.box = "centos/7"
      client.vm.network "private_network", ip: "192.168.33.34"
      client.vm.synced_folder "shares/client", "/tmp/configs"
      client.vm.provision "shell", path: "/home/student/cm/puppet/lab12/server/provision_scripts/client.sh"
  end
end
