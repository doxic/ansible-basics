Based on Sandrino Di Mattia, Ross Duggan, STALKR

## Setup
Vault based on Best Practice example `mkdir -p group_vars/all/`
```
├── group_vars/            # group variables
│   └── all/
│       ├── vars
│       └── vault
```

create a vault-encrypted file within the directory `ansible-vault create group_vars/all/vault`

Reverence data to Vault
```
---
# nonsensitive data
mysql_port: 3306
mysql_host: 10.0.0.3
mysql_user: fred

# sensitive data
mysql_password: "{{ vault_mysql_password }}"
```

## References
* [duggan/ansible-slack-notify-ssh: Post successful SSH logins to Slack](https://github.com/duggan/ansible-slack-notify-ssh)
* [Posting successful SSH logins to Slack](http://sandrinodimattia.net/posting-successful-ssh-logins-to-slack/)
* [Variables and Vaults](http://docs.ansible.com/ansible/latest/playbooks_best_practices.html#variables-and-vaults)
* [How To Use Vault to Protect Sensitive Ansible Data on Ubuntu 16.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-use-vault-to-protect-sensitive-ansible-data-on-ubuntu-16-04)
* [StalkR's Blog: Login notifications, pam_exec scripting](https://blog.stalkr.net/2010/11/login-notifications-pamexec-scripting.html)
* [pam_exec(8) - Linux manual page](http://man7.org/linux/man-pages/man8/pam_exec.8.html)
