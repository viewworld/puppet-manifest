
class ssl {

  $cert = '/etc/ssl/certs/viewworld.pem'
  $key = '/etc/ssl/private/viewworld'

  file { $cert:
    source => 'puppet:///modules/ssl/viewworld.pem',
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  file { '/etc/ssl/certs/gd_bundle.pem':
    source => 'puppet:///modules/ssl/gd_bundle.pem',
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  file { '/etc/ssl/private/viewworld':
    source => 'puppet:///modules/ssl/viewworld.key', # Must be placed on puppet master manually
    owner => 'root',
    group => 'root',
    mode => '0600',
  }

}
