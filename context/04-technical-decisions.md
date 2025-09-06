# Technical Decisions & Rationale

## Architecture Decisions

### 1. Microservices Architecture
**Decision**: Break backend into 4 separate services
**Rationale**: 
- Maximum reusability across different game types
- Clear separation of concerns
- Independent scaling and deployment
- Easier to maintain and debug
- Aligns with Jeremy Chone's modular patterns

### 2. Stateless Design (No Database)
**Decision**: Store all data in browser localStorage
**Rationale**:
- Eliminates database complexity and costs
- No user account system needed
- Perfect for friend-to-friend gaming
- Reduces privacy concerns
- Simplifies deployment and maintenance
- Email backup provides recovery mechanism

### 3. TypeScript for Game Rules
**Decision**: Game creators write TypeScript functions
**Rationale**:
- Provides type safety and good developer experience
- Familiar to web developers
- Can be executed safely (though we're limiting to creator's own games)
- Rich ecosystem for validation and tooling
- Flexible enough for any turn-based game

### 4. Server-Sent Events (SSE) over WebSockets
**Decision**: Use SSE for real-time updates
**Rationale**:
- Simpler than WebSockets for one-way server→client communication
- Automatic reconnection built-in
- Works better with HTTP/2 and modern infrastructure
- Perfect for turn-based games (don't need bidirectional real-time)
- Better support in Cloud Run environment
- Can fall back to polling easily

## Technology Stack Decisions

### Frontend: GitHub Pages + Vanilla TypeScript
**Decision**: Static hosting with no framework
**Rationale**:
- Free hosting with excellent CDN
- No build complexity
- Fast loading and simple deployment
- Educational value (shows platform can work anywhere)
- Easy for others to fork and modify

### Backend: Rust + Axum
**Decision**: Rust with Axum framework
**Rationale**:
- Performance and memory safety
- Excellent async support for SSE
- Axum's middleware system perfect for microservices
- Jeremy Chone's patterns provide proven structure
- Growing ecosystem and community

### Deployment: Google Cloud Platform + Cloud Run
**Decision**: Containerized microservices on Cloud Run
**Rationale**:
- Serverless benefits (zero ops, auto-scaling)
- Pay-per-request pricing ideal for gaming workloads
- Built-in load balancing and HTTPS
- Easy multi-service deployment
- Excellent SSE support
- Regional deployment for low latency

## Design Pattern Decisions

### 1. Jeremy Chone Patterns
**Decision**: Adopt all of Jeremy Chone's Rust/Axum patterns
**Rationale**:
- Proven production-ready patterns
- Excellent error handling with `thiserror`
- Clean modular structure
- Great development workflow with `cargo watch`
- Context pattern perfect for microservices
- Consistent across all services

### 2. Resource-Based API Design
**Decision**: RESTful APIs with resource-based URLs
**Example**: `/api/games/{game_id}/moves` vs `/api/submitMove`
**Rationale**:
- Clear, predictable API structure
- Easy to understand and document
- Scales well across multiple services
- Standard HTTP semantics

### 3. Flexible Game State
**Decision**: Allow games to define any JSON structure for state
**Rationale**:
- Maximum flexibility for game creators
- No need to anticipate all possible game types
- Simple serialization/deserialization
- Easy to backup and restore

## Security & Safety Decisions

### 1. Creator-Only Game Deployment
**Decision**: Only the platform creator can add games (not open user submission)
**Rationale**:
- Eliminates code execution security concerns
- Simpler architecture without sandboxing
- Each deployment is curated by the instance owner
- Open source allows others to create their own instances

### 2. Client-Side Validation + Server Authority
**Decision**: Validate moves on both client and server
**Rationale**:
- Client validation provides immediate feedback
- Server validation ensures game integrity
- Prevents cheating while maintaining good UX

### 3. Email-Based Backup
**Decision**: Use email for game state backups
**Rationale**:
- Universal - everyone has email
- No additional storage infrastructure needed
- Built-in delivery confirmation
- Players control their own data

## Communication Decisions

### 1. Service-to-Service Communication
**Decision**: HTTP/JSON for inter-service calls
**Rationale**:
- Simple and universal
- Cloud Run's internal networking is fast
- Easy to debug and monitor
- No additional message queue infrastructure

### 2. Real-Time Update Strategy
**Decision**: SSE for moves, polling fallback
**Rationale**:
- SSE provides instant updates when working
- Polling ensures reliability when SSE fails
- Turn-based games can tolerate brief delays
- Simpler than complex reconnection logic

## Development & Operations Decisions

### 1. Hot Reload Development
**Decision**: Use `cargo watch` for development
**Rationale**:
- Fast feedback loop during development
- Matches Jeremy Chone's proven workflow
- Essential for microservices development

### 2. Quick Testing Setup
**Decision**: `examples/quick_dev.rs` for each service
**Rationale**:
- Fast endpoint testing without full setup
- Can test services independently
- Great for TDD and debugging

### 3. Container-Based Deployment
**Decision**: Docker containers for each service
**Rationale**:
- Consistent deployment across environments
- Cloud Run requirement
- Easy to version and rollback
- Enables CI/CD pipeline

## Future-Proofing Decisions

### 1. Open Source + Self-Hosted
**Decision**: Open source architecture, self-hosted instances
**Rationale**:
- Community can extend and improve
- No vendor lock-in for game creators
- Educational value
- Sustainable business model options

### 2. Modular Service Design
**Decision**: Keep services small and focused
**Rationale**:
- Easy to replace individual services
- Can optimize each service independently
- Easier to understand and contribute to
- Natural evolution path (start simple, add complexity)