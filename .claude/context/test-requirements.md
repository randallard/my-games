# Testing Requirements and Strategy

## Testing Philosophy

Every commit must pass all tests. No exceptions. Small steps with comprehensive validation.

## Test Categories

### 1. Rust Service Tests
**Location**: Each service directory (`cargo test`)
**Current Status**: 128+ tests passing
- Game Registry: 89 tests
- Game Engine: 23 tests  
- Game Frontend: 7+ tests
- Game Realtime: 11+ tests
- Hello World: Basic tests

**Command**: 
```bash
# Run all service tests
for service in hello-world game-registry game-engine game-frontend game-realtime; do
    echo "Testing $service..."
    cd $service && cargo test && cd ..
done
```

### 2. Frontend Validation Tests
**Location**: game-frontend service
**Focus**: SSE proxy, web interface, integration
**Command**:
```bash
cd game-frontend && cargo test
```

### 3. k3d Integration Tests  
**Location**: Integration test scripts
**Focus**: Full stack deployment testing
**Current**: Manual curl-based testing
**Command**:
```bash
# Ensure cluster is running
k3d cluster list | grep clutchrun
# Run port forwarding
kubectl port-forward svc/game-frontend -n my-games 8085:80 &
kubectl port-forward svc/game-registry -n my-games 8086:80 &
kubectl port-forward svc/game-engine -n my-games 8084:80 &
kubectl port-forward svc/game-realtime -n my-games 8087:80 &
# Test endpoints
curl http://localhost:8085/health
curl http://localhost:8086/health  
curl http://localhost:8084/health
curl http://localhost:8087/health
```

### 4. Documentation Currency Check
**Location**: Context files and README
**Focus**: Ensure docs reflect current state
**Validation**:
- README matches actual deployment status
- Decision log is current
- Context files updated
- Version numbers match

## Pre-Commit Validation Checklist

- [ ] All cargo tests pass
- [ ] Frontend tests pass
- [ ] k3d cluster healthy
- [ ] Services respond to health checks
- [ ] Documentation updated
- [ ] Git status clean (no uncommitted changes in working directory)
- [ ] Branch follows naming convention: `issue-{number}-{short-description}`
- [ ] Commit message follows conventional format

## Test Failure Protocol

1. **Identify failing test category**
2. **Run specific test suite in isolation**
3. **Analyze failure output**
4. **Fix issue with Claude Code assistance**
5. **Re-run full test suite**
6. **Document any architectural changes**

## Continuous Integration Notes

Currently manual testing. Future: GitHub Actions CI/CD pipeline.

---

*Updated by `/ready-to-commit` command*
