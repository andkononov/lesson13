class nginx_install {
    package { 'nginx':
        ensure => installed,
        require => Package['epel-release']
    }
    package { 'epel-release':
        ensure => installed,
    }
   service { 'nginx':
        enable      => true,
        ensure      => running,
   }
}
