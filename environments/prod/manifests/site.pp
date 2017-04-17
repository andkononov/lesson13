node node2.kuzniatsou.local {
    include '::mysql::server'


# Ensure that the database 'test_mdb' is created, the user 'test_user' with assigned privileges exists
mysql::db { 'prod_mdb':
  user     => 'prod_user',
  password => 'password',
  host     => 'localhost',
  grant    => ['SELECT', 'UPDATE'],
}

#Ensure package 'nginx' installed
package { 'nginx':
    ensure => 'installed',
  }
}
