define python::celery::instance(
  $ensure=present,
  $django_settings="",
  $requirements=false,
  $version=undef,
  $workers=1,
  $timeout_seconds=30
) {

  $venv = "${webapp::python::venv_root}/$name"
  $src = "${webapp::python::src_root}/$name"

  $is_present = $ensure == "present"

  $rundir = $python::celery::rundir
  $logdir = $python::celery::logdir
  $user  = $python::celery::owner
  $group = $python::celery::group

  $initscript = "/etc/init.d/celeryd-${name}"
  $defaultsfile = "/etc/defaults/celeryd-${name}"
  $pidfile = "$rundir/$name@%n.pid"
  $logfile = "$logdir/$name@%n.log"

  $celery_package = $version ? {
    undef => "Celery",
    default => "Celery==${version}",
  }

  if $is_present {
    python::pip::install { "$celery_package in $venv":
        package => $celery_package,
        ensure => $ensure,
        venv => $venv,
        owner => $owner,
        group => $group,
        require => Python::Venv::Isolate[$venv],
        before => File[$initscript];
    }
  }

  python::venv::isolate { $venv:
    ensure => $ensure,
    requirements => $requirements ? {
      true => "$src/requirements.txt",
      false => undef,
      default => "$src/$requirements",
    },
  }

  file { $initscript:
    ensure => $ensure,
    content => template("python/celeryd.init.erb"),
    mode => 775,
    group => $group,
  }

  file { $defaultsfile:
    ensure  => $ensure,
    content => template("python/celeryd-defaults.erb"),
    notify  => Service["celeryd-${name}"],
  }

  service { "celeryd-${name}":
    ensure => $is_present,
    enable => $is_present,
    hasstatus => $is_present,
    hasrestart => $is_present,
    subscribe => $ensure ? {
      'present' => [File[$initscript], File[$defaultsfile]],
      default => undef,
    },
    require => $ensure ? {
      'present' => [File[$initscript], File[$defaultsfile]],
      default => undef,
    },
    before => $ensure ? {
      'absent' => [File[$initscript], File[$defaultsfile]],
      default => undef,
    },
  }
}
