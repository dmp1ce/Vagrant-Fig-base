#!/bin/bash

echo "Starting provisioning script."

# Set umask to a value that will work with apacman
# and docker.sock will get correct permissions.
umask 022

# Get an updated list of mirrors and then rank them.
if [ ! -f /etc/pacman.d/mirrorlist.new ]; then
    wget -O /etc/pacman.d/mirrorlist.new 'https://www.archlinux.org/mirrorlist/?country=US&protocol=http&ip_version=4'
    sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.new
    rankmirrors -n 6 /etc/pacman.d/mirrorlist.new > /etc/pacman.d/mirrorlist
fi

# Update packages
echo "Updating packages"
pacman -Syu --needed --noconfirm
# Upgrade pacman, just in case.
pacman-db-upgrade

# Install Docker
echo "Installing Docker."
pacman -S --needed --noconfirm docker

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
systemctl restart rpcbind
systemctl restart nfs-client.target

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

echo "Installing Fig"
# Install Fig and it's dependencies
/opt/apacman/apacman -S --needed --noconfirm python2-docker-py
# Remove a conflicting library (issue with Fig install)
/opt/apacman/apacman -Rdd --noconfirm python2-websocket-client
# Finally, install Fig
/opt/apacman/apacman -S --needed --noconfirm fig

echo "Done provisioning"
