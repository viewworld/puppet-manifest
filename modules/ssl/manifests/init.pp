
class ssl {

  $key_filename = $hostname ? {
    /homepage(\d+)?/ => 'viewworldnet.key',
    default          => 'viewworld.key',
  }

  $bundle_filename = $hostname ? {
    /homepage(\d+)?/ => 'viewworldnet-bundle.pem',
    'production1'    => 'viewworld.dk.crt',
    default          => 'viewworlddk-bundle.pem', # expires on 2013-03-15
  }

  $key = '/etc/ssl/private/viewworld'
  $bundle = "/etc/ssl/certs/${bundle_filename}"

  file { $bundle:
    source => "puppet:///modules/ssl/${bundle_filename}",
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service[nginx],
  }

  file { $key:
    source => "puppet:///modules/ssl/${key_filename}", # Must be placed on puppet master manually
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    notify => Service[nginx],
  }

}
