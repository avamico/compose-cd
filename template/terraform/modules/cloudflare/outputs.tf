output "backend_dns_record" {
  description = "Backend API DNS record details"
  value = {
    hostname = cloudflare_record.backend_api.hostname
    proxied  = cloudflare_record.backend_api.proxied
  }
}

output "pages_project" {
  description = "Cloudflare Pages project details"
  value = {
    name      = cloudflare_pages_project.frontend.name
    subdomain = cloudflare_pages_project.frontend.subdomain
    domains   = cloudflare_pages_project.frontend.domains
  }
}

output "frontend_url" {
  description = "Frontend URL"
  value       = "https://${cloudflare_pages_project.frontend.subdomain}"
}

output "backend_url" {
  description = "Backend API URL"
  value       = "https://${cloudflare_record.backend_api.hostname}"
}
