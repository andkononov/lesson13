node 'puppet.loc' {
  class { 'puppetdb': }
  class { 'puppetdb::master::config': }
  class {'::puppetexplorer':
    vhost_options => {
      rewrites  => [ { rewrite_rule => ['^/api/metrics/v1/mbeans/puppetlabs.puppetdb.query.population:type=default,name=(.*)$  https://%{HTTP_HOST}/api/metrics/v1/mbeans/puppetlabs.puppetdb.population:name=$1 [R=301,L]'] } ] }
  }  
}
node 'node.loc' {
	class { '::mysql::server':
		root_password => 'strongpassword'
		}
	mysql_database { 'test_mdb':
		ensure => present,
		charset => 'utf8',
		}
	mysql_user { 'test_user@node.loc':
		ensure => present,
		}
	mysql_grant { 'test_user@node.loc/test_mdb.*':

		ensure => present,
		options => ['GRANT'],
		privileges => ['ALL'],
		table => 'test_mdb.*',
		user => 'test_user@node.loc',
		}
}
node 'node1.loc' {
	class { '::mysql::server':
		root_password => 'strongpassword'
		}
	mysql_database { 'test_mdb':
		ensure => present,
		charset => 'utf8',
		}
	mysql_user { 'test_user@node.loc':
		ensure => present,
		}
	mysql_grant { 'test_user@node.loc/test_mdb.*':

		ensure => present,
		options => ['GRANT'],
		privileges => ['ALL'],
		table => 'test_mdb.*',
		user => 'test_user@node.loc',
		}
}
