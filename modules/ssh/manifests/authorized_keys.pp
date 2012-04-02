
define ssh::authorized_keys($user=undef) {

  ssh_authorized_key { "Michael Budde <mb@viewworld.dk> for ${user}":
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC0rqGOHlTmgn2lhVXwoW1dyOWNf4DgDG8WLoRMDvPoHeVpGpfodmX+BRoSO2Ev1gBzbIfSKK7lL9WS8pm/hIgV4TQ0ESN802k8xcPDkQUe4F/Y886o0cRrMPMdGpA33uePqc05o6pnXqYCiUiuquLqIQ3e3AuOGWG47m5tXaTCMxE4g1FLup1sBbZXxQwOfSaBY99nDY706raCp0/6KFBYsceNqsccCio2eeQd2LuJOLhLF0O2RScA9FTGhIxcoapb78kLXi47HVFFE8EsykpFTgjYbCquEPoeNdTzm7mRzGP85kIcCpW0n3TjdK0JDbRhl2vsPHTCjMz8zb0VOaXx',
    user => $user,
  }

  ssh_authorized_key { "Jon Elverkilde <jde@viewworld.dk> for ${user}":
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCcTjQEoUVALH/81BxzGSu9iCwGmkpKBk6pVFb6VKsi4OSFKMLlW4Mk28YI1c5Orbbojebmv7Z6muA6v2HFMqIEf0TThoBqh3TgpYLOb9MSd1HCCJHnHvhkhr7fEbGWZZ/9s4NKRUbmWMeUoKQXNmW2eA6nM+ETfvSYp5CXRsUnqxQJR6Gq93wFjyaib+kGbrIE95AXaEuIMvUtlW2kfxZq/v8FymbzkvwszTjSZEoOwKk2olKCe4LTmWdE2qdl9qLvqy9ydRyBmw4xwXaCLFsOGJ2naPm7CVcD4czUmzVQ4W0Xy5blAIaCUs71S0XB+cvLFTgXm4vFsWhvpn1hC+wn',
    user => $user,
  }

  ssh_authorized_key { "Rune Bech Persson <rbp@viewworld.dk> for ${user}":
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQChbPf5JrKpkXy68r0ed0QVhF6YbE/hqWMkbDDfN2LrmqY5Yya7d+A767WerVOUl9ZrfnC3EZY5gOXzA78W3DWp7w2YYJ6vMgV6DwHf8DHjzUkdwylUd5C+sWB2d9W9oPfmnbTLq1pTNtot2HFIPXZolFuXndktL8hY3bfuDyCXaGOAAWy9qYTo+sgp7UJrSjUBDE4D4yYDSpoCkhujmsB0GLhco4GxbPqk0ubimLQzx+IcdwRnYLu1/E2ULfmevJpND1zzVfZ3ul1CaaWAewteoCsG+8a92oOFZCIqXgf1MshfzyaSWKoAV3HeWcr3TqwyEz4gXT3CNfGrs5FYR+P7',
    user => $user,
  }

}
