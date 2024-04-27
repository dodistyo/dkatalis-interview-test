# VPC
resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "default" {
  name          = var.subnet_name
  ip_cidr_range = var.cidr_range
  region        = var.region
  network       = google_compute_network.vpc_network.id
}
# END VPC
# Firewall
resource "google_compute_firewall" "default" {
  name = "allow-public-${var.network_environment}"
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
  name = "allow-local-${var.network_environment}"
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
# END Firewall 