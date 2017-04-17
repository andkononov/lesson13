node vm7.mnt.com {

  include '::mysql::server'
  
  mysql::db { 'prod_mdb':
    user => 'prod_user',
    password => 'password',
    grant => ['ALL'],
  }


  package { 'nginx':
    ensure => installed,
    require => Package['epel-release']
  }
  package { 'epel-release':
    ensure => installed,
  }
  service { 'nginx':
    enable => true,
    ensure => running,
  }
}
