package cmd

import (
	"fmt"

	"github.com/avamico/compose-cd/internal/config"
	"github.com/avamico/compose-cd/internal/form"
	"github.com/avamico/compose-cd/internal/scaffold"
	"github.com/spf13/cobra"
)

var (
	flagDefaults    bool
	flagProjectName string
	flagGithubOwner string
	flagMinimal     bool
	flagTerraform   bool
)

var initCmd = &cobra.Command{
	Use:   "init [output-dir]",
	Short: "Scaffold a new deployment repository",
	Args:  cobra.MaximumNArgs(1),
	RunE: func(cmd *cobra.Command, args []string) error {
		outputDir := "."
		if len(args) > 0 {
			outputDir = args[0]
		}

		cfg := config.NewWithDefaults()

		if flagProjectName != "" {
			cfg.ProjectName = flagProjectName
		}
		if flagGithubOwner != "" {
			cfg.GithubOwner = flagGithubOwner
		}

		if flagMinimal {
			cfg.CI = false
			cfg.Prometheus = false
			cfg.Grafana = false
			cfg.Loki = false
			cfg.Promtail = false
			cfg.Tempo = false
			cfg.Cadvisor = false
			cfg.Vault = false
			cfg.VaultAgent = false
			cfg.Caddy = false
			cfg.Traefik = false
			cfg.Watchtower = false
			cfg.UseTerraform = false
		}

		if flagTerraform {
			cfg.UseTerraform = true
			cfg.Hetzner = true
			cfg.Cloudflare = true
			cfg.Supabase = true
		}

		if !flagDefaults {
			if err := form.RunForm(cfg); err != nil {
				return err
			}
		}

		cfg.ApplyDefaults()
		if err := cfg.Validate(); err != nil {
			return err
		}

		if err := scaffold.Scaffold(cfg, outputDir, embeddedFS); err != nil {
			return err
		}

		fmt.Printf("\nProject scaffolded at: %s\n", outputDir)
		return nil
	},
}

func init() {
	initCmd.Flags().BoolVar(&flagDefaults, "defaults", false, "Use default values (non-interactive)")
	initCmd.Flags().StringVarP(&flagProjectName, "project", "p", "", "Project name")
	initCmd.Flags().StringVarP(&flagGithubOwner, "owner", "o", "", "GitHub owner")
	initCmd.Flags().BoolVar(&flagMinimal, "minimal", false, "Disable all optional services")
	initCmd.Flags().BoolVar(&flagTerraform, "terraform", false, "Enable terraform with all modules")
	rootCmd.AddCommand(initCmd)
}
