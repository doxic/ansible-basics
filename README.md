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
Get ssh information with `vagrant ssh-config` or login directly via putty `vagrant putty`


Environment variable for hosts file `export ANSIBLE_HOSTS=/vagrant/provisioning/hosts`
Environment variable for ansible.cfg file `export ANSIBLE_CONFIG=/vagrant/provisioning/ansible.cfg`

### Hardening

sudo ansible-galaxy install dev-sec.os-hardening
sudo ansible-galaxy install openmicroscopy.local-accounts



## Concepts
1. Vagrant with ansible_local provisioning script (windows-proof)
2. Set root password with prehashed SHA512 string
3. Create local user accounts with long and complex passwords
4. Add local SSH keys
5. Harden ssh client
6. Harden ssh server
7. Posting successful SSH logins to Slack

### SSH keys
SSH keys are always generated in pairs with one known as the private key and the other as the public key. The private key is known only to you and it should be safely guarded. A private key is a guarded secret and as such it is advisable to store it on disk in an encrypted form. [SSH keys - ArchWiki]

#### ed25519
We use a ed25519 elliptic curve signature scheme which rely on the elliptic curve discrete logarithm problem, its main strengths are its speed, its constant-time run time and resistance against side-channel attacks.

Ed25519 key pairs can be generated with `ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)-$(date +%Y%m%d)"  -f $HOME/.ssh/id_ed25519 -N ""`
#### RSA with Yubikey
**TODO**

### Slack Notifications
Setup Incoming Web Hook via https://YOUR_DOMAIN.slack.com/apps/manage/custom-integrations  


## References
* [Best Practices — Ansible Documentation](http://docs.ansible.com/ansible/playbooks_best_practices.html#how-to-differentiate-staging-vs-production)
* [Ansible security best practices - Server Fault](https://serverfault.com/questions/823956/ansible-security-best-practices/823991)
* [SSH keys - ArchWiki](https://wiki.archlinux.org/index.php/SSH_keys)
* [Ed25519 Keys | Brian Warner](https://blog.mozilla.org/warner/2011/11/29/ed25519-keys/)
* [PGP and SSH keys on a Yubikey NEO « Eric Severance](https://www.esev.com/blog/post/2015-01-pgp-ssh-key-on-yubikey-neo/)
* [Posting successful SSH logins to Slack](http://sandrinodimattia.net/posting-successful-ssh-logins-to-slack/)
