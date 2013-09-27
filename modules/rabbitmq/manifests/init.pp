class rabbitmq() {

  package { 'rabbitmq-server':
    ensure => installed,
  }

  service { 'rabbitmq-server':
    ensure => running,
    enable => true,
    require => Package['rabbitmq-server']
  }

  file { '/etc/rabbitmq/rabbitmq-env.conf':
    content => template('rabbitmq/rabbitmq-env.conf.erb'),
    notify  => Service['rabbitmq-server']
  }

}
