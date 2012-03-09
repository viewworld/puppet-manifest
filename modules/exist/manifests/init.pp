

class exist {

  $user = 'exist'
  $group = 'exist'

  $app_name = 'exist'

  $exist_home = '/opt/exist'
  $data_dir = '/var/lib/exist'
  $log_dir = '/var/log/exist'
  $pid_dir = '/var/run/exist'

  $port = 8080

  user { $user:
    ensure     => present,
    shell      => '/bin/bash',
  }

  file { $data_dir:
    ensure => directory,
    owner => $user,
    group => $group,
  }

  file { $log_dir:
    ensure => directory,
    owner => $user,
    group => $group,
  }

  file { $pid_dir:
    ensure => directory,
    owner => $user,
    group => $group,
  }

  exec { "fix exist webapp owner":
    command => "chown -R ${user}:${group} ${exist_home}/webapp",
    unless => "test `stat -c %U:%G ${exist_home}/webapp` = ${user}:${group}",
    user => 'root',
    require => User[$user],
  }

  file { "/etc/init.d/exist":
    content => template('exist/exist.init.sh.erb'),
    mode => "0755",
  }

  file { "${exist_home}/conf.xml":
    content => template('exist/conf.xml.erb'),
    notify => Service['exist'],
  }

  file { "${exist_home}/server.xml":
    content => template('exist/server.xml.erb'),
    notify => Service['exist'],
  }

  file { "${exist_home}/tools/wrapper/conf/wrapper.conf":
    content => template('exist/wrapper.conf.erb'),
    notify => Service['exist'],
  }

  file { "${exist_home}/extensions/local.build.properties":
    content => template('exist/local.build.properties.erb'),
  }

  file { "${exist_home}/tools/jetty/logs":
    ensure => directory,
    owner => $user,
    group => $group,
  }

  file { "${exist_home}/tools/wrapper/logs":
    ensure => directory,
    owner => $user,
    group => $group,
  }

  package { 'libc6-i386':
    ensure => installed,
  }

  service { 'exist':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => true,
    require => Package['libc6-i386'],
  }
  Exec['fix exist webapp owner'] -> Service['exist']

  monit::monitor { "exist":
    ensure => present,
    pidfile => "${pid_dir}/${app_name}.pid",
    ip_port => $port,
  }

}
