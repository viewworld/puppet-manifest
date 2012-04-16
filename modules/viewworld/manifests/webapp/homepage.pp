class viewworld::webapp::homepage (
  $domain="${hostname}.viewworld.dk"
) {

  $binary_deps = [
    'libjpeg62-dev',        # JPEG support in PIL
    'zlib1g-dev',           # PNG support in PIL
  ]

  package { $binary_deps:
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

  $src = "${webapp::python::src_root}/homepage"

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

  webapp::python::instance { 'homepage':
    domain          => $domain,
    django          => true,
    django_settings => 'homepage.settings',
    mediaroot       => "${src}/homepage/media",
    mediaprefix     => '/media',
    ssl             => true,
    require         => Class['ssl']
  }

  Class['viewworld::appserver'] -> Class['viewworld::webapp::homepage']

}
