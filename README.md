# Spage Protobuf Definitions

This directory contains the Protocol Buffer definitions for communication between Spage ecosystem components.

## Architecture Overview

```
┌─────────────┐    gRPC    ┌─────────────┐    gRPC    ┌─────────────┐
│    Spage    │◄──────────►│   Daemon    │◄──────────►│     API     │
│   (Core)    │  execution │             │    tasks   │   (SaaS)    │
└─────────────┘            └─────────────┘            └─────────────┘
```

## Directory Structure

```
proto/
├── spage/
│   ├── core/           # Spage ↔ Daemon communication
│   │   ├── common.proto    # Shared types and enums
│   │   └── execution.proto # Task execution interface
│   └── api/            # Daemon ↔ API communication
│       └── tasks.proto     # Task management interface
└── README.md
```

## Interfaces

### 1. Spage ↔ Daemon (Internal Communication)

**File**: `spage/core/execution.proto`

**Service**: `SpageExecution`

**Purpose**: Communication between Spage core engine and the daemon for task execution.

**Key Operations**:
- `ExecuteTask()` - Start a new task execution
- `CancelTask()` - Cancel a running task
- `GetTaskStatus()` - Get current task status
- `StreamProgress()` - Real-time progress updates (bidirectional)
- `HealthCheck()` - Component health status
- `GetMetrics()` - Component metrics

**Usage**: Spage processes connect to the daemon's gRPC server to report progress and receive commands.

### 2. Daemon ↔ API (External Communication)

**File**: `spage/api/tasks.proto`

**Service**: `SpageAPI`

**Purpose**: Communication between the daemon and the SaaS API for task management.

**Key Operations**:
- `SubmitTask()` - Submit a new task to the API
- `GetTaskStatus()` - Get task status from the API
- `CancelTask()` - Cancel a task via the API
- `ListTasks()` - List tasks with filtering
- `StreamEvents()` - Real-time events (bidirectional)
- `Authenticate()` - API authentication
- `ValidateToken()` - Token validation
- `HealthCheck()` - API health status
- `GetMetrics()` - API metrics

**Usage**: The daemon connects to the SaaS API to receive tasks and report results.

## Shared Types

**File**: `spage/core/common.proto`

Common types used across both interfaces:

- `Task` - Complete task representation
- `TaskStatus` - Task status enumeration
- `TaskPriority` - Task priority enumeration
- `TaskResult` - Task execution result
- `ProgressUpdate` - Real-time progress updates
- `Event` - Generic events
- `Error` - Error responses
- `HealthStatus` - Health check responses
- `Metrics` - Metrics data

## Code Generation

### Prerequisites

Install the required protoc plugins:

```bash
make install-protoc-plugins
```

### Generate Go Code

```bash
make proto
```

This will generate:
- `spage/core/*.pb.go` - Go structs and gRPC client/server code
- `spage/api/*.pb.go` - Go structs and gRPC client/server code

### Build with Generated Code

```bash
make build
```

## Usage Examples

### Spage Process Connecting to Daemon

```go
import (
    "github.com/AlexanderGrooff/spage-daemon/spage/core"
    "google.golang.org/grpc"
)

// Connect to daemon
conn, err := grpc.Dial("localhost:9091", grpc.WithInsecure())
if err != nil {
    log.Fatal(err)
}
defer conn.Close()

// Create client
client := core.NewSpageExecutionClient(conn)

// Stream progress updates
stream, err := client.StreamProgress(context.Background())
if err != nil {
    log.Fatal(err)
}

// Send progress updates
for {
    update := &core.ProgressUpdate{
        TaskId: "task-123",
        Progress: 50.0,
        Message: "Processing hosts...",
    }
    stream.Send(update)
}
```

### Daemon Connecting to API

```go
import (
    "github.com/AlexanderGrooff/spage-daemon/spage/api"
    "google.golang.org/grpc"
)

// Connect to API
conn, err := grpc.Dial("api.spage.com:9090", grpc.WithInsecure())
if err != nil {
    log.Fatal(err)
}
defer conn.Close()

// Create client
client := api.NewSpageAPIClient(conn)

// Submit task
resp, err := client.SubmitTask(context.Background(), &api.SubmitTaskRequest{
    TaskId: "task-123",
    Type: "playbook",
    Priority: core.TASK_PRIORITY_NORMAL,
    Payload: map[string]string{
        "playbook": "main.yml",
        "inventory": "hosts.yml",
    },
})
```

## Versioning

- **v1.0.0** - Initial API contracts
- **v1.1.0** - Add metrics and health endpoints
- **v2.0.0** - Breaking changes (if needed)

## Best Practices

1. **Backward Compatibility**: Avoid breaking changes in existing fields
2. **Field Numbers**: Never reuse field numbers, even if fields are removed
3. **Default Values**: Use sensible defaults for optional fields
4. **Documentation**: Add comprehensive comments to all messages and fields
5. **Validation**: Implement server-side validation for all requests
6. **Error Handling**: Use the `Error` message type for consistent error responses
7. **Streaming**: Use bidirectional streaming for real-time communication
8. **Authentication**: Include authentication in all external API calls

## Future Enhancements

- [ ] Add more granular task states
- [ ] Support for task dependencies
- [ ] Batch operations for multiple tasks
- [ ] Enhanced metrics and monitoring
- [ ] Support for different authentication methods
- [ ] Rate limiting and throttling
- [ ] Audit logging and compliance 