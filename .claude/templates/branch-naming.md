# Branch Naming Conventions

## Standard Format
`issue-{number}-{short-description}`

## Examples
- `issue-123-add-realtime-events`
- `issue-45-fix-sse-proxy-cors`  
- `issue-67-integrate-friends-connect`
- `issue-89-update-documentation`
- `issue-12-refactor-game-engine`

## Guidelines

### Issue Number
- Always start with the GitHub issue number
- Use the actual issue number from GitHub Issues
- Zero-pad if you prefer: `issue-001-feature` (optional)

### Short Description
- Keep it concise (2-4 words typically)
- Use kebab-case (lowercase with hyphens)
- Focus on the main action or feature
- Avoid special characters except hyphens

### Good Examples
- `issue-156-add-websocket-support`
- `issue-23-fix-cluster-startup`
- `issue-78-friends-discovery-api`
- `issue-45-update-readme`

### Bad Examples
- `feature-websockets` (no issue number)
- `issue-156-add_websocket_support` (underscores instead of hyphens)
- `issue-156-AddWebSocketSupport` (CamelCase)
- `issue-156-add-websocket-support-for-realtime-gaming-with-better-performance` (too long)

## Special Branch Types

### Main Development
- `main` - Primary branch for stable code

### Hotfixes (if needed)
- `hotfix-{issue-number}-{description}`
- Example: `hotfix-123-security-patch`

### Documentation Only
- Can still use issue format: `issue-45-update-docs`
- Or specific format: `docs-{description}`

### Experimental/Spike Work
- `spike-{description}` - For exploratory work
- Example: `spike-p2p-connection-test`
- Should eventually become proper issues

## Validation
The `/ready-to-commit` script checks branch naming and will warn if the branch doesn't follow the `issue-{number}-{description}` pattern (except for `main`).

## Workflow
1. Create GitHub issue first
2. Note the issue number (e.g., #156)
3. Create branch: `git checkout -b issue-156-add-websocket-support`
4. Work on the feature
5. Use `/ready-to-commit` to validate before pushing
6. Create pull request referencing the issue

## Automation Benefits
- Clear traceability between branches and issues
- Easy filtering and searching  
- Automated tooling can parse branch names
- GitHub automatically links PRs to issues when branch names reference issue numbers
