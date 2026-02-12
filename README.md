# compose-cd

ArgoCD-like GitOps deployment scaffolding for Docker Compose on VPS.

**compose-cd** generates customized deployment repositories with Docker Compose services, monitoring, secrets management, CI/CD, and infrastructure-as-code — all from an interactive CLI.

## Install

```bash
# From source
go install github.com/avamico/compose-cd@latest

# Or download a binary from releases
# https://github.com/avamico/compose-cd/releases
```

## Quick Start

```bash
# Interactive mode
compose-cd init my-project

# Non-interactive with defaults
compose-cd init --defaults -p my-app -o my-org my-project
```

The interactive wizard guides you through:

1. **Project info** — name, service name, GitHub owner, Docker image
2. **App config** — port, health path, command, domain, environments
3. **CI/CD** — GitHub Actions workflows
4. **Observability** — Prometheus, Grafana, Loki, Promtail, Tempo, cAdvisor
5. **Infrastructure** — Vault, Caddy/Traefik, Watchtower
6. **Terraform** — Hetzner, Cloudflare, Supabase modules

## What You Get

A deployment repository structured like this:

```
my-project/
├── deploy/
│   ├── docker-compose.ops.yml      # Monitoring, secrets, proxy
│   ├── docker-compose.app.yml      # Your application
│   ├── docker-compose.local.yml    # Local dev overrides
│   ├── ops/
│   │   ├── configs/                # Service configs (Caddy, Prometheus, etc.)
│   │   └── overlays/               # Environment-specific overrides
│   └── app/
│       └── overlays/               # App env overrides (local, dev, prod)
├── terraform/                      # Optional IaC (Hetzner, Cloudflare, Supabase)
├── scripts/                        # VPS setup, Vault initialization
├── justfile                        # Command runner
├── .github/workflows/              # CI/CD pipelines
└── README.md
```

### Available Services

| Category | Service | Default | Description |
|----------|---------|---------|-------------|
| **Proxy** | Caddy | on | Reverse proxy with auto-HTTPS |
| | Traefik | off | Alternative reverse proxy |
| **Monitoring** | Prometheus | on | Metrics collection |
| | Grafana | on | Dashboards |
| | cAdvisor | on | Container metrics |
| **Logging** | Loki | on | Log aggregation |
| | Promtail | on | Log shipping |
| **Tracing** | Tempo | off | Distributed tracing |
| **Secrets** | Vault | on | Secrets management |
| | Vault Agent | on | Auto-sync secrets to containers |
| **Deploy** | Watchtower | on | Auto-deploy on image push |

## Architecture

```
┌──────────────────────────────────────┐
│  Docker Compose Overlay Pattern      │
│                                      │
│  base → environment (local/dev/prod) │
│                                      │
│  Similar to Kustomize, but for       │
│  Docker Compose                      │
└──────────────────────────────────────┘
```

Each service is:
- Defined in base compose files
- Configured per-environment via overlays
- Toggled on/off via Docker Compose profiles
- Managed through a justfile command runner

## Development

```bash
make build      # Build binary
make test       # Run tests
make test-full  # Generate + validate full project
make lint       # Run linter
```

## Roadmap

- [ ] `compose-cd sync` — GitOps reconciliation agent (watch repo, auto-deploy)
- [ ] `compose-cd update` — Re-scaffold with new template version
- [ ] Web dashboard for deployment status
- [ ] Homebrew tap

## License

MIT
