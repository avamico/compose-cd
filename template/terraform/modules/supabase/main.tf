terraform {
  required_providers {
    supabase = {
      source  = "supabase/supabase"
      version = "~> 1.0"
    }
  }
}

# Supabase Project
resource "supabase_project" "main" {
  organization_id   = var.organization_id
  name              = var.project_name
  database_password = var.database_password
  region            = var.region

  lifecycle {
    ignore_changes = [database_password]
  }
}

# Auth Settings
resource "supabase_settings" "main" {
  project_ref = supabase_project.main.id

  api = jsonencode({
    db_schema            = "public,storage,graphql_public"
    db_extra_search_path = "public,extensions"
    max_rows             = 1000
  })

  auth = jsonencode({
    site_url                           = var.site_url
    additional_redirect_urls           = var.additional_redirect_urls
    disable_signup                     = var.disable_signup
    external_email_enabled             = true
    external_phone_enabled             = false
    mailer_autoconfirm                 = var.mailer_autoconfirm
    mailer_secure_email_change_enabled = true
    password_min_length                = 8
    sms_autoconfirm                    = false
    jwt_exp                            = var.jwt_expiry_seconds
    security_captcha_enabled           = var.enable_captcha
    security_captcha_provider          = var.enable_captcha ? "hcaptcha" : null
    security_captcha_secret            = var.enable_captcha ? var.captcha_secret : null
  })
}

# Note: Storage buckets must be created via Supabase dashboard or API
# The Terraform provider does not support supabase_bucket resource
