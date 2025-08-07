.PHONY: help clean proto proto-go proto-ts

# Generate both Go and TypeScript code
proto: proto-go proto-ts

help:
	@echo "Available targets:"
	@echo "  clean     - Clean build artifacts"
	@echo "  proto     - Generate Go and TypeScript code from protobuf files"
	@echo "  proto-go  - Generate Go code from protobuf files"
	@echo "  proto-ts  - Generate TypeScript code from protobuf files"

# Clean build artifacts
clean:
	rm -rf spage/core/*.pb.go
	rm -rf spage/api/*.pb.go
	rm -rf generated/typescript

# Generate Go code from protobuf files
proto-go:
	@echo "Generating Go code from protobuf files..."
	protoc --go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		spage/core/*.proto
	protoc --go_out=. --go_opt=paths=source_relative \
		--go-grpc_out=. --go-grpc_opt=paths=source_relative \
		spage/api/*.proto
	@echo "Go proto generation complete"

# Generate TypeScript code from protobuf files
proto-ts:
	@echo "Generating TypeScript code from protobuf files..."
	@if [ ! -d "node_modules" ]; then \
		echo "Installing dependencies..."; \
		npm install; \
	fi
	@mkdir -p generated/typescript
	protoc --plugin=protoc-gen-ts_proto=./node_modules/.bin/protoc-gen-ts_proto \
		--ts_proto_out=generated/typescript \
		--ts_proto_opt=esModuleInterop=true,forceLong=string,useOptionals=messages,exportCommonSymbols=false,stringEnums=true,useSnakeCase=true,snakeToCamel=false \
		spage/core/*.proto spage/api/*.proto
	@echo "TypeScript proto generation complete"

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
