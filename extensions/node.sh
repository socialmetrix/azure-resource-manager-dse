#!/usr/bin/env bash

# cloud_type="azure"
seed_node_location=$1
unique_string=$2
data_center_name=$3
opscenter_location=$4

echo "Input to node.sh is:"
# echo cloud_type $cloud_type
echo seed_node_location $seed_node_location
echo unique_string $unique_string
echo opscenter_location $opscenter_location

# seed_node_dns_name="dc0vm0$unique_string.$seed_node_location.cloudapp.azure.com"
# opscenter_dns_name="opscenter$unique_string.$opscenter_location.cloudapp.azure.com"

# echo "Calling dse.sh with the settings:"
# echo cloud_type $cloud_type
# echo seed_node_dns_name $seed_node_dns_name
# echo data_center_name $data_center_name
# echo opscenter_dns_name $opscenter_dns_name
# echo dse_version $dse_version

# apt-get -y install unzip

# wget https://github.com/DSPN/install-datastax-ubuntu/archive/5.0.1-5.zip
# unzip 5.0.1-5.zip
# cd install-datastax-ubuntu-5.0.1-5/bin

# #wget https://github.com/DSPN/install-datastax-ubuntu/archive/master.zip
# #unzip master.zip
# #cd install-datastax-ubuntu-master/bin

# ./dse.sh $cloud_type $seed_node_dns_name $data_center_name $opscenter_dns_name

echo "Installing the Oracle JDK"

# Install add-apt-repository
apt-get -y install software-properties-common

add-apt-repository -y ppa:webupd8team/java
apt-get -y update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
apt-get -y install oracle-java8-installer

# We're seeing Java installs fail intermittently.  Retrying indefinitely seems problematic.  I'm not sure
# what the correct solution is.  For now, we're just going to run the install a second time.  This will do
# nothing if the first install was successful and I suspect will eliminate the majority of our failures.
apt-get -y install oracle-java8-installer

##############################
#
# Format and attach Premium Storage
# Instructions here: 
# https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-classic-attach-disk/

# echo "n
# p
#
#
#
# w
# " | fdisk /dev/sdc
#
# mkfs -t ext4 /dev/sdc1
#
# mkdir -p /datadrive
#
# DISK_UUID=$(sudo -i blkid | grep /dev/sdc1 | awk -F'"' '{print $2}')
# if [[ -z $(grep -E "^UUID=${DISK_UUID}" /etc/fstab) ]]; then
#     echo >> /etc/fstab
#     echo "UUID=${DISK_UUID}     /datadrive    ext4    defaults,discard,nobootwait    1 2" | tee -a /etc/fstab
# fi
#
# mount /datadrive
#
# mkdir -p /datadrive/cassandra
#
# ln -s /datadrive/cassandra/ /var/lib/cassandra
#
# # Create a cassandra user and fix permissions
# useradd cassandra -M --home /var/lib/cassandra -s /bin/false
# chown cassandra /datadrive/cassandra
# chgrp cassandra /datadrive/cassandra
