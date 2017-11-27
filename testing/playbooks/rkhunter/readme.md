# Setup rkhunter
(https://www.digitalocean.com/community/tutorials/how-to-use-rkhunter-to-guard-against-rootkits-on-an-ubuntu-vps)

## Initial Test Runs
Perform initial run to see errors
```
rkhunter -c --enable all --disable none --rwo
```

## Configure RKHunter Known-Good Values
