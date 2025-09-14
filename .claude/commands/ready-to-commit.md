---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(cargo test:*), Bash(kubectl:*), Bash(k3d:*)
description: Full validation before committing code
---

Before I commit, validate my code by running comprehensive checks:

## Context
- Current git status: !`git status`
- Current git diff (staged and unstaged): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -5`

## Validation Steps

### 1. Git Branch Validation
- Verify branch follows `issue-###-description` naming convention (except main)
- Check for uncommitted changes
- Validate current branch status vs main

### 2. Rust Service Testing
Execute `cargo test` in each service directory:
- hello-world/
- game-registry/
- game-engine/
- game-frontend/
- game-realtime/

**Requirements**: All tests must pass, target 128+ total tests

### 3. k3d Cluster Health Check
- Verify k3d cluster 'clutchrun' is running
- Check my-games namespace exists
- Validate all pods are in Running state
- Report pod count and health status

### 4. Documentation Currency
Verify these files exist and are current:
- .claude/context/current-issue.md
- .claude/context/test-requirements.md
- .claude/context/friends-integration.md
- .claude/context/decision-log.md
- README.md

### 5. Commit Readiness Summary
Only if ALL validations pass, provide:
- ✅ Total tests passed count
- ✅ k3d cluster status
- ✅ Documentation validation
- ✅ Git status summary
- 📋 **Next steps for committing**

If ANY validation fails:
- ❌ List specific failures
- 🔧 Provide exact commands to fix issues
- ⏸️ Block commit recommendation until fixed

Update timestamp in .claude/context/current-issue.md when complete.