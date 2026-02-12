terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# DNS A record for backend API (proxied through Cloudflare for SSL)
resource "cloudflare_record" "backend_api" {
  zone_id = var.cloudflare_zone_id
  name    = var.backend_subdomain
  content = var.backend_server_ip
  type    = "A"
  proxied = true
  ttl     = 1 # Auto when proxied
}

# Cloudflare Pages project for frontend
resource "cloudflare_pages_project" "frontend" {
  account_id        = var.cloudflare_account_id
  name              = var.pages_project_name
  production_branch = var.production_branch

  build_config {
    build_command   = var.build_command
    destination_dir = var.build_output_dir
  }

  source {
    type = "github"
    config {
      owner                         = var.github_owner
      repo_name                     = var.github_repo
      production_branch             = var.production_branch
      pr_comments_enabled           = true
      deployments_enabled           = true
      production_deployment_enabled = true
      preview_deployment_setting    = "custom"
      preview_branch_includes       = ["dev", "staging"]
    }
  }

  deployment_configs {
    production {
      environment_variables = var.frontend_env_vars
    }
    preview {
      environment_variables = var.frontend_preview_env_vars
    }
  }
}

# Custom domain for Cloudflare Pages (optional)
resource "cloudflare_pages_domain" "frontend_domain" {
  count        = var.frontend_custom_domain != "" ? 1 : 0
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.frontend.name
  domain       = var.frontend_custom_domain
}

# CNAME record for frontend custom domain
resource "cloudflare_record" "frontend_cname" {
  count   = var.frontend_custom_domain != "" ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = var.frontend_subdomain
  content = "${cloudflare_pages_project.frontend.name}.pages.dev"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}
