# Spring Boot Development Instructions

This is a Java Spring Boot application using Maven for dependency management and following enterprise development patterns.

## Project Standards

### Build and Dependencies
- We use Maven for dependency management, not Gradle
- Always use Spring Boot starters when available
- Target Java 17+ features
- Use Spring AI framework for AI integrations instead of direct API calls

### Code Style and Conventions
- Follow standard Java naming conventions (camelCase for variables/methods, PascalCase for classes)
- Use constructor injection instead of field injection (@Autowired on fields is discouraged)
- Keep controllers thin - delegate business logic to service classes
- Use DTOs for API requests/responses, never expose entities directly
- Prefer record classes for immutable data structures

### Architecture Patterns
- Apply Clean Architecture principles with clear separation of concerns
- Structure packages by feature/domain, not by layer
- Use @Service classes as transactional boundaries
- Annotate read-only operations with @Transactional(readOnly=true)
- Keep transactions as short as possible

### Spring Boot Best Practices
- Use Spring Boot Auto Configuration whenever possible
- Create custom @ConfigurationProperties classes for application properties
- Use meaningful method names for Spring Data JPA repositories with JPQL when needed
- Implement proper exception handling with @ControllerAdvice
- Use Spring Security for authentication and authorization

### Testing Standards
- Write unit tests for all service layer methods
- Use @MockBean for mocking Spring beans in tests
- Implement integration tests with @SpringBootTest
- Use TestContainers for database integration tests
- Aim for at least 80% test coverage

### Documentation and Comments
- Document all public APIs with proper JavaDoc
- Include usage examples in method documentation
- Maintain up-to-date README.md with setup instructions
- Document configuration properties and their purposes

### Error Handling
- Use custom exception classes that extend appropriate base exceptions
- Implement global exception handling with @ControllerAdvice
- Return appropriate HTTP status codes
- Log errors with proper context and correlation IDs

### Performance and Security
- Always validate input parameters
- Use pagination for large data sets
- Implement proper caching strategies with @Cacheable
- Never log sensitive information (passwords, tokens, etc.)
- Use HTTPS in production configurations

### Spring AI Integration
- Use Spring AI ChatClient for LLM interactions
- Implement RAG patterns with Spring AI vector stores
- Use Spring AI structured output for type-safe responses
- Follow Spring AI best practices for prompt engineering

## Commands and Tools
- Build: `mvn clean compile`
- Test: `mvn test`
- Package: `mvn clean package`
- Run locally: `mvn spring-boot:run`
- Code formatting: Configure Maven Spotless plugin
- Static analysis: Use SpotBugs and Checkstyle plugins

## When generating code:
1. Always include proper imports
2. Add appropriate Spring annotations
3. Include basic error handling
4. Generate corresponding test methods
5. Follow the package structure conventions
6. Include JavaDoc for public methods