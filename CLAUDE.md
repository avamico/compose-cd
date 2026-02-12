# compose-cd

ArgoCD-like GitOps scaffolding for Docker Compose. A Go CLI that generates customized deployment repos via interactive TUI.

**Repo**: github.com/avamico/compose-cd
**Origin**: Extracted from [acc-hr-deployments](https://github.com/avamico/acc-hr-deployments) as a reusable template.

## Quick Reference

```bash
make build          # Build binary to bin/compose-cd
make test-full      # Generate full project + docker compose config validation
make test-minimal   # Generate minimal project + validation
make install        # go install
go test ./... -v    # Unit tests
```

## Architecture

```
compose-cd init [dir]
  → cmd/init.go         # CLI flags, orchestration
  → internal/form/      # charmbracelet/huh interactive TUI (26 questions, 7 pages)
  → internal/config/    # Config struct, defaults, validation, TemplateData()
  → internal/scaffold/  # Template engine (walk embedded FS, render, write)
  → template/           # 64 embedded files (37 .tmpl + 27 static)
```

### Key Design Decisions

- **`[[ ]]` template delimiters**: Go's `text/template` with custom delimiters. Avoids conflicts with Justfile `{{ env }}`, GitHub Actions `${{ }}`, and Docker `{{.Name}}` — all pass through untouched. No escaping needed.
- **`map[string]interface{}` with snake_case keys**: Template data uses `.project_name` not `.ProjectName`, keeping templates close to original Jinja2 for easy maintenance.
- **`//go:embed all:template`** in `templates.go` at repo root (must be root-level for embed path to work).
- **Directory exclusion** in `exclusion.go`: 14 dir rules + 1 file rule. Most-specific paths checked first (vault/agent before vault).

## File Map

| File | Purpose |
|------|---------|
| `main.go` | Entry point, passes `templateFS` to cobra |
| `templates.go` | `//go:embed all:template` — must stay at repo root |
| `cmd/root.go` | Cobra root, holds `embeddedFS` package var |
| `cmd/init.go` | `init` subcommand: flags (--defaults, --minimal, --terraform, -p, -o) |
| `cmd/version.go` | Version with ldflags injection |
| `internal/config/config.go` | 26-field Config struct, `NewWithDefaults()`, `ApplyDefaults()`, `Validate()`, `TemplateData()` |
| `internal/form/form.go` | huh form: 7 groups, `WithHideFunc` for conditional terraform module questions |
| `internal/scaffold/engine.go` | `Scaffold()`: walk embedded FS → exclude → render/copy → write |
| `internal/scaffold/exclusion.go` | `shouldExcludeDir()`, `shouldExcludeFile()` with config-based rules |
| `internal/scaffold/funcmap.go` | Custom template functions: `splitWords`, `joinQuoted`, `containsStr`, `splitComma`, `joinBracketedCSV` |

## Template Syntax

Templates use `[[ ]]` delimiters (not `{{ }}`):

```
[[ .project_name ]]                              # Variable
[[ if .vault ]]...[[ end ]]                      # Conditional
[[ if or .caddy .traefik .prometheus ]]           # Compound or
[[ .app_command | splitWords | joinQuoted ]]      # Pipe to custom func
[[ if containsStr .environments "local" ]]        # String contains check
[[ .environments | splitComma | joinBracketedCSV ]]  # "[local, dev, prod]"
```

All `{{ }}` in templates is **literal** (Justfile vars, GitHub Actions, Docker tags).

## Template Variables (26 total)

**Core** (9): `project_name`, `service_name`, `github_owner`, `docker_image`, `app_port`, `app_health_path`, `app_command`, `domain`, `environments`

**Service toggles** (12 bool): `ci`, `prometheus`, `grafana`, `loki`, `promtail`, `tempo`, `cadvisor`, `vault`, `vault_agent`, `caddy`, `traefik`, `watchtower`

**Terraform** (4 bool): `use_terraform`, `hetzner`, `cloudflare`, `supabase`

Derived: `service_name` defaults to `{project_name}-service`, `docker_image` defaults to `ghcr.io/{owner}/{service}`

## Adding a New Service

1. Add bool field to `internal/config/config.go` (Config struct + NewWithDefaults + TemplateData)
2. Add huh confirm to appropriate group in `internal/form/form.go`
3. Add dir exclusion rule in `internal/scaffold/exclusion.go` if it has config files
4. Add service block in `template/deploy/docker-compose.ops.yml.tmpl` wrapped in `[[ if .new_service ]]`
5. Add port mapping in `template/deploy/docker-compose.local.yml.tmpl` if needed
6. Add config files under `template/deploy/ops/configs/new-service/`
7. Update overlay templates if the service needs env-specific config
8. Run `make test-full && make test-minimal` to validate

## Common Gotchas

- **`templates.go` must be at repo root** — `go:embed` paths are relative to the source file
- **`all:` prefix required** in embed directive to include dotfiles (`.github/`, `.gitignore`, etc.)
- **Empty `services:` block fails docker compose** — wrap with `[[ if or .svc1 .svc2 ... ]]services:...[[end]]`
- **Vault `env.tpl` is a Go template file** (native `{{ with secret }}`). It's a static file, NOT `.tmpl` — never process it through the engine
- **Double `{{{{` is wrong** — with `[[ ]]` delimiters, single `{{` passes through. No double-escaping needed
- **`joinBracketedCSV`** exists because `[` + `[[ ]]` + `]` creates ambiguous `[[[` — the function outputs `[val1, val2]` as a single string

## Roadmap

- [ ] `compose-cd sync` — Go daemon for GitOps reconciliation (watch repo, auto-deploy changes)
- [ ] `compose-cd update` — Re-scaffold existing project with newer template version
- [ ] Web dashboard for deployment status
- [ ] Homebrew tap for macOS install
- [ ] Unit tests for config, funcmap, exclusion
- [ ] Golden file integration tests
