output "public_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
output "local_ip" {
  value = google_compute_instance.default.network_interface[0].network_ip
}
output "subnet_id" {
  value = google_compute_subnetwork.default.id
}
