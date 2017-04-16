node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
  notify { "Node ${::fqdn} is up and running!": }
}

node 'puppet' {
  class { 'puppetdb':
    listen_address => puppet,
  }
  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }
 
  class { 'puppetexplorer':}

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
