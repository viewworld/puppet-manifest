
define ssh::authorized_keys($user=undef) {

  ssh_authorized_key { 'Michael Budde <mb@viewworld.dk>':
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC0rqGOHlTmgn2lhVXwoW1dyOWNf4DgDG8WLoRMDvPoHeVpGpfodmX+BRoSO2Ev1gBzbIfSKK7lL9WS8pm/hIgV4TQ0ESN802k8xcPDkQUe4F/Y886o0cRrMPMdGpA33uePqc05o6pnXqYCiUiuquLqIQ3e3AuOGWG47m5tXaTCMxE4g1FLup1sBbZXxQwOfSaBY99nDY706raCp0/6KFBYsceNqsccCio2eeQd2LuJOLhLF0O2RScA9FTGhIxcoapb78kLXi47HVFFE8EsykpFTgjYbCquEPoeNdTzm7mRzGP85kIcCpW0n3TjdK0JDbRhl2vsPHTCjMz8zb0VOaXx',
    user => $user,
  }

  ssh_authorized_key { 'Jon Elverkilde <jde@viewworld.dk>':
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCcTjQEoUVALH/81BxzGSu9iCwGmkpKBk6pVFb6VKsi4OSFKMLlW4Mk28YI1c5Orbbojebmv7Z6muA6v2HFMqIEf0TThoBqh3TgpYLOb9MSd1HCCJHnHvhkhr7fEbGWZZ/9s4NKRUbmWMeUoKQXNmW2eA6nM+ETfvSYp5CXRsUnqxQJR6Gq93wFjyaib+kGbrIE95AXaEuIMvUtlW2kfxZq/v8FymbzkvwszTjSZEoOwKk2olKCe4LTmWdE2qdl9qLvqy9ydRyBmw4xwXaCLFsOGJ2naPm7CVcD4czUmzVQ4W0Xy5blAIaCUs71S0XB+cvLFTgXm4vFsWhvpn1hC+wn',
    user => $user,
  }

}
