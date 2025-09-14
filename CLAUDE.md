# My Games Platform - Claude Code Context

## Project Overview
Gaming platform with 5 Rust microservices using Jeremy Chone patterns, deployed on k3d Kubernetes cluster.

**Services:**
- `hello-world/` - Template service following Jeremy Chone patterns
- `game-registry/` - Game creation and player management (89+ tests)
- `game-engine/` - Tic-tac-toe logic and move validation (23+ tests)  
- `game-frontend/` - Web interface with SSE proxy (7+ tests)
- `game-realtime/` - Server-Sent Events streaming (11+ tests)

**Current Status:** Production-ready platform with 128+ tests, real-time multiplayer tic-tac-toe gameplay demonstrated end-to-end.

## Workflow Commands

### Status and Validation
- **"check status"** or **"show me current state"** → Execute `/status` command
- **"ready to commit"** or **"validate before commit"** → Execute `/ready-to-commit` command  
- **"run all tests"** or **"test everything"** → Execute `/test-all` command

### Integration Decisions
- **"need connection features"** or **"friends connect integration"** → Execute `/merge-friends` command
- Always ask before integrating patterns from friends-connect repositories

## Development Standards

### Testing Requirements (MANDATORY)
All commits must pass:
- **Rust tests:** `cargo test` in all 5 service directories (target: 128+ total tests)
- **k3d cluster:** Cluster 'clutchrun' running with all pods healthy
- **Documentation:** All context files current and non-empty

### Git Workflow
- **Branch naming:** `issue-###-short-description` (validated in `/ready-to-commit`)
- **Issue-driven development:** All features start with GitHub Issues
- **Small steps:** Use `/ready-to-commit` before every commit

### Architecture Patterns
- **Jeremy Chone Rust/Axum patterns:** Error handling, context, BMC layers
- **Microservices:** Each service independent with health checks
- **Real-time:** SSE streaming with CORS-free proxy architecture
- **Testing:** Comprehensive unit + integration tests

## Build and Deploy Commands

### Local Development
```bash
# Hot reload during development (per service)
cargo watch -q -c -w src/ -x "run"

# Test individual service
cargo test

# Start k3d cluster
k3d cluster start clutchrun

# Port forward for testing
kubectl port-forward svc/game-frontend -n my-games 8085:80 &
kubectl port-forward svc/game-registry -n my-games 8086:80 &
kubectl port-forward svc/game-engine -n my-games 8084:80 &
kubectl port-forward svc/game-realtime -n my-games 8087:80 &
```

### Service URLs (after port forward)
- **Game Frontend (Web UI):** http://localhost:8085/
- **Game Registry API:** http://localhost:8086/health
- **Game Engine API:** http://localhost:8084/health  
- **Game Realtime SSE:** http://localhost:8087/health

## Context Engineering Files

### Development Tracking
- `.claude/context/current-issue.md` - Active development state
- `.claude/context/test-requirements.md` - Testing strategy and checklist
- `.claude/context/friends-integration.md` - Available connection patterns
- `.claude/context/decision-log.md` - Architectural decisions record

### Resource Integration
Available for pattern integration (ask first via `/merge-friends`):
- **clutch-deployments** - k3d deployment patterns ✅ Already integrated
- **clutch** - Microservices architecture ✅ Already integrated  
- **friends-connect** - Primary connection strategies ⏳ Available
- **hello-friends-connect** - Hello world patterns ⏳ Available
- **sandbox-friends-connect** - Experimental patterns ⏳ Available

## Project Structure
```
my-games/
├── .claude/                    # Claude Code workflow
│   ├── commands/              # Slash commands (status, test-all, etc.)
│   └── context/               # Development context tracking
├── hello-world/               # Template service
├── game-registry/             # Game management service  
├── game-engine/               # Game logic service
├── game-frontend/             # Web interface service
├── game-realtime/             # SSE streaming service
├── context/                   # Original project documentation
└── README.md                  # Project overview
```

## Important Notes
- **Real-time Features:** Complete SSE implementation with backend auto-broadcasting
- **Production Ready:** All services deployed with 2 replicas each
- **Testing Discipline:** Never commit without running `/ready-to-commit`
- **Friends Integration:** Always use `/merge-friends` before adding connection features
- **Documentation:** Keep context files current - they guide all development decisions