
class viewworld::webapp::interface (
  $domain="${hostname}.viewworld.dk",
  $aliases=[],
  $worker=false
) {

  $binary_deps = [
    'ant',
    'subversion',
    'gettext',
    'jsdoc-toolkit',
    'libxml2-dev',
    'libxslt1-dev',
    'libldap2-dev',
    'libsasl2-dev',
  ]

  package { $binary_deps:
    ensure => present,
  }

  if $worker {
    $extra_binary_deps = [
      'libjpeg62-dev',        # JPEG support in PIL
      'zlib1g-dev',           # PNG support in PIL
    ]

    package { $extra_binary_deps:
      ensure => present,
    }

    # Workaround for PIL on 64 bit machines
    file {
      '/usr/local/lib/libjpeg.so':
        ensure => link,
        target => '/usr/lib/x86_64-linux-gnu/libjpeg.so',
        require => Package['libjpeg62-dev'];
      '/usr/local/lib/libz.so':
        ensure => link,
        target => '/usr/lib/x86_64-linux-gnu/libz.so',
        require => Package['zlib1g-dev'];
    }
  }


  $src = "${webapp::python::src_root}/interface"

  file { $src:
    ensure => directory,
    owner => $viewworld::appserver::user,
    group => $viewworld::appserver::group,
  }

  exec { 'interface git':
    command => "git init ${src}",
    creates => "${src}/.git/config",
    user    => $viewworld::appserver::user,
    require => File[$src],
  }

  if !$worker {
    webapp::python::instance { 'interface':
      domain          => $domain,
      aliases         => $aliases,
      django          => true,
      django_settings => 'viewworld.settings',
      staticroot      => "${src}/viewworld/static",
      ssl             => true,
      require         => Class['ssl']
    }
  } else {
    python::celery::instance { 'interface':
      django_settings => 'viewworld.settings',
      app => 'viewworld.rest.tasks:app',
    }
  }

  # file { "${src}/viewworld/settings":
    # ensure => directory,
    # recurse => true,
    # owner => $webapp::python::owner,
    # group => $webapp::python::group,
  # }

  # $exist_port = $exist::port

  # file { "${src}/viewworld/settings/local.py":
    # content => template('viewworld/interface_local.py.erb'),
    # owner => $webapp::python::owner,
    # group => $webapp::python::group,
    # require => File["${src}/viewworld/settings"],
    # notify => Service['gunicorn-interface'],
  # }

  Class['viewworld::appserver'] -> Class['viewworld::webapp::interface']

}
