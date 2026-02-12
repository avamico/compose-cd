# compose-cd — Todos

## Part 1: Template Engine (Polish)

- [ ] Unit tests for `internal/config` (defaults, validation, TemplateData)
- [ ] Unit tests for `internal/scaffold/funcmap` (splitWords, joinQuoted, containsStr, splitComma, joinBracketedCSV)
- [ ] Unit tests for `internal/scaffold/exclusion` (dir/file rules, vault-without-agent edge case)
- [ ] Golden file integration tests (generate with known config, compare against snapshot in `testdata/`)
- [ ] GitHub Actions CI workflow for compose-cd itself (run tests + `make test-full` + `make test-minimal` on PR)

## Part 2: Sync Agent

- [ ] `compose-cd sync` — Go daemon that watches a git repo and auto-deploys changes via Docker Compose
- [ ] `compose-cd update` — Re-scaffold existing project with newer template version (preserve user customizations)
- [ ] Web dashboard for deployment status (which services are running, health, last deploy time)

## Distribution

- [ ] Homebrew tap (`brew install avamico/tap/compose-cd`)
- [ ] Tag v0.1.0 release and publish binaries via GoReleaser
