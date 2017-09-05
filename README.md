# Ansible Testing

**work in progress**  
Todo:
*



## Introduction

### Network Concept



### file structure
executing ansible-playbook directly on the guest machine.
```
Vagrantfile
provisioning
    roles/
        common/               # this hierarchy represents a "role"
            tasks/            #
                main.yml      #  <-- tasks file can include smaller files if warranted
            handlers/         #
                main.yml      #  <-- handlers file
            templates/        #  <-- files for use with the template resource
                ntp.conf.j2   #  <------- templates end in .j2
            defaults/         #
                main.yml      #  <-- default lower priority variables for this role
            meta/             #
                main.yml      #  <-- role dependencies
            library/          # roles can also include custom modules
            lookup_plugins/   # or other types of plugins, like lookup in this case
        webtier/              # same kind of structure as "common" was above, done for the webtier role
```

## Prerequisites

Add required vagrant boxes
```Bash
vagrant box add centos/7
```

Install `vagrant plugin install vagrant-scp`

Install plugin (broken for Win10/Win2016). Updates VBoxGuestAdditions on first boot
```Bash
vagrant plugin install vagrant-vbguest
```

This plugin allows you to use putty to ssh into VMs
```Bash
vagrant plugin install vagrant-multi-putty
set PATH=%PATH%;C:\Program Files (x86)\PuTTY
```

Start up server instance with `vagrant up`

## Ansible
### Firsts steps
Populate  known_hosts file with `ssh-keyscan lb web1 web2 >> .ssh/known_hosts`. This eliminates `The authenticity of host 'web1 (192.168.100.101)' can't be established.` eror.

Generate a new key with `ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa -q`. -N "" tells it to use an empty passsphrase, -q for silent.

Distribute ssh-keys to hosts:
```Bash
ansible-playbook ssh-addkey.yml --ask-pass
```

From Host cmd, copy over private key.
```Bash
#   fire: "C:\Users\dominic\.vagrant.d\insecure_private_key"
vagrant scp "C:\Users\dominic\.vagrant.d\insecure_private_key" [mgmt]:~/.ssh
**TODO**


## References
* [Best Practices — Ansible Documentation](http://docs.ansible.com/ansible/playbooks_best_practices.html#how-to-differentiate-staging-vs-production)
