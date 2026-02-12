output "server_ip" {
  description = "Public IP address of the server"
  value       = var.create_server ? hcloud_server.app[0].ipv4_address : null
}

output "server_id" {
  description = "Server ID"
  value       = var.create_server ? hcloud_server.app[0].id : null
}

output "server_status" {
  description = "Server status"
  value       = var.create_server ? hcloud_server.app[0].status : null
}

output "firewall_id" {
  description = "Firewall ID"
  value       = var.create_firewall ? hcloud_firewall.default[0].id : null
}
