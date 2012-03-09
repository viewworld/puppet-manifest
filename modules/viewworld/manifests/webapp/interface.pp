
class viewworld::webapp::interface (
  $domain="${hostname}.viewworld.dk"
) {

  $binary_deps = [
    'ant',
    'subversion',
    'libxml2-dev',
    'libxslt1-dev',
    'libldap2-dev',
    'libsasl2-dev',
  ]

  package { $binary_deps:
    ensure => present,
    before => Webapp::Python::Instance['interface']
  }

  $src = "${webapp::python::src_root}/interface"

  webapp::python::instance { 'interface':
    domain          => $domain,
    django          => true,
    django_settings => 'viewworld.settings',
    mediaroot       => "${src}/viewworld/static",
    mediaprefix     => '/static',
    ssl             => true,
    require         => Class['ssl']
  }

  exec { "interface git":
    command => "git init ${src}",
    creates => "${src}/.git/config",
    user => $webapp::python::owner,
    group => $webapp::python::group,
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
