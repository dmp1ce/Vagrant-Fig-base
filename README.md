 Base project for Fig and Docker projects

Using this project it should be easy to get started with Fig and Docker.

# Requirements

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [NFS](http://docs.vagrantup.com/v2/synced-folders/nfs.html).  Or set the environment variable `VAGRANT_NFS` to `OFF` to not use NFS for Vagrant file sharing.

# Usage

How to test that Fig works in Vagrant environment.

```
vagrant up
vagrant ssh
fig version
cd /vagrant
fig run --rm test echo 'Welcome to busybox'
```

How to add your own Fig project to this base. From your host, outside of Vagrant.


```
git clone https://github.com/your_user/your_repository your_project_directory
cd your_project_directory
git submodule update --init --recursive
```

OR to add the project and track it as a Git submodule.

```
git submodule add https://github.com/your_user/your_repository your_project_directory
git submodule update --init --recursive
```

Build the Fig environment you want!
