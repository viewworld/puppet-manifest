

class ldap {

  package { ['slapd', 'ldap-utils']:
    ensure => present,
  }

  service { 'slapd':
    ensure => running,
    enable => true,
    require => Package['slapd'],
  }

  $hashed_password = "{SSHA}pgtkrpvs4r/rQbdV+tz5+FQ7UEwTbVeD"
  $dit_ldif = "/etc/ldap/slapd.d/cn=config/olcDatabase={1}hdb.ldif"

  exec { "fix admin password":
    command => "sed -i '/^olcRootPW/ s@::\?.\+$@: ${hashed_password}@' '${dit_ldif}'",
    unless => "grep '${dit_ldif}' '${hashed_password}'",
    require => Package['slapd'],
    notify => Service['slapd'],
  }

}
