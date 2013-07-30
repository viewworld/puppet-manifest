define python::gunicorn::instance($venv,
                                  $src,
                                  $ensure=present,
                                  $wsgi_module="",
                                  $django=false,
                                  $django_settings="",
                                  $paster=false,
                                  $paster_config="",
                                  $version=undef,
                                  $workers=1,
                                  $timeout_seconds=30) {
  $is_present = $ensure == "present"

  $rundir = $python::gunicorn::rundir
  $logdir = $python::gunicorn::logdir
  $owner = $python::gunicorn::owner
  $group = $python::gunicorn::group

  $initscript = "/etc/init.d/gunicorn-${name}"
  $pidfile = "$rundir/$name.pid"
  $socket = "unix:$rundir/$name.sock"
  $logfile = "$logdir/$name.log"

  if $wsgi_module == "" and !$django and !$paster {
    fail("If you're not using Django you have to define a WSGI module.")
  }

  if $django_settings != "" and !$django {
    fail("If you're not using Django you can't define a settings file.")
  }
  if $paster_config != "" and !$paster {
    fail("If you're not using Paster you can't define a config file.")
  }

  if $django and $paster {
    fail("You can't use Django and Paster simultaneously.")
  }
  if $wsgi_module != "" and ($django or $paster) {
    fail("If you're using Django or Paster you can't define a WSGI module.")
  }

  $gunicorn_package = $version ? {
    undef => "gunicorn",
    default => "gunicorn==${version}",
  }

  if $is_present {
    python::pip::install {
      "$gunicorn_package in $venv":
        package => $gunicorn_package,
        ensure => $ensure,
        venv => $venv,
        owner => $owner,
        group => $group,
        require => Python::Venv::Isolate[$venv],
        before => File[$initscript];

      # for --name support in gunicorn:
      "setproctitle in $venv":
        package => "setproctitle",
        ensure => $ensure,
        venv => $venv,
        owner => $owner,
        group => $group,
        require => Python::Venv::Isolate[$venv],
        before => File[$initscript];
    }
  }

  file { $initscript:
    ensure => $ensure,
    content => template("python/gunicorn.init.erb"),
    mode => 775,
    group => $group,
    require => File["/etc/logrotate.d/gunicorn-${name}"],
  }

  file { "/etc/logrotate.d/gunicorn-${name}":
    ensure => $ensure,
    content => template("python/gunicorn.logrotate.erb"),
  }

  service { "gunicorn-${name}":
    ensure => $is_present,
    enable => $is_present,
    hasstatus => $is_present,
    hasrestart => $is_present,
    subscribe => $ensure ? {
      'present' => File[$initscript],
      default => undef,
    },
    require => $ensure ? {
      'present' => File[$initscript],
      default => undef,
    },
    before => $ensure ? {
      'absent' => File[$initscript],
      default => undef,
    },
  }
}
