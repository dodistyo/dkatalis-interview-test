# VPC
resource "google_compute_network" "vpc_network" {
  name                    = "dkatalis-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = "dkatalis-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}
# END VPC

# VM
# Create a single Compute Engine instance
resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["dkatalis-app"]
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2310-amd64"
      size = var.disk_size
    }
  }
  # Set ssh access
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  # Install dependency
  metadata_startup_script = file("${path.module}/script/dependency.sh")

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}

# Firewall
resource "google_compute_firewall" "default" {
  name = "allow-public-dktalis-app"
  allow {
    ports    = ["22", "9200", "5601", "3000"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["dkatalis-app"]
}

resource "google_compute_firewall" "local_connection" {
  name = "allow-local-dktalis-app"
  allow {
    ports    = ["22", "2377"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["10.0.1.0/24"]
  target_tags   = ["dkatalis-app"]
}