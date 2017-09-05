#!/bin/bash

#
# INSTALL
#

# http://docs.ansible.com/ansible/latest/intro_installation.html

# Install Extra Packages
yum install epel-release -y

# install the epel-release RPM if needed on CentOS
yum install ansible -y

# Copy files
cp -a /vagrant/assets/ansible/* /home/vagrant
chown -R vagrant:vagrant /home/vagrant
rm -f /home/vagrant/.ssh/id_rsa
mv /home/vagrant/insecure_private_key /home/vagrant/.ssh/id_rsa
chmod 600 /home/vagrant/.ssh/id_rsa

cat << 'EOF' >> /etc/hosts
192.168.100.100    lb
192.168.100.101    web1
192.168.100.102    web2
EOF
