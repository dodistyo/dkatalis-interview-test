provider "google" {
  project = var.project_id
  region  = var.region
  zone    = "${var.region}-a"
}
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
  name         = "dkatalis-vm"
  machine_type = "e2-highcpu-8"
  zone         = "asia-southeast1-a"
  tags         = ["dkatalis-app"]
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2310-amd64"
      size = 100
    }
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
  name = "allow-dktalis-app"
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

# TFSTATE
resource "google_kms_key_ring" "terraform_state" {
  name     = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  location = "us"
}

resource "google_kms_crypto_key" "terraform_state_bucket" {
  name            = "dkatalis-terraform-state-bucket"
  key_ring        = google_kms_key_ring.terraform_state.id
  rotation_period = "86400s"

  lifecycle {
    prevent_destroy = false
  }
}

# Enable the Cloud Storage service account to encrypt/decrypt Cloud KMS keys
data "google_project" "project" {
}

resource "google_project_iam_member" "default" {
  project = data.google_project.project.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-${data.google_project.project.number}@gs-project-accounts.iam.gserviceaccount.com"
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name          = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = google_kms_crypto_key.terraform_state_bucket.id
  }
  depends_on = [
    google_project_iam_member.default
  ]
}