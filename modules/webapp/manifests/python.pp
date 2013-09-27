class webapp::python(
  $ensure=present,
  $owner='www-data',
  $group='www-data',
  $src_root='/usr/local/src',
  $venv_root='/usr/local/venv',
  $celery=false,
  $webserver=true,
  $nginx_workers=1,
  $monit_admin="",
  $monit_interval=60
) {

  class { 'python::dev':
    ensure => $ensure,
  }

  class { 'python::venv':
    ensure => $ensure,
    owner => $owner,
    group => $group
  }

  if $webserver {
    class { 'nginx':
      ensure => $ensure,
      workers => $nginx_workers
    }
    class { 'python::gunicorn':
      ensure => $ensure,
      owner => $owner,
      group => $group
    }
  }

  if $celery {
    class { 'python::celery':
      owner => $owner,
      group => $group,
    }
  }

  class { monit:
    ensure => $ensure,
    admin => $monit_admin,
    interval => $monit_interval
  }

}

