variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "create_server" {
  description = "Whether to create a new server"
  type        = bool
  default     = false
}

variable "create_ssh_key" {
  description = "Whether to create SSH key resource"
  type        = bool
  default     = false
}

variable "create_firewall" {
  description = "Whether to create firewall rules"
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
  default     = ""
}

variable "existing_ssh_key_ids" {
  description = "List of existing SSH key IDs to use"
  type        = list(number)
  default     = []
}

variable "server_type" {
  description = "Hetzner server type"
  type        = string
  default     = "cx22" # 2 vCPU, 4GB RAM
}

variable "server_image" {
  description = "Server OS image"
  type        = string
  default     = "ubuntu-24.04"
}

variable "server_location" {
  description = "Hetzner datacenter location"
  type        = string
  default     = "fsn1" # Falkenstein, Germany
}

variable "ssh_allowed_ips" {
  description = "IP addresses allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"] # Restrict in production
}

variable "cloud_init_config" {
  description = "Cloud-init configuration for server provisioning"
  type        = string
  default     = ""
}
