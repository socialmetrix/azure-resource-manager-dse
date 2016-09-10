#!/usr/bin/env bash

cloud_type="azure"
seed_node_location=$1
unique_string=$2

echo "Input to node.sh is:"
echo cloud_type $cloud_type
echo seed_node_location $seed_node_location
echo unique_string $unique_string

seed_node_dns_name="dc0vm0$unique_string.$seed_node_location.cloudapp.azure.com"

echo "Calling opscenter.sh with the settings:"
echo cloud_type $cloud_type
echo seed_node_dns_name $seed_node_dns_name

# apt-get -y install unzip

# wget https://github.com/DSPN/install-datastax-ubuntu/archive/5.0.1-5.zip
# unzip 5.0.1-5.zip
# cd install-datastax-ubuntu-5.0.1-5/bin

# #wget https://github.com/DSPN/install-datastax-ubuntu/archive/master.zip
# #unzip master.zip
# #cd install-datastax-ubuntu-master/bin

# ./opscenter.sh $cloud_type $seed_node_dns_name


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
