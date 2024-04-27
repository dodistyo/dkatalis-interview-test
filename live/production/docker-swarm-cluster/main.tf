provider "google" {
  project = "interview-417918"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-a"
}

module "network" {
  source = "../../../modules/network"
  
  vpc_name = "dkatalis-vpc-prod"
  subnet_name = "dkatalis-subnet-prod"
  network_environment = "prod"
}

module "swarm_manager" {
  source = "../../../modules/swarm-manager"
  
  depends_on = [ module.network ]
  
  instance_name = "dkatalis-prod-swarm-manager"
  machine_type = "e2-highcpu-8"
  subnet_id = module.network.subnet_id
  disk_size = 100
}

module "swarm_worker_01" {
  source = "../../../modules/swarm-worker"
  depends_on = [ module.network, module.swarm_manager ]

  instance_name = "dkatalis-prod-swarm-worker-01"
  machine_type = "e2-medium"
  subnet_id = module.network.subnet_id
  disk_size = 100
  docker_swarm_manager_ip = module.swarm_manager.local_ip
}