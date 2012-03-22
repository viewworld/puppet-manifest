define python::gunicorn::instance(
  $venv,
  $src,
  $ensure=present,
  $django_settings="",
  $version=undef,
  $workers=1,
  $timeout_seconds=30
) {

  $is_present = $ensure == "present"

  $rundir = $python::celeryd::rundir
  $logdir = $python::celeryd::logdir
  $owner = $python::celeryd::owner
  $group = $python::celeryd::group

  $initscript = "/etc/init.d/celeryd-${name}"
  $defaultsfile = "/etc/defaults/celeryd-${name}"
  $pidfile = "$rundir/$name@%n.pid"
  $logfile = "$logdir/$name@%n.log"

  if $django_settings != "" and !$django {
    fail("If you're not using Django you can't define a settings file.")
  }

  # $celery_package = $version ? {
    # undef => "gunicorn",
    # default => "gunicorn==${version}",
  # }

  # if $is_present {
    # python::pip::install {
      # "$gunicorn_package in $venv":
        # package => $gunicorn_package,
        # ensure => $ensure,
        # venv => $venv,
        # owner => $owner,
        # group => $group,
        # require => Python::Venv::Isolate[$venv],
        # before => File[$initscript];

      # # for --name support in gunicorn:
      # "setproctitle in $venv":
        # package => "setproctitle",
        # ensure => $ensure,
        # venv => $venv,
        # owner => $owner,
        # group => $group,
        # require => Python::Venv::Isolate[$venv],
        # before => File[$initscript];
    # }
  # }

  file { $initscript:
    ensure => $ensure,
    content => template("python/celeryd.init.erb"),
    mode => 775,
    group => $group,
    require => File["/etc/logrotate.d/gunicorn-${name}"],
  }

  # file { "/etc/logrotate.d/gunicorn-${name}":
    # ensure => $ensure,
    # content => template("python/gunicorn.logrotate.erb"),
  # }

  service { "celeryd-${name}":
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
