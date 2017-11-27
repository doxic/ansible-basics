# Testing

## Syntax test
test syntax for errors
```
ansible-playbook provision.yml --syntax-check
```

## Dry run
Run playboo without making changes to the target. See if tasks **can** run, not if they will.
```
ansible-playbook provision.yml --check```
