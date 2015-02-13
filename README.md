# Base project for Fig and Docker projects

Using this project it should be easy to get started with Fig and Docker.

# Requirements

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [NFS](http://docs.vagrantup.com/v2/synced-folders/nfs.html).  Or set the environment variable `VAGRANT_NFS` to `OFF` to not use NFS for Vagrant file sharing.

# Usage

```
vagrant up
vagrant ssh
fig version
cd /vagrant
fig run --rm test echo 'Welcome to busybox'
```

Feel free to build the fig environment you want to work with!
