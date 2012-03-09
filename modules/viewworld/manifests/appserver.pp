
class viewworld::appserver {

  $user = 'appmgr'
  $group = 'appmgr'

  user { $user:
    ensure     => present,
    shell      => '/bin/bash',
    home       => "/home/${user}",
    managehome => true,
  }

  ssh::authorized_keys { 'authorized_keys':
    user  => $user,
    group => $group,
  }

  class { 'webapp::python':
    owner     => $user,
    group     => $group,
    src_root  => "/home/${user}/src",
    venv_root => "/home/${user}/venv",
    require   => User[$user]
  }

  package { 'git':
    ensure => installed,
  }

  include ssl

}
