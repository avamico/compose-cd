# compose-cd

ArgoCD-like GitOps deployment platform for Docker Compose on VPS.

## What is this?

An interactive scaffolding tool that generates production-ready deployment repos for Docker Compose. Like `create-react-app` but for your infrastructure.

You answer a few questions and get a customized repo with:
- **Docker Compose** overlay pattern (base → environment-specific configs)
- **Observability** (Prometheus, Grafana, Loki, Tempo, cAdvisor, Promtail)
- **Secrets management** (HashiCorp Vault + Vault Agent)
- **Reverse proxy** (Caddy or Traefik)
- **Continuous deployment** (Watchtower)
- **Infrastructure as Code** (Terraform: Hetzner, Cloudflare, Supabase)
- **CI/CD** (GitHub Actions, pre-commit hooks, Gitleaks)
- **Command runner** (Justfile)

Only the services you select are included. No bloat.

## Quick Start

### Prerequisites

- [Python 3.8+](https://www.python.org/)
- [Copier](https://copier.readthedocs.io/): `pip install copier`

### Generate a project

```bash
copier copy https://github.com/avamico/compose-cd my-app-deployments
```

You'll be asked:
- Project name, service name, GitHub owner
- Docker image, app port, health check path
- Which environments (local, dev, prod)
- Which services to include (Grafana, Vault, Caddy, etc.)
- Whether to include Terraform

### Use your generated project

```bash
cd my-app-deployments

# Start locally
just up

# Start everything (reverse proxy, log shipping, etc.)
just up-all

# Deploy to VPS
just deploy dev user@your-vps.com
```

### Update when template evolves

```bash
cd my-app-deployments
copier update
```

Copier will merge template updates while preserving your customizations.

## What gets generated

```
my-app-deployments/
├── deploy/
│   ├── docker-compose.ops.yml      # Ops services (monitoring, vault, etc.)
│   ├── docker-compose.app.yml      # Your application service
│   ├── docker-compose.local.yml    # Local dev port overrides
│   ├── ops/
│   │   ├── configs/                # Service configurations
│   │   │   ├── caddy/              # Reverse proxy
│   │   │   ├── prometheus/         # Metrics collection
│   │   │   ├── grafana/            # Dashboards + datasources
│   │   │   ├── loki/               # Log aggregation
│   │   │   ├── tempo/              # Distributed tracing
│   │   │   ├── promtail/           # Log shipping
│   │   │   ├── vault/              # Secrets management
│   │   │   └── traefik/            # Alternative reverse proxy
│   │   └── overlays/               # Environment-specific configs
│   │       ├── base/
│   │       ├── local/
│   │       ├── dev/
│   │       └── prod/
│   └── app/
│       └── overlays/               # App environment configs
├── terraform/                       # Infrastructure as Code (optional)
├── scripts/                         # Setup scripts
├── justfile                         # Command shortcuts
└── .github/workflows/               # CI/CD
```

## Architecture

```
┌─────────────────┐         ┌─────────────────────────────────────┐
│  Cloudflare DNS │         │           Hetzner VPS               │
│   (SSL Proxy)   │────────▶│                                     │
└─────────────────┘         │  ┌─────────────┐  ┌─────────────┐  │
                            │  │ Caddy/Traefik│  │   Grafana   │  │
                            │  └──────┬───────┘  └─────────────┘  │
                            │         │                           │
                            │    ┌────┴────┐    Observability:    │
                            │    │ Your App│    Prometheus, Loki  │
                            │    └─────────┘    Tempo, cAdvisor   │
                            │                                     │
                            │    Secrets: Vault + Vault Agent     │
                            │    Deploy: Watchtower (auto-update) │
                            └─────────────────────────────────────┘
```

## Service Options

| Service | Default | Purpose |
|---------|---------|---------|
| Prometheus | ✅ | Metrics collection |
| Grafana | ✅ | Dashboards (3 pre-built) |
| Loki | ✅ | Log aggregation |
| Promtail | ✅ | Log shipping |
| Tempo | ❌ | Distributed tracing |
| cAdvisor | ✅ | Container metrics |
| Vault | ✅ | Secrets management |
| Vault Agent | ✅ | Auto-sync secrets |
| Caddy | ✅ | Reverse proxy (auto-SSL) |
| Traefik | ❌ | Alternative reverse proxy |
| Watchtower | ✅ | Auto-deploy on image push |

## Roadmap

- [ ] **Part 2: Sync Agent** — Go daemon for GitOps reconciliation
  - Watch Git repo for changes
  - Diff desired vs running state
  - Web dashboard showing sync status
  - Webhook receiver for instant deploys
- [ ] Multi-app support (multiple services in one repo)
- [ ] Alerting rules templates
- [ ] Zero-downtime deployment via docker-rollout

## License

MIT
