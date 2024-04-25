#! /bin/bash
#Set OS Environment Variable
echo  HELLO=WORLD >> /etc/profile
# Password for the 'elastic' user (at least 6 characters)
echo ELASTIC_PASSWORD=changeme >> /etc/profile

# Password for the 'kibana_system' user (at least 6 characters)
echo KIBANA_PASSWORD=changeme >> /etc/profile

# Version of Elastic products
echo STACK_VERSION=8.13.2 >> /etc/profile

# Set the cluster name
echo CLUSTER_NAME=dkatalis-es-cluster >> /etc/profile

# Set to 'basic' or 'trial' to automatically start the 30-day trial
echo LICENSE=basic >> /etc/profile
#LICENSE=trial

# Port to expose Elasticsearch HTTP API to the host
echo ES_PORT=9200 >> /etc/profile
#ES_PORT=127.0.0.1:9200

# Port to expose Kibana to the host
echo KIBANA_PORT=5601 >> /etc/profile
#KIBANA_PORT=80

# Increase or decrease based on the available host memory (in bytes)
echo MEM_LIMIT=1500M >> /etc/profile

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Dependency
sudo apt-get install -y git docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin whois

# Grant docker to user dodi
sudo usermod -aG docker dodi

git clone https://github.com/dodistyo/dkatalis-interview-test.git /usr/share/app-deployment

sudo chown -R dodi:dodi /usr/share/app-deployment

docker swarm init