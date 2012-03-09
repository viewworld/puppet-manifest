class monit($ensure=present, $admin="", $interval=60) {
  $is_present = $ensure == "present"

  package { "monit":
    ensure => $ensure,
  }

  file {
    "/etc/monit/monitrc":
      ensure => $ensure,
      content => template("monit/monitrc.erb"),
      mode => 600,
      require => Package["monit"];

    "/etc/default/monit":
      ensure => $ensure,
      content => "startup=1\n",
      require => Package["monit"];

    "/etc/logrotate.d/monit":
      ensure => $ensure,
      source => "puppet:///modules/monit/monit.logrotate",
      require => Package[monit];
  }

  service { "monit":
    ensure => $is_present,
    enable => $is_present,
    hasrestart => $is_present,
    pattern => $ensure ? {
      'present' => "/usr/sbin/monit",
      default => undef,
    },
    subscribe => File["/etc/monit/monitrc"],
    require => [File["/etc/monit/monitrc"],
                File["/etc/logrotate.d/monit"]],
  }
}
