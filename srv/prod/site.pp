node 'agent.minsk.epam.com' {
  class { '::mysql::server':
    root_password    => 'root',
    override_options => {
      'mysqld' => { 'max_connections' => '1024' }
    },
  }
  include ::mysql::server::account_security

  mysql_database { 'prod_mdb':
      ensure  => present,
      charset => 'utf8',
  }

  mysql_user { 'prod_user@localhost':
    ensure => present,
    password_hash =>  mysql_password('Epam_2011'),
  }

  mysql_grant { 'prod_user@localhost/prod_mdb.*':
    ensure     => present,
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => 'prod_mdb.*',
    user       => 'prod_user@localhost',
  }
}            
