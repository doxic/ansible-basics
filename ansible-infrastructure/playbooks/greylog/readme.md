# Manual setup
(http://docs.graylog.org/en/2.3/pages/installation/manual_setup.html#manual-setup)

## Apt settings
Changing Ubuntu APT mirror
```
sudo sed -i "s/http:\/\/us.archive/http:\/\/ch.archive/g" /etc/apt/sources.list
sudo apt-get update
```

## Install openjdk
Install openjdk
```
sudo apt install -y openjdk-8-jre-headless
```

## Install elasticsearch

Import the Elasticsearch PGP Key
```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```

Save the repository definition to `/etc/apt/sources.list.d/elastic-5.x.list`:
```
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
```

You can install the Elasticsearch Debian package with:
```
sudo apt-get update && sudo apt-get install elasticsearch
```

configure Elasticsearch to start automatically when the system boots up
```
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service
```

start Elasticsearch
```
sudo systemctl start elasticsearch.service
```

## mongodb
(https://docs.mongodb.com/master/tutorial/install-mongodb-on-ubuntu/)

Adding the MongoDB Repository
```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
```
Save the repository definition to `/etc/apt/sources.list.d/mongodb-org-3.4.list`:
```
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee -a /etc/apt/sources.list.d/mongodb-org-3.4.list
```

Installing MongoDB
https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-mongodb-on-ubuntu-16-04
```
sudo apt-get update && sudo apt-get install -y mongodb-org
```
configure mongodb to start automatically when the system boots up
```
sudo systemctl enable mongod
```

start mongodb
```
sudo systemctl start mongod
```


## Greylog

Download the tar archive from the download pages and extract it on your system:
```
GREYLOG_VERSION="2.3.2"
curl -L https://packages.graylog2.org/releases/graylog/graylog-$GREYLOG_VERSION.tgz | tar xvz
cd graylog-$GREYLOG_VERSION
```

create folder
```
mkdir -p /etc/graylog/server/
```

copy the example configuration file:
```
cp graylog.conf.example /etc/graylog/server/server.conf
```

set a secret that is used for password encryption and salting here
Generate with `pwgen -N 1 -s 96`
https://regex101.com
```
sed -i 's/password_secret =.*/password_secret = e3c652f0ba0b4801205814f8b6bc49672c4c74e25b497770bb89b22cdeb4e951/g' /etc/graylog/server/server.conf
```

SHA2 hash of a password you will use for your initial login
generated with `echo -n password | shasum -a 256`
```
sed -i 's/root_password_sha2 =.*/root_password_sha2 = e3c652f0ba0b4801205814f8b6bc49672c4c74e25b497770bb89b22cdeb4e951/g' /etc/graylog/server/server.conf
```

number of shards for your indices. If you have one node, set it to 1
```
sed -i 's/elasticsearch_shards =.*/elasticsearch_shards = 1/g' /etc/graylog/server/server.conf
```

number of replicas for your indices. If you have one node, set it to 0
```
sed -i 's/elasticsearch_replicas =.*/elasticsearch_replicas = 0/g' /etc/graylog/server/server.conf
```

## nginx
http://docs.graylog.org/en/2.3/pages/configuration/web_interface.html
https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04

Install nginx
```
sudo apt-get install -y nginx
```

REST API and Web Interface on one port (using HTTP)
```
cat << 'EOF' | sudo tee /etc/nginx/conf.d/greylog.conf
server
{
    listen 80;
    listen [::]:80 ipv6only=on;
    server_name graylog.example.com;

    location / {
      proxy_set_header Host $http_host;
      proxy_set_header X-Forwarded-Host $host;
      proxy_set_header X-Forwarded-Server $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Graylog-Server-URL http://$server_name/api;
      proxy_pass       http://127.0.0.1:9000;
    }
}
EOF
```

configure nginx to start automatically when the system boots up
```
sudo systemctl enable nginx
```

start nginx
```
sudo systemctl start nginx
```
