provider "google" {
  project = "interview-417918"
  region  = "asia-southeast1"
  zone    = "asia-southeast1-a"
}

module "swarm_manager" {
  source = "../../../modules/swarm-manager"
  
  instance_name = "dkatalis-swarm-manager"
  machine_type = "e2-highcpu-8"
  disk_size = 100
}

module "swarm_worker_01" {
  source = "../../../modules/swarm-worker"
  depends_on = [ module.swarm_manager ]

  instance_name = "dkatalis-swarm-worker-01"
  machine_type = "e2-medium"
  disk_size = 50
  subnet_id = module.swarm_manager.subnet_id
  docker_swarm_manager_ip = module.swarm_manager.local_ip
}