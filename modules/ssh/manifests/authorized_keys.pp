
define ssh::authorized_keys($user=undef, $group=undef) {

  file { "/home/${user}/.ssh":
    ensure => directory,
    owner => $user,
    group => $group,
    mode => '700',
  }

  file { "/home/${user}/.ssh/authorized_keys":
    source => 'puppet:///modules/ssh/authorized_keys',
    owner => $user,
    group => $group,
    mode => '600',
    require => File["/home/${user}/.ssh"]
  }

}
