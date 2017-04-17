class task13::nginx {
  package { 'nginx':
    ensure => installed
  }
  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => Package['nginx']
  }
}
