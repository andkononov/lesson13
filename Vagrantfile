# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure('2') do |config|
  config.vm.box = 'centos/7'
  config.vm.define 'server' do |server|
    server.vm.hostname = 'master'
    server.vm.network 'private_network', ip: '192.168.100.100'
    server.vm.provider 'virtualbox' do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    server.vm.provision :shell, path: "server.sh"
  end

  config.vm.define 'agent' do |agent|
    agent.vm.hostname = 'agent'
    agent.vm.network 'private_network', ip: '192.168.100.101'
    agent.vm.provider 'virtualbox' do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end
    agent.vm.provision :shell, path: "agent.sh"
  end
end
