
Exec {
  path => [
    '/usr/local/bin',
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin',
  ],
}


node /^production\d+$/, test, /^test\d+$/ {

  include ldap
  include exist
  include viewworld::appserver
  include viewworld::webapp::interface

}

node /^worker\d+$/ {

  class { 'viewworld::appserver':
    worker => true,
  }
  class { 'viewworld::webapp::interface':
    worker => true,
  }

}
