# Lesson 13 

## Vagranfile for agent1

``` ruby
Vagrant.configure("2") do |config| 
  config.vm.box = "centos/7" 
  config.vm.define "agent" do |puppet|
    puppet.vm.hostname = "agent.hv"
    puppet.vm.network :private_network, ip: "192.168.20.10"
    puppet.vm.provision "shell", inline: <<-SHELL
     echo "192.168.20.100  server.hv" >> /etc/hosts
     systemctl restart network.service
     rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
     yum install puppet-agent -y
  SHELL
 end
end
```

## Vagranfile for agent2

``` ruby
Vagrant.configure("2") do |config| 
  config.vm.define "agent" do |puppet|
    puppet.vm.hostname = "agent2.hv"
    puppet.vm.network :private_network, ip: "192.168.20.20"
    puppet.vm.provision "shell", inline: <<-SHELL
     echo "192.168.20.100  server.hv" >> /etc/hosts
     systemctl restart network.service
     rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
     yum install puppet-agent -y
  SHELL
 end
end
```


## Vagranfile for server
``` ruby
Vagrant.configure("2") do |config| 
 config.vm.define "server" do |puppet|
    puppet.vm.hostname = "server.hv"
    puppet.vm.network :private_network, ip: "192.168.20.100"
    puppet.vm.provision "shell", inline: <<-SHELL
     echo "192.168.20.10  agent.hv" >> /etc/hosts
     echo "192.168.20.20  agent2.hv" >> /etc/hosts
     systemctl restart network.service
     rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
     yum install puppetserver -y
  SHELL
 end
end
```

## Site.pp (prod environment)
```ruby

node 'agent2.hv' {

  class {"nginx":}

  class {'::mysql::server':
    root_password    => 'password',
 }

  mysql_database {'test_mdb':
    ensure  => present,
    charset => 'utf8',
 }

  mysql_user { 'test_user@localhost':
    ensure => present,
    password_hash => mysql_password('test'),
 }

  mysql_grant {'test_user@localhost/test_mdb.*':
    ensure     => present,
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => 'test_mdb.*',
    user       => 'test_user@localhost',
 }
}
```

## Site.pp (production environment)
```ruby
node 'server.hv' {
  class { 'puppetdb': }
  class { 'puppetdb::master::config': }
  class { '::puppetexplorer':
     vhost_options => {
       rewrites => [{ rewrite_rule => ['^/api/metrics/v1/mbeans/puppetlabs.pupetdb.query.population:type=default, name=(.*)$  https://%{HTTP_HOST}/api/metrics/mbeans/v1/puppetlabs.puppetdb.population:name=$1 [R=301,L]']}]
  }
 }
}

node 'agent.hv' {
  class {'::mysql::server':
    root_password    => 'password',
  }
  mysql_database {'test_mdb':
    ensure  => present,
    charset => 'utf8',
  }
  mysql_user { 'test_user@localhost':
    ensure => present,
    password_hash => mysql_password('test'),
  }
  mysql_grant {'test_user@localhost/test_mdb.*':
    ensure     => present,
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => 'test_mdb.*',
    user       => 'test_user@localhost',
  }
}
```

## Puppet.conf
```ruby
# This file can be used to override the default puppet settings.
# See the following links for more details on what settings are available:
# - https://docs.puppetlabs.com/puppet/latest/reference/config_important_settings.html
# - https://docs.puppetlabs.com/puppet/latest/reference/config_about_settings.html
# - https://docs.puppetlabs.com/puppet/latest/reference/config_file_main.html
# - https://docs.puppetlabs.com/puppet/latest/reference/configuration.html
[master]
vardir = /opt/puppetlabs/server/data/puppetserver
logdir = /var/log/puppetlabs/puppetserver
rundir = /var/run/puppetlabs/puppetserver
pidfile = /var/run/puppetlabs/puppetserver/puppetserver.pid
codedir = /etc/puppetlabs/code
storeconfigs = true
storeconfigs_backend = puppetdb
reports = store, puppetdb

[main]
server_urls = https://server.hv:8081/
soft_write_failure = false
```
