# Claude Code Workflow Configuration

This directory contains the context engineering and workflow automation for the My Games Platform development using Claude Code.

## Slash Commands Available

### Core Development Commands
- `/new-issue` - Create GitHub issue and feature branch
- `/ready-to-commit` - Full validation before commit (tests + docs + git status)
- `/test-all` - Run complete test suite (cargo + frontend + k3d)
- `/merge-friends` - Ask about integrating friends-connect patterns
- `/update-docs` - Refresh README + decision log + context files
- `/status` - Current branch, test status, uncommitted changes

### Context Management
- `/context` - View current issue and development context
- `/requirements` - Review current requirements and user stories
- `/decisions` - View architectural decision log

## Workflow Philosophy

1. **Small Steps with Tests**: Every change must be tested and verified
2. **Documentation First**: README, decisions, and context always current
3. **Issue-Driven Development**: All work tied to GitHub issues
4. **Git Discipline**: Feature branches, clean commits, no broken builds
5. **Resource Integration**: Ask before merging patterns from friends-connect repos

## Directory Structure

```
.claude/
├── context/           # Active development context
├── commands/          # Executable workflow scripts
├── templates/         # Issue and branch templates
└── resources/         # Cached info from other repos
```

## Testing Strategy

The `/ready-to-commit` command runs:
1. All Rust service tests (`cargo test`)
2. Frontend validation tests
3. k3d cluster integration tests
4. Documentation currency check
5. Git status validation
6. Generate commit summary

## Resource Repositories

Available for pattern integration (ask first):
- [clutch-deployments](https://github.com/randallard/clutch-deployments) - k3d deployment patterns
- [clutch](https://github.com/randallard/clutch) - Microservices architecture
- [friends-connect](https://github.com/randallard/friends-connect) - Connection strategies
- [hello-friends-connect](https://github.com/randallard/hello-friends-connect) - Hello world patterns
- [sandbox-friends-connect](https://github.com/randallard/sandbox-friends-connect) - Experimental patterns
