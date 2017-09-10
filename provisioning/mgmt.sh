#!/bin/bash

#
# INSTALL
#

# http://docs.ansible.com/ansible/latest/intro_installation.html

# Install Extra Packages
yum install epel-release -y

# install the epel-release RPM if needed on CentOS
yum install ansible -y

# Create key for nodes
[ -f /home/vagrant/.ssh/id_rsa ] && rm -f /home/vagrant/.ssh/id_rsa
sudo -u vagrant ssh-keygen -t rsa -f /home/vagrant/.ssh/id_rsa -q -P ""

# copy to shared folder
cp /home/vagrant/.ssh/id_rsa.pub /vagrant/assets/ansible/dyn_pub_key

# add to localhost as well
sh /vagrant/provisioning/injection.sh

# only allow mgmt server to login with this key
sed -i '1s/^/from="192.168.100.10" /' /vagrant/assets/ansible/dyn_pub_key
