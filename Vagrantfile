# -*- mode: ruby -*-
# vi: set ft=ruby :

$vm1_ip="192.168.56.107"
#$cookbook_dir="~/chef/task7/cookbooks"
Vagrant.configure(2) do |config|

    config.vm.define "vm7" do |vm7_config|
    vm7_config.vm.box = "centos/7"
    vm7_config.vm.network "private_network", ip: $vm1_ip
    vm7_config.vm.hostname = "vm7.mnt.com"
    vm7_config.vm.provider "virtualbox" do |v|
        v.name = "vm7"
        v.customize ["modifyvm", :id, "--memory", 2048] 
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end
#    config.vm.provision "chef_solo" do |chef|
#      chef.cookbooks_path = $cookbook_dir
#      chef.add_recipe "java::default"
#      chef.add_recipe "jboss::default"
#    end
    #vm7_config.vm.synced_folder "~/chef", "/var/chef" #, type: "nfs"
  end
end
