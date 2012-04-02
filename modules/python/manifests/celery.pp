class python::celery(
  $ensure=present,
  $owner=undef,
  $group=undef
) {

  $rundir = "/var/run/celery"
  $logdir = "/var/log/celery"

  if $ensure == "present" {
    file { [$rundir, $logdir]:
      ensure => directory,
      owner => $owner,
      group => $group,
    }

  } elsif $ensure == 'absent' {

    file { $rundir:
      ensure => $ensure,
      owner => $owner,
      group => $group,
    }
  }
}
