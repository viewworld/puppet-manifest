
Exec {
  path => [
    '/usr/local/bin',
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin',
  ],
}


node 'test' {

  include ldap
  include exist
  include viewworld::appserver
  include viewworld::webapp::interface

}
