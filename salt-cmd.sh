#!/bin/bash

# Accept all minions key
salt-key -A

# This for download offcial image registry and export to tar
#docker pull registry
#docker save registry > /vagrant/docker-registry.tar

# This for import to local image
docker load < /vagrant/docker-registry.tar
docker load < /vagrant/centos_centos6.tar

# Setup CentOS 6 server internal CA
# CA rules: 1. Country code is mandatory and must match with later CSR; 2. Common name is mandatory and must set as this server FQDN, e.g. master.localdomain. You could set it and modify your /etc/hosts, such as: 192.168.xxx.xxx master.localdomain
cd /etc/pki/CA
touch index.txt
echo '01' > serial
echo '01' > crlnumber
openssl req -new -x509 -extensions v3_ca -keyout private/ca-cert.key -out certs/ca-cert.crt -subj "/C=HK/ST=/L=/O=/CN=master.localdomain" -days 1825
chmod 400 private/ca-cert.key

# Create directory
mkdir -p /tmp/ssl /tmp/registry

# Copy CA certificate to /tmp/ssl
cp certs/ca-cert.crt /tmp/ssl/ca.cert

# Generate CSR
# CSR rules: 1. Country code must match exact the same with previous CA country code; 2. Providance / State shall not be empty; put NA if you don't know what to fill; 3. Common name should give not the same as CA, e.g. registry.localdomain; change /etc/hosts to make it point to where docker registry machine IP address
openssl req -new -newkey rsa:2048 -nodes -out /tmp/ssl/registry.csr -keyout /tmp/ssl/registry.key -subj "/C=HK/ST=NA/L=/O=/CN=registry.localdomain"

# Sign CSR and get certificate
openssl ca -in /tmp/ssl/registry.csr -out /tmp/ssl/registry.crt -keyfile private/ca-cert.key -cert certs/ca-cert.crt -policy policy_anything

# Pull official docker registry image
docker pull registry

# Launch official docker-registry; remember open port 5000 in iptables
docker run -d -p 5000:5000 -v /tmp/ssl:/ssl -v /tmp/registry:/tmp/registry -e GUNICORN_OPTS="['--certfile','/ssl/registry.crt','--keyfile','/ssl/registry.key','--ca-certs','/ssl/ca.cert','--ssl-version',3]" registry

# Don't forget to distribute ca.cert. First, from another machine:
#mkdir -p /etc/docker/certs.d/registry.localdomain:5000/

# Second, from this machine:
#scp /tmp/ssl/ca.cert vagrant@minion1:/etc/docker/certs.d/registry.localdomain\:5000/

# From other machine, test if registry working by:
#docker search registry.localdomain:5000/centos
# Expected result:
#NAME             DESCRIPTION   STARS     OFFICIAL   AUTOMATED

# Launch official docker-registry; remember open port 5000 in iptables
docker run -d -p 5000:5000 -v /tmp/ssl:/ssl -v /tmp/registry:/tmp/registry -e GUNICORN_OPTS="['--certfile','/ssl/registry.crt','--keyfile','/ssl/registry.key','--ca-certs','/ssl/ca.cert','--ssl-version',3]" registry

# Don't forget to distribute ca.cert. From other machine:
#mkdir -p /etc/docker/certs.d/registry.localdomain:5000/

# From this machine:
#scp /tmp/ssl/ca.cert vagrant@minion1:/etc/docker/certs.d/registry.localdomain\:5000/

# From other machine, test if registry working by:
#docker search registry.localdomain:5000/centos
# Expected result:
#NAME             DESCRIPTION   STARS     OFFICIAL   AUTOMATED

# This will result DockerException: HTTPS endpoint unresponsive and insecure mode isn't enabled.
#salt 'minion1' docker.pull master:5000/prod_centos:centos6

# This works.
salt 'minion1' cmd.run 'docker pull master:5000/prod_centos:centos6'