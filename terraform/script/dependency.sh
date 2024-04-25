#! /bin/bash

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

# ES CONFIG
sudo sysctl -w vm.max_map_count=262144

sudo -u dodi git clone https://github.com/dodistyo/dkatalis-interview-test.git /usr/share/app-deployment

docker swarm init

cd /usr/share/app-deployment/manifest

export $(cat .env) > /dev/null 2>&1; docker stack deploy -c docker-compose.yml dkatalis-app