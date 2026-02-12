variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for the domain"
  type        = string
}

variable "backend_subdomain" {
  description = "Subdomain for backend API (e.g., 'api' for api.example.com)"
  type        = string
  default     = "api"
}

variable "backend_server_ip" {
  description = "IP address of the backend server (Hetzner VPS)"
  type        = string
}

variable "pages_project_name" {
  description = "Name of the Cloudflare Pages project"
  type        = string
}

variable "production_branch" {
  description = "Git branch for production deployments"
  type        = string
  default     = "master"
}

variable "build_command" {
  description = "Build command for the frontend"
  type        = string
  default     = "npm run build"
}

variable "build_output_dir" {
  description = "Build output directory"
  type        = string
  default     = "dist"
}

variable "github_owner" {
  description = "GitHub organization or username"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name for frontend"
  type        = string
}

variable "frontend_env_vars" {
  description = "Environment variables for production frontend"
  type        = map(string)
  default     = {}
}

variable "frontend_preview_env_vars" {
  description = "Environment variables for preview frontend"
  type        = map(string)
  default     = {}
}

variable "frontend_custom_domain" {
  description = "Custom domain for frontend (e.g., app.example.com)"
  type        = string
  default     = ""
}

variable "frontend_subdomain" {
  description = "Subdomain for frontend (e.g., 'app' for app.example.com)"
  type        = string
  default     = "app"
}
