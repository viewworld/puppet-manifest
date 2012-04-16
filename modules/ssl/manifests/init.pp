
class ssl {

  $cert = '/etc/ssl/private/viewworl.chained'
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

  exec { 'chain certificates':
    command => "cat /etc/ssl/private/viewworld /etc/ssl/certs/gd_bundle.pem > ${cert}",
    creates => $cert,
    require => [File['/etc/ssl/certs/gd_bundle.pem'], File['/etc/ssl/private/viewworld']],
  }

  file { $cert:
    owner => 'root',
    group => 'root',
    mode => '0600',
    require => Exec['chain certificates'],
  }

}
