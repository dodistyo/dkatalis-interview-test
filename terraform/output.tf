output "project_id" {
  description = "The project id used when managing resources."
  value       = var.project_id
}

output "region" {
  description = "The region used when managing resources."
  value       = var.region
}
output "ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}
