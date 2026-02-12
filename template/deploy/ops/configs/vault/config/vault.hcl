ui = true

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = true  # Enable TLS in production with proper certificates
}

storage "file" {
  path = "/vault/file"
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"

# Disable mlock for container environments
disable_mlock = true

# Log level
log_level = "info"
