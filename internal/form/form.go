package form

import (
	"github.com/avamico/compose-cd/internal/config"
	"github.com/charmbracelet/huh"
)

// RunForm runs the interactive TUI form to collect user input.
func RunForm(cfg *config.Config) error {
	form := huh.NewForm(
		// Group 1: Project Info
		huh.NewGroup(
			huh.NewInput().
				Title("Project name").
				Description("Used for directories, DNS, vault paths").
				Placeholder("my-app").
				Value(&cfg.ProjectName).
				Validate(huh.ValidateNotEmpty()),

			huh.NewInput().
				Title("Service name").
				Description("Docker service name (leave empty for {project}-service)").
				Placeholder("my-app-service").
				Value(&cfg.ServiceName),

			huh.NewInput().
				Title("GitHub owner").
				Description("GitHub org or username").
				Placeholder("avamico").
				Value(&cfg.GithubOwner).
				Validate(huh.ValidateNotEmpty()),

			huh.NewInput().
				Title("Docker image").
				Description("Full image path (leave empty for ghcr.io/{owner}/{service})").
				Placeholder("ghcr.io/avamico/my-app-service").
				Value(&cfg.DockerImage),
		).Title("Project"),

		// Group 2: App Config
		huh.NewGroup(
			huh.NewInput().
				Title("App port").
				Placeholder("3002").
				Value(&cfg.AppPortStr),

			huh.NewInput().
				Title("Health check path").
				Placeholder("/health").
				Value(&cfg.AppHealthPath),

			huh.NewInput().
				Title("App command").
				Description("Container startup command").
				Placeholder("/app/service app start").
				Value(&cfg.AppCommand),

			huh.NewInput().
				Title("Domain").
				Description("Base domain").
				Placeholder("example.com").
				Value(&cfg.Domain),

			huh.NewInput().
				Title("Environments").
				Description("Comma-separated").
				Placeholder("local,dev,prod").
				Value(&cfg.Environments),
		).Title("Application"),

		// Group 3: CI/CD
		huh.NewGroup(
			huh.NewConfirm().
				Title("Include GitHub Actions CI/CD?").
				Value(&cfg.CI),
		).Title("CI/CD"),

		// Group 4: Observability
		huh.NewGroup(
			huh.NewConfirm().Title("Prometheus (metrics collection)?").Value(&cfg.Prometheus),
			huh.NewConfirm().Title("Grafana (dashboards)?").Value(&cfg.Grafana),
			huh.NewConfirm().Title("Loki (log aggregation)?").Value(&cfg.Loki),
			huh.NewConfirm().Title("Promtail (log shipping)?").Value(&cfg.Promtail),
			huh.NewConfirm().Title("Tempo (distributed tracing)?").Value(&cfg.Tempo),
			huh.NewConfirm().Title("cAdvisor (container metrics)?").Value(&cfg.Cadvisor),
		).Title("Observability"),

		// Group 5: Infrastructure Services
		huh.NewGroup(
			huh.NewConfirm().Title("Vault (secrets management)?").Value(&cfg.Vault),
			huh.NewConfirm().Title("Vault Agent (auto-sync secrets)?").Value(&cfg.VaultAgent),
			huh.NewConfirm().Title("Caddy (reverse proxy)?").Value(&cfg.Caddy),
			huh.NewConfirm().Title("Traefik (alternative reverse proxy)?").Value(&cfg.Traefik),
			huh.NewConfirm().Title("Watchtower (auto-deploy on image push)?").Value(&cfg.Watchtower),
		).Title("Infrastructure"),

		// Group 6: Terraform
		huh.NewGroup(
			huh.NewConfirm().
				Title("Include Terraform infrastructure-as-code?").
				Value(&cfg.UseTerraform),
		).Title("Terraform"),

		// Group 7: Terraform Modules (conditional)
		huh.NewGroup(
			huh.NewConfirm().Title("Hetzner Cloud module?").Value(&cfg.Hetzner),
			huh.NewConfirm().Title("Cloudflare module (DNS, Pages)?").Value(&cfg.Cloudflare),
			huh.NewConfirm().Title("Supabase module (auth, database)?").Value(&cfg.Supabase),
		).Title("Terraform Modules").
			WithHideFunc(func() bool {
				return !cfg.UseTerraform
			}),
	)

	return form.Run()
}
