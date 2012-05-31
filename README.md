

# Setting up a new server

```console
$ # Start new instance via Amazon EWS Console
$ # Copy ssh key to new instance
local:~$ cat ~/.ssh/id_rsa.pub | ssh -i rbpkey.pem $HOSTNAME tee -a .ssh/authorized_keys

$ # Setup hostname
$ echo $HOSTNAME | sudo tee /etc/hostname
$ sudo hostname -F /etc/hostname
$ echo 127.0.0.1  $HOSTNAME.viewworld.dk $HOSTNAME | sudo tee /etc/hosts
$ echo $PUPPETMASTERIP puppet.viewworld.dk puppet

$ sudo aptitude update
$ sudo aptitude upgrade
$ sudo ntpdate ntp.ubuntu.com

$ # If on micro instance: setup swap for exist installation
$ sudo dd if=/dev/zero of=/var/swapfile bs=1M count=512
$ sudo chmod 600 /var/swapfile
$ sudo mkswap /var/swapfile
$ sudo swapon /var/swapfile

$ # Install puppet
$ sudo aptitude install puppet
$ sudo vim /etc/puppet/puppet.conf # add server = puppet.viewworld.dk in main section
$ sudo vim /etc/hosts
$ sudo puppet agent --test --waitforcert 10

$ # In another terminal: sign cert on puppet master (puppet.viewworld.dk)
puppet:~$ sudo puppet cert sign $HOSTNAME.viewworld.dk

$ # Import initial LDAP config
$ ldapadd -x -D cn=admin,dc=viewworld,dc=dk -W -f /etc/ldap/viewworld.ldif

$ # Push application
$ # On local machine
local:~/console$ fab master deploy -H $HOSTNAME.viewworld.dk
```

# Transfering data

```console
source-server:~$ ldapsearch -x -LLL -D cn=admin,dc=viewworld,dc=dk -W -b dc=viewworld,dc=dk | tee viewworld.ldif
source-server:~$ cd /var/lib/exist
source-server:/var/lib/exist$ sudo tar -czpf exist.tar.gz *

# copy viewworld.ldif and exist.tar.gz to dest server

dest-server:~$ # remove password prompt from viewworld.ldif
dest-server:~$ ldapadd -x -D cn=admin,dc=viewworld,dc=dk -W -c -f viewworld.ldif
dest-server:~$ cd /var/lib/exist
dest-server:/var/lib/exist$ sudo rm -r *
dest-server:/var/lib/exist$ sudo tar -xzf ~/exist.tar.gz
dest-server:/var/lib/exist$ sudo chown -R exist:exist *
```
