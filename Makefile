VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
COMMIT  ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo none)
DATE    ?= $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
LDFLAGS  = -ldflags "-X github.com/avamico/compose-cd/cmd.Version=$(VERSION) \
                      -X github.com/avamico/compose-cd/cmd.Commit=$(COMMIT) \
                      -X github.com/avamico/compose-cd/cmd.Date=$(DATE)"

.PHONY: build test lint clean install

build:
	go build $(LDFLAGS) -o bin/compose-cd .

install:
	go install $(LDFLAGS) .

test:
	go test ./... -v

lint:
	golangci-lint run

clean:
	rm -rf bin/

# Quick test: generate full project with defaults
test-full: build
	rm -rf /tmp/compose-cd-test-full
	./bin/compose-cd init --defaults -p test-project -o testorg /tmp/compose-cd-test-full
	cd /tmp/compose-cd-test-full/deploy && docker compose \
		-f docker-compose.ops.yml \
		-f ops/overlays/base/docker-compose.yml \
		-f ops/overlays/local/docker-compose.yml \
		-f docker-compose.app.yml \
		-f app/overlays/base/docker-compose.yml \
		-f app/overlays/local/docker-compose.yml \
		-f docker-compose.local.yml \
		config > /dev/null
	@echo "Full test passed!"

# Quick test: generate minimal project
test-minimal: build
	rm -rf /tmp/compose-cd-test-minimal
	./bin/compose-cd init --defaults --minimal -p test-min -o testorg /tmp/compose-cd-test-minimal
	cd /tmp/compose-cd-test-minimal/deploy && docker compose \
		-f docker-compose.ops.yml \
		-f ops/overlays/base/docker-compose.yml \
		-f ops/overlays/local/docker-compose.yml \
		-f docker-compose.app.yml \
		-f app/overlays/base/docker-compose.yml \
		-f app/overlays/local/docker-compose.yml \
		-f docker-compose.local.yml \
		config > /dev/null
	@echo "Minimal test passed!"
