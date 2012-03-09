

# Setting up a new server

```console
# Start new instance
# Copy ssh key
$ cat .ssh/id_rsa.pub | ssh -i rbpkey.pem $HOSTNAME tee -a .ssh/authorized_keys

# Setup hostname
$ echo $HOSTNAME | sudo tee /etc/hostname
$ sudo hostname -F /etc/hostname
$ echo 127.0.0.1  $HOSTNAME.viewworld.dk $HOSTNAME | sudo tee /etc/hosts

$ sudo aptitude update
$ sudo aptitude upgrade

# Setup eXist
$ sudo aptitude install openjdk-6-jre-headless openjdk-6-jdk
$ # Download exist jar installer
$ sudo java -jar exist.jar /opt/exist

# Install puppet
$ sudo aptitude install puppet
$ sudo vim /etc/puppet/puppet.conf # add server = puppet.viewworld.dk in main section
$ sudo puppet agent --test --waitforcert 10

# On puppet master
$ sudo puppet cert sign $HOSTNAME.viewworld.dk

$ cd /opt/exist
$ sudo mkdir build/classes
$ sudo ./build.sh extension-modules

$ ldapadd -x -D cn=admin,dc=viewworld,dc=dk -W -f /etc/ldap/viewworld.ldif

$ # Push application

$ sudo -iu appmgr
$ . venv/interface/bin/activate
$ cd src/interface
$ python manage.py syncdb
$ cd xqueries
$ ant store
```

