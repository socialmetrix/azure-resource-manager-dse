#!/usr/bin/env bash

##############################
#
# Format and attach Premium Storage
# Instructions here: 
# https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-classic-attach-disk/

echo "n
p



w
" | fdisk /dev/sdc

mkfs -t ext4 /dev/sdc1

mkdir -p /datadrive

DISK_UUID=$(sudo -i blkid | grep /dev/sdc1 | awk -F'"' '{print $2}')
if [[ -z $(grep -E "^UUID=${DISK_UUID}" /etc/fstab) ]]; then
    echo >> /etc/fstab
    echo "UUID=${DISK_UUID}     /datadrive    ext4    defaults,discard,nobootwait    1 2" | tee -a /etc/fstab
fi

mount /datadrive

mkdir -p /datadrive/cassandra

ln -s /datadrive/cassandra/ /var/lib/cassandra

# Create a cassandra user and fix permissions
useradd cassandra -M --home /var/lib/cassandra -s /bin/false
chown cassandra /datadrive/cassandra
chgrp cassandra /datadrive/cassandra
