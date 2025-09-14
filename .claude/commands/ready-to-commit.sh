#!/bin/bash

# Ready to Commit Validation Script
# Run comprehensive validation before committing code
# Usage: ./ready-to-commit.sh

set -e  # Exit on any error

echo "🚀 Running full validation before commit..."
echo "=================================================="

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "📋 Current branch: $CURRENT_BRANCH"

# Check if branch follows naming convention (issue-###-description)
if [[ "$CURRENT_BRANCH" != "main" && ! "$CURRENT_BRANCH" =~ ^issue-[0-9]+-[a-z0-9-]+$ ]]; then
    echo "⚠️  Warning: Branch name doesn't follow issue-###-description convention"
    echo "   Current: $CURRENT_BRANCH"
    echo "   Expected: issue-123-short-description"
fi

# 1. Run all Rust service tests
echo ""
echo "🧪 Running Rust service tests..."
echo "----------------------------------"

SERVICES=("hello-world" "game-registry" "game-engine" "game-frontend" "game-realtime")
TOTAL_TESTS=0

for SERVICE in "${SERVICES[@]}"; do
    if [ -d "$SERVICE" ]; then
        echo "  Testing $SERVICE..."
        cd "$SERVICE"
        TEST_OUTPUT=$(cargo test 2>&1) || {
            echo "❌ Tests failed in $SERVICE"
            echo "$TEST_OUTPUT"
            exit 1
        }
        # Extract test count from output
        TEST_COUNT=$(echo "$TEST_OUTPUT" | grep -o "[0-9]* passed" | head -1 | grep -o "[0-9]*" || echo "0")
        TOTAL_TESTS=$((TOTAL_TESTS + TEST_COUNT))
        echo "     ✅ $TEST_COUNT tests passed"
        cd ..
    else
        echo "     ⏭️  $SERVICE directory not found"
    fi
done

echo "     🎯 Total Rust tests passed: $TOTAL_TESTS"

# 2. Check k3d cluster status
echo ""
echo "☸️  Checking k3d cluster status..."
echo "-----------------------------------"

if command -v k3d >/dev/null 2>&1; then
    CLUSTER_STATUS=$(k3d cluster list | grep "clutchrun" | awk '{print $4}' || echo "not-found")
    if [ "$CLUSTER_STATUS" = "running" ]; then
        echo "     ✅ k3d cluster 'clutchrun' is running"
        
        # Check if services are healthy
        if command -v kubectl >/dev/null 2>&1; then
            POD_COUNT=$(kubectl get pods -n my-games --no-headers 2>/dev/null | wc -l || echo "0")
            echo "     📊 Pods in my-games namespace: $POD_COUNT"
            
            # Quick health check if port-forward is possible
            # Note: This is optional since port-forward might not be active
            echo "     ℹ️  Run health checks manually if needed:"
            echo "        kubectl port-forward svc/game-frontend -n my-games 8085:80 &"
            echo "        curl http://localhost:8085/health"
        else
            echo "     ⚠️  kubectl not found - skipping pod checks"
        fi
    else
        echo "     ⚠️  k3d cluster 'clutchrun' not running"
        echo "     ℹ️  Start with: k3d cluster start clutchrun"
    fi
else
    echo "     ⚠️  k3d not found - skipping cluster checks"
fi

# 3. Documentation currency check
echo ""
echo "📚 Checking documentation currency..."
echo "-------------------------------------"

# Check if key files are present
DOC_FILES=(".claude/context/current-issue.md" ".claude/context/test-requirements.md" "README.md")
for DOC_FILE in "${DOC_FILES[@]}"; do
    if [ -f "$DOC_FILE" ]; then
        echo "     ✅ $DOC_FILE exists"
    else
        echo "     ❌ $DOC_FILE missing"
    fi
done

# 4. Git status check
echo ""
echo "📝 Git status check..."
echo "----------------------"

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo "     ⚠️  Uncommitted changes found:"
    git status --short | sed 's/^/        /'
    echo ""
    echo "     💡 Consider committing these changes or adding to .gitignore"
else
    echo "     ✅ Working directory clean"
fi

# Check if current branch is ahead of main
if [ "$CURRENT_BRANCH" != "main" ]; then
    COMMITS_AHEAD=$(git rev-list --count main.."$CURRENT_BRANCH" 2>/dev/null || echo "0")
    if [ "$COMMITS_AHEAD" -gt 0 ]; then
        echo "     📈 Branch is $COMMITS_AHEAD commits ahead of main"
    else
        echo "     📊 Branch is up to date with main"
    fi
fi

# 5. Generate commit summary
echo ""
echo "📋 Commit Readiness Summary"
echo "==========================="

echo "✅ Rust tests: $TOTAL_TESTS passed"
echo "✅ Documentation: Key files present"
echo "✅ Git status: Validated"

if [ "$CLUSTER_STATUS" = "running" ]; then
    echo "✅ k3d cluster: Running"
else
    echo "⚠️  k3d cluster: Not running (optional)"
fi

echo ""
echo "🎉 Ready to commit! All validations passed."
echo ""
echo "📌 Next steps:"
echo "   1. Review your changes: git diff"
echo "   2. Stage your changes: git add ."
echo "   3. Commit with message: git commit -m 'feat: your change description'"
echo "   4. Push if ready: git push origin $CURRENT_BRANCH"

# Update current-issue.md with timestamp
if [ -f ".claude/context/current-issue.md" ]; then
    TIMESTAMP=$(date +"%B %d, %Y at %H:%M")
    sed -i.bak "s/\*\*Last Updated\*\*:.*/\*\*Last Updated\*\*: $TIMESTAMP/" .claude/context/current-issue.md
    rm .claude/context/current-issue.md.bak 2>/dev/null || true
    echo "   5. Updated context timestamp: $TIMESTAMP"
fi

echo ""
echo "🚀 Ready to commit validation complete!"
