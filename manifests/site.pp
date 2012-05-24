
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

  case $hostname {
    'production1': {
      class { 'viewworld::webapp::interface':
        domain  => 'viewworld.dk',
      }
    }
    default: {
      include viewworld::webapp::interface
    }
  }

}

node homepage, /^homepage\d+$/ {

  include viewworld::appserver
  include viewworld::webapp::homepage

  class { 'viewworld::webapp::docs':
    domain => 'docs.viewworld.net',
  }
}

node /^worker\d+$/ {

  class { 'viewworld::appserver':
    worker => true,
  }
  class { 'viewworld::webapp::interface':
    worker => true,
  }

}
