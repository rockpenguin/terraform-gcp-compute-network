output "network_name" {
  value       = google_compute_network.self.name
  description = "GCP VPC network name"
}

output "network_id" {
  value       = google_compute_network.self.id
  description = "GCP VPC network ID"
}

output "subnets" {
  value       = google_compute_subnetwork.subnet
  description = ""
}
