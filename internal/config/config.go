package config

import (
	"fmt"
	"strings"
)

// Config holds all template variables from user input.
type Config struct {
	// Core
	ProjectName   string
	ServiceName   string
	GithubOwner   string
	DockerImage   string
	AppPort       int
	AppPortStr    string // for form input, converted to int
	AppHealthPath string
	AppCommand    string
	Domain        string
	Environments  string

	// Feature toggles
	CI         bool
	Prometheus bool
	Grafana    bool
	Loki       bool
	Promtail   bool
	Tempo      bool
	Cadvisor   bool
	Vault      bool
	VaultAgent bool
	Caddy      bool
	Traefik    bool
	Watchtower bool

	// Terraform
	UseTerraform bool
	Hetzner      bool
	Cloudflare   bool
	Supabase     bool
}

// NewWithDefaults returns a Config with sensible defaults.
func NewWithDefaults() *Config {
	return &Config{
		AppPort:       3002,
		AppPortStr:    "3002",
		AppHealthPath: "/health",
		AppCommand:    "/app/service app start",
		Domain:        "example.com",
		Environments:  "local,dev,prod",
		CI:            true,
		Prometheus:    true,
		Grafana:       true,
		Loki:          true,
		Promtail:      true,
		Tempo:         false,
		Cadvisor:      true,
		Vault:         true,
		VaultAgent:    true,
		Caddy:         true,
		Traefik:       false,
		Watchtower:    true,
		UseTerraform:  false,
		Hetzner:       false,
		Cloudflare:    false,
		Supabase:      false,
	}
}

// ApplyDefaults computes derived defaults (service_name, docker_image).
func (c *Config) ApplyDefaults() {
	if c.ServiceName == "" {
		c.ServiceName = c.ProjectName + "-service"
	}
	if c.DockerImage == "" {
		c.DockerImage = fmt.Sprintf("ghcr.io/%s/%s", c.GithubOwner, c.ServiceName)
	}
	// Parse port from string if set via form
	if c.AppPortStr != "" {
		fmt.Sscanf(c.AppPortStr, "%d", &c.AppPort)
	}
}

// Validate checks required fields.
func (c *Config) Validate() error {
	if c.ProjectName == "" {
		return fmt.Errorf("project_name is required")
	}
	if c.GithubOwner == "" {
		return fmt.Errorf("github_owner is required")
	}
	if c.AppPort <= 0 || c.AppPort > 65535 {
		return fmt.Errorf("app_port must be between 1 and 65535")
	}
	return nil
}

// TemplateData returns the config as a map for template execution.
func (c *Config) TemplateData() map[string]interface{} {
	envList := strings.Split(c.Environments, ",")
	for i := range envList {
		envList[i] = strings.TrimSpace(envList[i])
	}

	return map[string]interface{}{
		"project_name":    c.ProjectName,
		"service_name":    c.ServiceName,
		"github_owner":    c.GithubOwner,
		"docker_image":    c.DockerImage,
		"app_port":        c.AppPort,
		"app_health_path": c.AppHealthPath,
		"app_command":     c.AppCommand,
		"domain":          c.Domain,
		"environments":    c.Environments,
		"environments_list": envList,

		"ci":             c.CI,
		"prometheus":     c.Prometheus,
		"grafana":        c.Grafana,
		"loki":           c.Loki,
		"promtail":       c.Promtail,
		"tempo":          c.Tempo,
		"cadvisor":       c.Cadvisor,
		"vault":          c.Vault,
		"vault_agent":    c.VaultAgent,
		"caddy":          c.Caddy,
		"traefik":        c.Traefik,
		"watchtower":     c.Watchtower,
		"use_terraform":  c.UseTerraform,
		"hetzner":        c.Hetzner,
		"cloudflare":     c.Cloudflare,
		"supabase":       c.Supabase,
	}
}
