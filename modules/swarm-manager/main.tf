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
    subnetwork = var.subnet_id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}