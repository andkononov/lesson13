# Installing puppetdb and puppetexplorer as modules:
#puppet module install puppetlabs-puppetdb --version 5.1.2
#puppet module install spotify-puppetexplorer --version 1.1.1
#puppet module install puppetlabs-apache --version 1.11.0

node epbyminw2976.minsk.epam.com {

  # Configure puppetdb and its underlying database
  class { 'puppetdb': }

  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }

  #rewrite rule for apache; population metric names changed in PuppetDB 4.x
  class {'::puppetexplorer':
    vhost_options => {
      rewrites  => [ { rewrite_rule => ['^/api/metrics/v1/mbeans/puppetlabs.puppetdb.query.population:type=default,name=(.*)$  https://%{HTTP_HOST}/api/metrics/v1/mbeans/puppetlabs.puppetdb.population:name=$1 [R=301,L]'] } ] }
    }

}

#turn off selinux or use bash command to fix issue with explorer:
#setsebool -P httpd_can_network_connect on
