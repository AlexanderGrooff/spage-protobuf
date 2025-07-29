.PHONY: help clean proto

# Default target
help:
	@echo "Available targets:"
	@echo "  clean     - Clean build artifacts"
	@echo "  proto     - Generate Go code from protobuf files"

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

# Install protoc plugins (run once)
install-protoc-plugins:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

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
ci: proto fmt lint security

# CI build (regenerate proto and build)
ci-build: proto build-only