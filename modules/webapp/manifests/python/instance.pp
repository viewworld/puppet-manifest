define webapp::python::instance($domain,
                                $ensure=present,
                                $aliases=[],
                                $mediaroot="",
                                $mediaprefix="/media",
                                $staticroot="",
                                $staticprefix="/static",
                                $adminmediaprefix="/static/admin",
                                $wsgi_module="",
                                $django=false,
                                $django_settings="",
                                $paster=false,
                                $paster_config="",
                                $requirements=false,
                                $workers=1,
                                $timeout_seconds=30,
                                $monit_memory_limit=300,
                                $monit_cpu_limit=50,
                                $ssl=false) {

  $venv = "${webapp::python::venv_root}/$name"
  $src = "${webapp::python::src_root}/$name"

  $pidfile = "${python::gunicorn::rundir}/${name}.pid"
  $socket = "${python::gunicorn::rundir}/${name}.sock"

  $owner = $webapp::python::owner
  $group = $webapp::python::group

  Webapp::Python::Instance[$name] -> File[$src]

  if $ssl {
    include ssl
    $ssl_certificate = $Ssl::bundle
    $ssl_certificate_key = $Ssl::key
    Class['ssl'] -> Nginx::Site[$name]
  } else {
    $ssl_certificate = undef
    $ssl_certificate_key = undef
  }

  nginx::site { $name:
    ensure => $ensure,
    domain => $domain,
    aliases => $aliases,
    root => "/var/www/$name",
    mediaroot => $mediaroot,
    mediaprefix => $mediaprefix,
    staticroot => $staticroot,
    staticprefix => $staticprefix,
    adminmediaprefix => $adminmediaprefix,
    upstreams => ["unix:${socket}"],
    owner => $owner,
    group => $group,
    ssl => $ssl,
    ssl_certificate => $ssl_certificate,
    ssl_certificate_key => $ssl_certificate_key,
    require => Python::Gunicorn::Instance[$name],
  }

  python::venv::isolate { $venv:
    ensure => $ensure,
    requirements => $requirements ? {
      true => "$src/requirements.txt",
      false => undef,
      default => "$src/$requirements",
    },
  }

  python::gunicorn::instance { $name:
    ensure => $ensure,
    venv => $venv,
    src => $src,
    wsgi_module => $wsgi_module,
    django => $django,
    django_settings => $django_settings,
    paster => $paster,
    paster_config => $paster_config,
    workers => $workers,
    timeout_seconds => $timeout_seconds,
    require => $ensure ? {
      'present' => Python::Venv::Isolate[$venv],
      default => undef,
    },
    before => $ensure ? {
      'absent' => Python::Venv::Isolate[$venv],
      default => undef,
    },
  }

  $reload = "/etc/init.d/gunicorn-$name reload"

  monit::monitor { "gunicorn-$name":
    ensure => $ensure,
    pidfile => $pidfile,
    socket => $socket,
    checks => ["if totalmem > $monit_memory_limit MB for 2 cycles then exec \"$reload\"",
               "if totalmem > $monit_memory_limit MB for 3 cycles then restart",
               "if cpu > ${monit_cpu_limit}% for 2 cycles then alert"],
    require => $ensure ? {
      'present' => Python::Gunicorn::Instance[$name],
      default => undef,
    },
    before => $ensure ? {
      'absent' => Python::Gunicorn::Instance[$name],
      default => undef,
    },
  }
}
