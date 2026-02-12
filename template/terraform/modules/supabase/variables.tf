# Organization
variable "organization_id" {
  description = "Supabase organization ID"
  type        = string
}

# Project
variable "project_name" {
  description = "Supabase project name"
  type        = string
}

variable "database_password" {
  description = "Database password for the project"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Supabase project region"
  type        = string
  default     = "ap-southeast-1" # Singapore
  # Available regions:
  # us-east-1, us-west-1, ap-southeast-1, ap-northeast-1,
  # eu-west-1, eu-west-2, eu-central-1, ap-south-1, sa-east-1
}

# Auth Settings
variable "site_url" {
  description = "Site URL for auth redirects"
  type        = string
}

variable "additional_redirect_urls" {
  description = "Additional allowed redirect URLs"
  type        = list(string)
  default     = []
}

variable "disable_signup" {
  description = "Disable new user signups"
  type        = bool
  default     = false
}

variable "mailer_autoconfirm" {
  description = "Auto-confirm email addresses"
  type        = bool
  default     = false
}

variable "jwt_expiry_seconds" {
  description = "JWT token expiry in seconds"
  type        = number
  default     = 3600 # 1 hour
}

variable "enable_captcha" {
  description = "Enable hCaptcha for auth"
  type        = bool
  default     = false
}

variable "captcha_secret" {
  description = "hCaptcha secret key"
  type        = string
  sensitive   = true
  default     = ""
}

# Storage (not supported by Terraform provider - create via dashboard)
# variable "storage_buckets" {
#   description = "Storage buckets to create"
#   type = list(object({
#     name               = string
#     public             = bool
#     file_size_limit    = optional(number, 52428800) # 50MB default
#     allowed_mime_types = optional(list(string), [])
#   }))
#   default = []
# }
