output "project_id" {
  description = "Supabase project ID (ref)"
  value       = supabase_project.main.id
}

output "project_name" {
  description = "Supabase project name"
  value       = supabase_project.main.name
}

output "project_url" {
  description = "Supabase project URL"
  value       = "https://${supabase_project.main.id}.supabase.co"
}

output "api_url" {
  description = "Supabase API URL"
  value       = "https://${supabase_project.main.id}.supabase.co"
}

output "database_host" {
  description = "Database host"
  value       = "db.${supabase_project.main.id}.supabase.co"
}

output "database_url" {
  description = "PostgreSQL connection string"
  value       = "postgresql://postgres:${var.database_password}@db.${supabase_project.main.id}.supabase.co:5432/postgres"
  sensitive   = true
}

# Note: anon_key and service_role_key must be fetched from Supabase dashboard
# Project Settings > API > Project API keys
# The Terraform provider does not expose these attributes
