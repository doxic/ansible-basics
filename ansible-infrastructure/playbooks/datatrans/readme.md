# Syntax test

The first thing you should do after writing any configuration script is to test it’s syntax for errors. Most errors are syntax related so don’t hesitate to run a quick check.
```
ansible-playbook provision.yml --syntax-check
```

# Dry run
```
ansible-playbook provision.yml --check
```

# Facts
To see what facts are configured on a host, run command:
```
user@host:~$ ansible <hostname> -s -m setup -a 'filter=ansible_local'
```
