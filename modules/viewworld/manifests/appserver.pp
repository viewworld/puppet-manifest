
class viewworld::appserver ($worker=false) {

  $user = 'appmgr'
  $group = 'appmgr'

  $src_root  = "/home/${user}/src"
  $venv_root = "/home/${user}/venv"

  user { $user:
    ensure     => present,
    shell      => '/bin/bash',
    home       => "/home/${user}",
    managehome => true,
  }

  ssh::authorized_keys { 'ubuntu authorized_keys':
    user  => 'ubuntu',
  }

  ssh::authorized_keys { 'appmgr authorized_keys':
    user  => $user,
  }

  package { 'git':
    ensure => installed,
  }

  file {
    $src_root:
      ensure => directory,
      owner => $user,
      group => $group;

    $venv_root:
      ensure => directory,
      owner => $user,
      group => $group;
  }

  class { 'webapp::python':
    owner     => $user,
    group     => $group,
    src_root  => $src_root,
    venv_root => $venv_root,
    worker    => $worker,
    require   => User[$user],
  }

  if !$worker {
    include ssl
  }

}
