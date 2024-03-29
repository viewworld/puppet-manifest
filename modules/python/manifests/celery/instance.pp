define python::celery::instance(
  $ensure=present,
  $pyramid_config="",
  $django=true,
  $django_settings="",
  $requirements=false,
  $version=undef,
  $app="",
  $workers=1,
  $install_venv=true
) {

  $venv = "${webapp::python::venv_root}/$name"
  $src = "${webapp::python::src_root}/$name"

  $is_present = $ensure == "present"

  $rundir = $python::celery::rundir
  $logdir = $python::celery::logdir
  $user  = $python::celery::owner
  $group = $python::celery::group

  $initscript = "/etc/init.d/celeryd-${name}"
  $defaultsfile = "/etc/default/celeryd-${name}"
  $pidfile = "$rundir/${name}/%n.pid"
  $logfile = "$logdir/${name}/%n.log"

  $celery_package = $version ? {
    undef => "celery",
    default => "celery==${version}",
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

  if $install_venv {
    python::venv::isolate { $venv:
      ensure => $ensure,
      requirements => $requirements ? {
        true => "$src/requirements.txt",
        false => undef,
        default => "$src/$requirements",
      },
    }
  }

  file { $initscript:
    ensure => $ensure,
    source => $python::celery::initscript,
    mode   => 755,
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
