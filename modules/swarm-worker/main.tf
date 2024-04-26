
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

resource "null_resource" "upload_private_key" {
  depends_on = [google_compute_instance.default]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
  }

  provisioner "file" {
    source      = "~/.ssh/id_rsa"
    destination = "id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "while ! sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i /home/ubuntu/id_rsa ubuntu@${var.docker_swarm_manager_ip}:/home/ubuntu/swarm-join-token /home/ubuntu/swarm-join-token; do sleep 10; done",
      "while ! sudo docker swarm join --token $(cat /home/ubuntu/swarm-join-token) ${var.docker_swarm_manager_ip}:2377; do sleep 10; done"
    ]
  }
}
