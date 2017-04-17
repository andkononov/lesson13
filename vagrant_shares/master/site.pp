node node1.kuzniatsou.local {
    include '::mysql::server'
}

# Ensure that the database 'test_mdb' is created, the user 'test_user' with assigned privileges exists
mysql::db { 'test_mdb':
  user     => 'test_user',
  password => 'password',
  host     => 'localhost',
  grant    => ['SELECT', 'UPDATE'],
}