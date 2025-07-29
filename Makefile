.PHONY: help build test clean proto generate

# Default target
help:
	@echo "Available targets:"
	@echo "  build     - Build the spage-daemon binary"
	@echo "  test      - Run tests"
	@echo "  clean     - Clean build artifacts"
	@echo "  proto     - Generate Go code from protobuf files"
	@echo "  generate  - Generate all code (proto + other generators)"

# Build the binary
build: proto
	go build -o spage-daemon .

# Build without regenerating proto (for CI/CD)
build-only:
	go build -o spage-daemon .

# Run tests
test: proto
	go test ./...

# Clean build artifacts
clean:
	rm -rf spage/core/*.pb.go
	rm -rf spage/api/*.pb.go

# Generate Go code from protobuf files
proto:
	@echo "Generating Go code from protobuf files..."
	protoc --go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		spage/core/*.proto
	protoc --go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		spage/api/*.proto
	@echo "Proto generation complete"

# Generate all code
generate: proto
	@echo "All code generation complete"

# Install protoc plugins (run once)
install-protoc-plugins:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Development helpers
dev-build: proto
	go build -race -o spage-daemon .

dev-test: proto
	go test -race -v ./...

# Run the daemon with default settings
run: build
	SPAGE_STORAGE_DATABASE_PATH="./data/daemon.db" \
	SPAGE_STORAGE_FILE_BASE_DIR="./data/files" \
	./spage-daemon

# Format code
fmt:
	go fmt ./...

# Lint code
lint:
	golangci-lint run

# Check for security issues
security:
	gosec ./...

# Full CI check
ci: proto fmt lint security test

# CI build (regenerate proto and build)
ci-build: proto build-only 