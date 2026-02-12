# Vault Agent Configuration

vault {
  address = "http://vault:8200"
}

auto_auth {
  method "approle" {
    config = {
      role_id_file_path   = "/vault/agent/role-id"
      secret_id_file_path = "/vault/agent/secret-id"
      remove_secret_id_file_after_reading = false
    }
  }

  sink "file" {
    config = {
      path = "/vault/secrets/.token"
    }
  }
}

template_config {
  static_secret_render_interval = "5m"
  exit_on_retry_failure         = true
}

template {
  source      = "/vault/agent/templates/env.tpl"
  destination = "/vault/secrets/.env"
  perms       = 0644
  command     = "echo 'Secrets updated'"
}
