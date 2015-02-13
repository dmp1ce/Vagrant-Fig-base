#!/bin/bash

echo "Starting provisioning script."

# Update and upgrade apt
echo "set grub-pc/install_devices /dev/sda" | debconf-communicate
apt-get update 
apt-get upgrade -y

# Install docker
echo "Updating apt-get with docker."
wget -qO- https://get.docker.io/gpg | apt-key add -
sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
apt-get update 
apt-get upgrade -y
echo "Installing docker."
apt-get install -y lxc-docker

# Remove requirement for "sudo" for docker and fig
chmod o+rw /var/run/docker.sock

# Install fig
echo "Installing fig."
apt-get install -y python-pip
pip install -U fig

echo "Done provisioning."
