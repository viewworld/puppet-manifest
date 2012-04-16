
class ssl {

  $key = '/etc/ssl/private/viewworld'
  $cert = '/etc/ssl/certs/viewworld.pem'
  $bundle = '/etc/ssl/certs/gd_bundle.pem'
  $chained = '/etc/ssl/certs/viewworld.chained.pem'

  file { $cert:
    source => 'puppet:///modules/ssl/viewworld.pem',
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  file { $bundle:
    source => 'puppet:///modules/ssl/gd_bundle.pem',
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  file { $key:
    source => 'puppet:///modules/ssl/viewworld.key', # Must be placed on puppet master manually
    owner => 'root',
    group => 'root',
    mode => '0600',
  }

  exec { 'chain certificates':
    command => "cat ${cert} ${bundle} > ${chained}",
    creates => $chained,
    require => [File[$bundle], File[$cert]],
  }

  file { $chained:
    owner => 'root',
    group => 'root',
    mode => '0600',
    require => Exec['chain certificates'],
  }

}
