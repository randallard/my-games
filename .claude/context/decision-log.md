# Architectural Decision Log

## Decision Framework

All significant technical decisions are logged here with:
- **Context**: What circumstances led to this decision
- **Options Considered**: Alternative approaches evaluated  
- **Decision**: What we chose and why
- **Consequences**: Expected outcomes and trade-offs
- **Status**: Active, Deprecated, or Superseded

---

## Decision Record Template

### ADR-XXX: [Title]
**Date**: YYYY-MM-DD  
**Status**: [Proposed | Active | Deprecated | Superseded]
**Context**: [Background and circumstances]
**Options Considered**: 
- Option A: [description]
- Option B: [description]  
**Decision**: [What was decided]
**Rationale**: [Why this was chosen]
**Consequences**: [Positive and negative outcomes]

---

## Active Decisions

### ADR-001: Claude Code Workflow with GitHub Issues
**Date**: 2024-09-14  
**Status**: Active
**Context**: Need disciplined development workflow with testing gates and documentation maintenance
**Options Considered**:
- Desktop Commander continuation: Continue current flow but lacks Git integration
- Pre-commit hooks: Automated but Claude Code can't see/fix failures  
- Claude Code-first: Manual but integrated testing and documentation
**Decision**: Claude Code `/ready-to-commit` command with full validation
**Rationale**: 
- Enables Claude Code to see test failures and fix issues
- Maintains comprehensive testing requirements
- Keeps documentation current automatically
- Integrates naturally with GitHub Issues workflow
**Consequences**: 
- ✅ Better integration between development tools
- ✅ Automated documentation maintenance  
- ✅ Comprehensive pre-commit validation
- ❌ Requires discipline to use `/ready-to-commit` before every commit

### ADR-002: GitHub Issues + Feature Branch Workflow
**Date**: 2024-09-14
**Status**: Active  
**Context**: Need structured approach to feature development with clear tracking
**Options Considered**:
- GitFlow: Complex with develop branch
- Trunk-based: Simple but less isolation
- GitHub Issues + feature branches: Moderate complexity, good tracking
**Decision**: GitHub Issues linked to feature branches (issue-123-description)
**Rationale**:
- Clear traceability between issues and code
- Good isolation for experimental work
- Integrates well with GitHub's issue management
- Matches team's preference for structured workflow
**Consequences**:
- ✅ Clear development tracking and history
- ✅ Safe experimentation in feature branches
- ✅ Good integration with project management  
- ❌ Requires discipline to create issues before features

### ADR-003: Ask-First Friends-Connect Integration
**Date**: 2024-09-14
**Status**: Active
**Context**: Multiple connection strategy repositories available but integration decisions needed
**Options Considered**:
- Automatic integration: Claude Code decides when to use patterns
- No integration: Keep current simple approach
- Ask-first integration: Claude Code asks before merging patterns
**Decision**: Ask-first integration with `/merge-friends` command
**Rationale**:
- Preserves user control over architectural decisions
- Prevents unwanted complexity introduction
- Enables informed decision-making about trade-offs
- Maintains current working system while enabling evolution
**Consequences**:
- ✅ User stays in control of architectural evolution
- ✅ Prevents accidental complexity increase
- ✅ Enables learning and discussion of options
- ❌ Requires more interaction for connection feature development

---

## Historical Context

This decision log was created as part of transitioning from Desktop Commander to Claude Code workflow. Previous architectural decisions are documented in the `context/` directory files:

- **Technical Decisions**: `context/04-technical-decisions.md`
- **Architecture Overview**: `context/02-microservices-architecture.md`  
- **Jeremy Chone Patterns**: `JEREMY_CHONE_BEST_PRACTICES.md`

---

*Updated by `/decisions` and `/ready-to-commit` commands*
