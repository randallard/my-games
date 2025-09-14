---
allowed-tools: Bash(cargo test:*), Bash(kubectl:*), Bash(k3d:*), Bash(git:*)
description: Run comprehensive test suite across all services
---

Run comprehensive testing across the gaming platform:

## Test Categories

### 1. Rust Service Tests
Execute `cargo test` in each service directory and report results:
- **hello-world/** - Template service tests
- **game-registry/** - Game management tests (target: 89+ tests)
- **game-engine/** - Tic-tac-toe logic tests (target: 23+ tests)  
- **game-frontend/** - Web interface tests (target: 7+ tests)
- **game-realtime/** - SSE streaming tests (target: 11+ tests)

### 2. k3d Integration Testing
Check deployment health:
- Verify k3d cluster 'clutchrun' is running
- Check my-games namespace exists
- Validate all pods are in Running state
- Count total running pods vs expected

### 3. Documentation Validation
Verify all context files exist and are not empty:
- `.claude/context/current-issue.md`
- `.claude/context/test-requirements.md`
- `.claude/context/friends-integration.md`
- `.claude/context/decision-log.md`
- `README.md`

## Success Criteria
- All Rust tests passing (target: 128+ total tests)
- k3d cluster healthy with all pods running
- All documentation files present and current

Provide detailed results with:
- Total test count across all services
- Specific failures with error details
- Clear next steps for any issues found
- Overall pass/fail status