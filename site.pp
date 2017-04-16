node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
  notify { "Node ${::fqdn} is up and running!": }
}

node 'puppet' {
  class { 'puppetdb':
    listen_address => '0.0.0.0',
  }
  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }
#  class { 'puppetexplorer': }
  class {'::puppetexplorer':
  vhost_options => {
    rewrites  => [ { rewrite_rule => ['^/api/metrics/v1/mbeans/puppetlabs.puppetdb.query.population:type=default,name=(.*)$  https://%{HTTP_HOST}/api/metrics/v1/mbeans/puppetlabs.puppetdb.population:name=$1 [R=301,L]'] } ] }
  }
}
  

node 'node' {
  class { 'nginx': }

  class { '::mysql::server':
    root_password => 'password',
  }

  mysql_database { 'prod_mdb':
    ensure  =>  present,
    charset =>  'utf8',
  }

  mysql_user {'prod_user@localhost':
    ensure  =>  present,
    password_hash =>  mysql_password('password'),
  }

  mysql_grant { 'prod_user@localhost/prod_mdb.*':
    ensure  =>  present,
    options =>  ['GRANT'],
    privileges  =>  ['ALL'],
    table =>  'prod_mdb.*',
    user  =>  'prod_user@localhost',
  }
}
