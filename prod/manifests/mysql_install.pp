class mysql_install {

  include '::mysql::server'
  
  mysql::db { 'prod_mdb':
    user     => 'prod_user',
    password => 'p@$$w0rd',
    grant    => ['ALL'],
  }

}
