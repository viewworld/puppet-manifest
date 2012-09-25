
class ssl {

  $key_filename = $hostname ? {
    /homepage(\d+)?/ => 'viewworldnet.key',
    default          => 'viewworld.key',
  }

  $bundle_filename = $hostname ? {
    /homepage(\d+)?/ => 'viewworldnet-bundle.pem',
    default          => 'viewworlddk-bundle.pem',
  }

  $key = '/etc/ssl/private/viewworld'
  $bundle = "/etc/ssl/certs/${bundle_filename}"

  file { $bundle:
    source => "puppet:///modules/ssl/${bundle_filename}",
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  file { $key:
    source => "puppet:///modules/ssl/${key_filename}", # Must be placed on puppet master manually
    owner => 'root',
    group => 'root',
    mode => '0600',
  }

}
