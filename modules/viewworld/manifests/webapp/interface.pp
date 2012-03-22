
class viewworld::webapp::interface (
  $domain="${hostname}.viewworld.dk",
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
      django          => true,
      django_settings => 'viewworld.settings',
      mediaroot       => "${src}/viewworld/static",
      mediaprefix     => '/static',
      ssl             => true,
      require         => Class['ssl']
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
