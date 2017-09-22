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
ansible/
    group_vars            # group variables
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
### Chocolatey
Install Chocolatey to get a packet based installer in Windows.
Run elevated cmd with `cmd` [CTRL+ENTER].
```Bash
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
```
### Ansible
1. Turn on Developer mode (settings > update and security > for developers)
2. PowerShell as admin and run `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`

### Kitchen
Install ChefDK to get kitchen CI with `choco install chefdk -Y`

### vagrant
Install Vagrant with `choco install vagrant -Y`

Add required vagrant boxes
```Bash
vagrant box add centos/7
```

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
### Terms
* **Controller Machine**: the machine where Ansible is installed, responsible for running the provisioning on the servers you are managing
* **Inventory**: an INI file that contains information about the servers you are managing
Playbook: the entry point for Ansible provisionings, where the automation is defined through tasks using YAML format
* **Task**: a block that defines a single procedure to be executed, e.g.: install a package
* **Module**: a module typically abstracts a system task, like dealing with packages or creating and changing files. Ansible has a multitude of built-in modules, but you can also create custom ones
* **Role**: a pre-defined way for organizing playbooks and other files in order to facilitate sharing and reusing portions of a provisioning
* **Play**: a provisioning executed from start to finish is called a play
* **Facts**: global variables containing information about the system, like network interfaces or operating system
* **Handlers**: used to trigger service status changes, like restarting or stopping a service

### Vagrant
Environment variable for hosts file `export ANSIBLE_HOSTS=/vagrant/provisioning/inventory`

### Hardening

sudo ansible-galaxy install dev-sec.os-hardening
sudo ansible-galaxy install openmicroscopy.local-accounts



## References
* [Best Practices — Ansible Documentation](http://docs.ansible.com/ansible/playbooks_best_practices.html#how-to-differentiate-staging-vs-production)
