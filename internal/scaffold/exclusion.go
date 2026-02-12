package scaffold

import (
	"strings"

	"github.com/avamico/compose-cd/internal/config"
)

// dirExclusion maps directory paths to the config field that must be true for inclusion.
type dirExclusion struct {
	path    string
	exclude func(cfg *config.Config) bool
}

var dirExclusions = []dirExclusion{
	// Most specific paths first (vault/agent before vault)
	{"deploy/ops/configs/vault/agent", func(c *config.Config) bool { return !c.VaultAgent }},
	{"deploy/ops/configs/vault", func(c *config.Config) bool { return !c.Vault }},
	{"deploy/ops/configs/caddy", func(c *config.Config) bool { return !c.Caddy }},
	{"deploy/ops/configs/traefik", func(c *config.Config) bool { return !c.Traefik }},
	{"deploy/ops/configs/prometheus", func(c *config.Config) bool { return !c.Prometheus }},
	{"deploy/ops/configs/grafana", func(c *config.Config) bool { return !c.Grafana }},
	{"deploy/ops/configs/loki", func(c *config.Config) bool { return !c.Loki }},
	{"deploy/ops/configs/tempo", func(c *config.Config) bool { return !c.Tempo }},
	{"deploy/ops/configs/promtail", func(c *config.Config) bool { return !c.Promtail }},
	{".github", func(c *config.Config) bool { return !c.CI }},
	{"terraform/modules/hetzner", func(c *config.Config) bool { return !c.Hetzner }},
	{"terraform/modules/cloudflare", func(c *config.Config) bool { return !c.Cloudflare }},
	{"terraform/modules/supabase", func(c *config.Config) bool { return !c.Supabase }},
	{"terraform", func(c *config.Config) bool { return !c.UseTerraform }},
}

// shouldExcludeDir returns true if the directory should be skipped.
func shouldExcludeDir(path string, cfg *config.Config) bool {
	for _, rule := range dirExclusions {
		if rule.exclude(cfg) && (path == rule.path || strings.HasPrefix(path, rule.path+"/")) {
			return true
		}
	}
	return false
}

// fileExclusions maps file paths to exclusion conditions.
type fileExclusion struct {
	path    string
	exclude func(cfg *config.Config) bool
}

var fileExclusions = []fileExclusion{
	{"scripts/setup-vault-secrets.sh.tmpl", func(c *config.Config) bool { return !c.Vault }},
}

// shouldExcludeFile returns true if the file should be skipped.
func shouldExcludeFile(path string, cfg *config.Config) bool {
	for _, rule := range fileExclusions {
		if rule.exclude(cfg) && path == rule.path {
			return true
		}
	}
	return false
}
