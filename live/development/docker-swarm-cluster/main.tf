provider "google" {
  project = "interview-417918"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-a"
}

module "network" {
  source = "../../../modules/network"

  vpc_name = "dkatalis-vpc-dev"
  subnet_name = "dkatalis-subnet-dev"
  network_environment = "dev"
}

module "swarm_manager" {
  source = "../../../modules/swarm-manager"
  depends_on = [ module.network ]
  
  subnet_id = module.network.subnet_id
  instance_name = "dkatalis-dev-swarm-manager"
  machine_type = "e2-highcpu-8"
  disk_size = 100
}

module "swarm_worker_01" {
  source = "../../../modules/swarm-worker"
  depends_on = [module.network, module.swarm_manager ]

  instance_name = "dkatalis-dev-swarm-worker-01"
  machine_type = "e2-medium"
  disk_size = 50
  subnet_id = module.network.subnet_id
  docker_swarm_manager_ip = module.swarm_manager.local_ip
}