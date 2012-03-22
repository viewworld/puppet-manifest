
class exist {

  $user = 'exist'
  $group = 'exist'

  $app_name = 'exist'

  $exist_home = '/opt/exist'
  $exist_jar  = "${exist_home}/exist-installer.jar"
  $data_dir = '/var/lib/exist'
  $log_dir = '/var/log/exist'
  $pid_dir = '/var/run/exist'

  $port = 8080

  user { $user:
    ensure => present,
    shell  => '/bin/bash',
  }

  file { $exist_home:
    ensure  => directory,
  }

  file { $exist_jar:
    source  => 'puppet:///modules/exist/exist-installer.jar',
    require => File[$exist_home],
  }

  package { ['openjdk-6-jre-headless', 'openjdk-6-jdk']:
    ensure => installed,
  }

  exec { 'install exist':
    command => "java -jar ${exist_jar} -p ${exist_home}",
    creates => "${exist_home}/src",
    require => [File[$exist_jar], Package['openjdk-6-jre-headless']],
  }

  file {
    '/etc/init.d/exist':
      content => template('exist/exist.init.sh.erb'),
      mode    => '0755';

    "${exist_home}/conf.xml":
      content => template('exist/conf.xml.erb'),
      notify  => Service['exist'];

    "${exist_home}/server.xml":
      content => template('exist/server.xml.erb'),
      notify  => Service['exist'];

    "${exist_home}/tools/wrapper/conf/wrapper.conf":
      content => template('exist/wrapper.conf.erb'),
      notify  => Service['exist'];

    "${exist_home}/extensions/local.build.properties":
      content => template('exist/local.build.properties.erb');

    "${exist_home}/tools/jetty/logs":
      ensure => directory,
      owner  => $user,
      group  => $group;

    "${exist_home}/tools/wrapper/logs":
      ensure => directory,
      owner  => $user,
      group  => $group;

    "${exist_home}/webapp/WEB-INF/logs":
      ensure => link,
      target => $log_dir,
      force  => true;
  }

  Exec['install exist'] -> File["${exist_home}/conf.xml"]
  Exec['install exist'] -> File["${exist_home}/server.xml"]
  Exec['install exist'] -> File["${exist_home}/tools/wrapper/conf/wrapper.conf"]
  Exec['install exist'] -> File["${exist_home}/extensions/local.build.properties"]
  Exec['install exist'] -> File["${exist_home}/tools/jetty/logs"] -> Service['exist']
  Exec['install exist'] -> File["${exist_home}/tools/wrapper/logs"] -> Service['exist']
  Exec['install exist'] -> File["${exist_home}/webapp/WEB-INF/logs"] -> Service['exist']

  exec { 'build exist':
    command => "${exist_home}/build.sh",
    creates => "${exist_home}/build/classes",
    cwd     => $exist_home,
    require => [
      Exec['install exist'],
      File["${exist_home}/extensions/local.build.properties"],
      Package['openjdk-6-jdk'],
    ],
  }

  file { [$data_dir, $log_dir, $pid_dir]:
      ensure => directory,
      owner  => $user,
      group  => $group,
  }

  package { 'libc6-i386':
    ensure => installed,
  }

  service { 'exist':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [
      Package['libc6-i386'],
      Exec['build exist'],
      File[$pid_dir],
      File[$log_dir],
      File[$data_dir],
    ],
  }

  monit::monitor { "exist":
    ensure  => present,
    pidfile => "${pid_dir}/${app_name}.pid",
    ip_port => $port,
  }

}
