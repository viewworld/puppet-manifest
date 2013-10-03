
class viewworld::webapp::careperfstats (
  $domain="${hostname}.viewworld.dk",
  $aliases=[]
) {

  $binary_deps = [
    'libpq-dev'
  ]

  package { $binary_deps:
    ensure => present,
  }

  $src = "${webapp::python::src_root}/careperfstats"

  file { $src:
    ensure => directory,
    owner => $viewworld::appserver::user,
    group => $viewworld::appserver::group,
  }

  file { "$src/careperfstats/file_uploads":
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

  webapp::python::instance { 'careperfstats':
    domain        => $domain,
    aliases       => $aliases,
    paster        => true,
    paster_config => "${src}/production.ini",
    staticroot    => "${src}/careperfstats/static",
    ssl           => false
  }

  python::celery::instance { 'careperfstats':
    app => "careperfstats.clry.celery",
    pyramid_config => "${src}/production.ini",
    django => false,
    install_venv => false,
  }

  Class['viewworld::appserver'] -> Class['viewworld::webapp::careperfstats']

}
