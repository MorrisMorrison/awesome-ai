# Go Development Instructions

This is a Go application following modern Go development practices and idioms. Always use the latest stable version of Go (1.22 or newer).

## Project Standards

### Code Style and Conventions
- Follow Go naming conventions: camelCase for private, PascalCase for public
- Use gofmt and goimports for consistent formatting
- Run golangci-lint for static analysis
- Prefer short, descriptive variable names (i, j for indices; err for errors)
- Use meaningful package names that describe functionality, not types

### Architecture Patterns
- Apply Clean Architecture with clear separation of concerns:
  - `cmd/`: Application entrypoints
  - `internal/`: Core application logic (not exposed externally)
  - `pkg/`: Shared utilities and packages that can be imported
  - `api/`: API definitions and handlers
  - `domain/`: Business logic and entities
- Use interface-driven development with explicit dependency injection
- Prefer composition over inheritance; favor small, purpose-specific interfaces
- Ensure all public functions interact with interfaces, not concrete types

### Error Handling
- Always handle errors explicitly; never ignore them
- Use custom error types when additional context is needed
- Wrap errors with context using fmt.Errorf with %w verb
- Return errors as the last return value
- Use structured logging for error context

### Concurrency and Performance
- Use goroutines and channels when beneficial for performance
- Implement proper context handling with context.Context
- Use sync.WaitGroup for coordinating goroutines
- Implement graceful shutdowns with signal handling
- Be mindful of race conditions; use sync package when needed

### HTTP and API Development
- Use the standard library's net/http package for API development
- Utilize Go 1.22+ ServeMux features (wildcard matching, regex support)
- Implement proper HTTP method handling (GET, POST, PUT, DELETE, etc.)
- Use middleware for cross-cutting concerns (logging, auth, CORS)
- Return appropriate HTTP status codes and content types

### Testing Standards
- Write unit tests using table-driven patterns
- Use parallel execution where appropriate (t.Parallel())
- Mock external interfaces cleanly using generated or handwritten mocks
- Separate fast unit tests from slower integration tests
- Ensure test coverage for every exported function
- Use testify/assert for more readable assertions

### AI Integration with Go
- Use langchaingo or Ollama for flexible AI service integration
- For Google services, use github.com/google/generative-ai-go/genai
- Use Google's Genkit framework for comprehensive AI workflows
- Implement proper prompt templating with text/template package
- Handle AI service timeouts and retries appropriately

### Documentation and Standards
- Document public functions and packages with GoDoc-style comments
- Start comments with the function/type name
- Provide concise READMEs for services and libraries
- Maintain CONTRIBUTING.md and ARCHITECTURE.md files
- Use conventional commit messages

### Observability and Monitoring
- Use OpenTelemetry for distributed tracing, metrics, and structured logging
- Implement health check endpoints (/health, /ready)
- Use structured logging with slog (Go 1.21+) or logrus
- Include correlation IDs in request contexts
- Monitor key business metrics and performance indicators

### Security Best Practices
- Validate all inputs at API boundaries
- Use HTTPS in production configurations
- Implement proper authentication and authorization
- Never log sensitive information (tokens, passwords, etc.)
- Use secure random number generation from crypto/rand

## Commands and Tools
- Format code: `go fmt ./...`
- Organize imports: `goimports -w .`
- Run tests: `go test ./...`
- Test with coverage: `go test -cover ./...`
- Build binary: `go build -o bin/app cmd/main.go`
- Static analysis: `golangci-lint run`
- Module management: `go mod tidy`

## Dependencies Management
- Use Go modules for dependency management
- Pin dependencies to specific versions in go.mod
- Use `go mod verify` to ensure dependency integrity
- Minimize external dependencies; prefer standard library when possible

## When generating code:
1. Always include proper package declarations
2. Add appropriate imports (prefer standard library)
3. Include comprehensive error handling
4. Generate corresponding test files with table-driven tests
5. Follow Go project layout conventions
6. Add GoDoc comments for exported functions
7. Use interfaces for testability and flexibility
8. Implement context handling for cancellation and timeouts