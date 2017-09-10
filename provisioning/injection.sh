#!/bin/bash

# Add mgmt key to authorized_key
[ -f /home/vagrant/.ssh/authorized_keys ] || touch /home/vagrant/.ssh/authorized_keys
cat /vagrant/assets/ansible/dyn_pub_key >> /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
