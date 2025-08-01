# Spage Protobuf

This repository contains Protocol Buffer definitions for the Spage project, along with code generation for both Go and TypeScript.

## Overview

The protobuf definitions define the communication protocol between:

- **spage-daemon**: The daemon that runs on target machines
- **spage-api**: The centralized API server
- **spage-web**: The web dashboard

## Code Generation

### Prerequisites

1. Install `protoc` (Protocol Buffer compiler)
2. Install Go protobuf plugins:

   ```bash
   go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
   go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
   ```

3. Install Node.js dependencies:

   ```bash
   npm install
   ```

### Generating Code

#### Generate Go code only

```bash
make proto-go
# or
npm run proto:go
```

#### Generate TypeScript code only

```bash
make proto-ts
# or
npm run proto:ts
```

#### Generate both Go and TypeScript code

```bash
make proto
# or
npm run proto
```

### Generated Files

#### Go

- `spage/core/*.pb.go` - Core protobuf message types
- `spage/api/*.pb.go` - API service definitions

#### TypeScript

- `generated/typescript/spage/core/` - Core TypeScript types
- `generated/typescript/spage/api/` - API TypeScript types

## Using Generated Types

### In Go Projects

```go
import (
    "github.com/AlexanderGrooff/spage-protobuf/spage/core"
    "github.com/AlexanderGrooff/spage-protobuf/spage/api"
)
```

### In TypeScript Projects

```typescript
import { SpagePlay, PlayStatus } from '../../../spage-protobuf/generated/typescript/spage/core/plays';
import { SpageTask, TaskStatus } from '../../../spage-protobuf/generated/typescript/spage/core/common';
```

## Development Workflow

1. **Modify protobuf files** in `spage/core/` or `spage/api/`
2. **Regenerate code**: `make proto`
3. **Update consuming projects** to use the new types
4. **Test** the changes in all components

## File Structure

```
spage-protobuf/
├── spage/
│   ├── core/
│   │   ├── common.proto      # Common types (Task, Error, Health)
│   │   └── plays.proto       # Play-related types
│   └── api/
│       └── aggregation.proto  # API service definitions
├── generated/
│   └── typescript/           # Generated TypeScript types
├── Makefile                  # Build automation
├── package.json              # Node.js dependencies
└── README.md                 # This file
```

## TypeScript Configuration

The TypeScript generation uses `ts-proto` with the following options:

- `esModuleInterop=true` - Better ES module compatibility
- `forceLong=string` - Use strings for 64-bit integers
- `useOptionals=messages` - Make message fields optional
- `exportCommonSymbols=false` - Avoid naming conflicts
- `stringEnums=true` - Use string enums instead of numeric

## Contributing

When adding new protobuf definitions:

1. Add the new `.proto` file
2. Update the generation commands if needed
3. Regenerate all code: `make proto`
4. Update this README if the structure changes
5. Test the changes in all consuming projects

## Troubleshooting

### TypeScript Generation Issues

- Ensure `ts-proto` is installed: `npm install`
- Check that the output directory exists: `mkdir -p generated/typescript`
- Verify protobuf syntax: `protoc --version`

### Go Generation Issues

- Ensure Go protobuf plugins are installed
- Check that `protoc` is in your PATH
- Verify the `go.mod` file is up to date
