# Hetzner Cloud Provider Module
# This module is prepared for future use when provisioning new VPS instances
# Currently, the VPS is manually provisioned

terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

# SSH Key for VPS access
resource "hcloud_ssh_key" "default" {
  count      = var.create_ssh_key ? 1 : 0
  name       = "${var.project_name}-${var.environment}-key"
  public_key = var.ssh_public_key
}

# Firewall rules
resource "hcloud_firewall" "default" {
  count = var.create_firewall ? 1 : 0
  name  = "${var.project_name}-${var.environment}-fw"

  # SSH
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = var.ssh_allowed_ips
  }

  # HTTP (for Cloudflare)
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "173.245.48.0/20",
      "103.21.244.0/22",
      "103.22.200.0/22",
      "103.31.4.0/22",
      "141.101.64.0/18",
      "108.162.192.0/18",
      "190.93.240.0/20",
      "188.114.96.0/20",
      "197.234.240.0/22",
      "198.41.128.0/17",
      "162.158.0.0/15",
      "104.16.0.0/13",
      "104.24.0.0/14",
      "172.64.0.0/13",
      "131.0.72.0/22"
    ]
  }

  # HTTPS (for Cloudflare)
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "173.245.48.0/20",
      "103.21.244.0/22",
      "103.22.200.0/22",
      "103.31.4.0/22",
      "141.101.64.0/18",
      "108.162.192.0/18",
      "190.93.240.0/20",
      "188.114.96.0/20",
      "197.234.240.0/22",
      "198.41.128.0/17",
      "162.158.0.0/15",
      "104.16.0.0/13",
      "104.24.0.0/14",
      "172.64.0.0/13",
      "131.0.72.0/22"
    ]
  }

  # Allow all outbound
  rule {
    direction       = "out"
    protocol        = "tcp"
    port            = "any"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction       = "out"
    protocol        = "udp"
    port            = "any"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction       = "out"
    protocol        = "icmp"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }
}

# VPS Server (optional - for new deployments)
resource "hcloud_server" "app" {
  count       = var.create_server ? 1 : 0
  name        = "${var.project_name}-${var.environment}"
  image       = var.server_image
  server_type = var.server_type
  location    = var.server_location

  ssh_keys     = var.create_ssh_key ? [hcloud_ssh_key.default[0].id] : var.existing_ssh_key_ids
  firewall_ids = var.create_firewall ? [hcloud_firewall.default[0].id] : []

  labels = {
    project     = var.project_name
    environment = var.environment
  }

  user_data = var.cloud_init_config
}
