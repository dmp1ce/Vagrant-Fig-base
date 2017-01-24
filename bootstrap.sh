#!/bin/bash

echo "Starting provisioning script."

# Set umask to a value that will work with apacman
# and docker.sock will get correct permissions.
umask 022

# Change umask for future.
sed -i '/umask 027/c\#umask 027' /home/vagrant/.profile
sed -i '/#umask 022/c\umask 022' /home/vagrant/.profile

# Get an updated list of mirrors and then rank them.
if [ ! -f /etc/pacman.d/mirrorlist.new ]; then
    wget -O /etc/pacman.d/mirrorlist.new 'https://www.archlinux.org/mirrorlist/?country=US&protocol=http&ip_version=4'
    sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.new
    rankmirrors -n 6 /etc/pacman.d/mirrorlist.new > /etc/pacman.d/mirrorlist
fi

# Update pacman keys
echo "Updating pacman GPG keys"
pacman-key -r 8D8172C8

# Update packages
echo "Updating packages"
pacman -Syu --needed --noconfirm
# Upgrade pacman, just in case.
pacman-db-upgrade

# Install Docker
echo "Installing Docker and Docker Compose."
pacman -S --needed --noconfirm docker docker-compose

# Start Docker
echo "Enabling Docker"
systemctl enable docker
systemctl restart docker

# Remove requirement for "sudo" for docker and fig
echo "Allowing non-root to run docker"
gpasswd -a vagrant docker

# Install NFS
echo "Installing NFS"
pacman -S --needed --noconfirm nfs-utils

# Start NFS services
echo "Enabling NFS client"
systemctl enable rpcbind
systemctl enable nfs-client.target
systemctl enable remote-fs.target
systemctl restart rpcbind
systemctl restart nfs-client.target
systemctl restart remote-fs.target

# Install Fig
# Requirements for AUR helper
echo "Installing AUR helper (apacman)"
pacman -S --needed --noconfirm base-devel jshon
## Get AUR helper to install Fig
if [ ! -f /opt/apacman/apacman ]; then
    git clone https://github.com/oshazard/apacman /opt/apacman
    chmod +x /opt/apacman/apacman
else
    echo "Using previously installed apacman"
fi

echo "Installing decompose"
/opt/apacman/apacman -S --needed --noconfirm decompose-git

echo "Done provisioning"
