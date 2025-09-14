#!/bin/bash

# Status Script - Show current development status
# Usage: ./status.sh

echo "📊 My Games Platform - Development Status"
echo "========================================="

# Git Status
echo ""
echo "🔀 Git Status"
echo "-------------"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    CURRENT_BRANCH=$(git branch --show-current)
    echo "Current branch: $CURRENT_BRANCH"
    
    # Check if branch follows naming convention
    if [[ "$CURRENT_BRANCH" != "main" && "$CURRENT_BRANCH" =~ ^issue-[0-9]+-[a-z0-9-]+$ ]]; then
        ISSUE_NUM=$(echo "$CURRENT_BRANCH" | sed 's/issue-\([0-9]*\)-.*/\1/')
        echo "✅ Branch follows naming convention (Issue #$ISSUE_NUM)"
    elif [ "$CURRENT_BRANCH" = "main" ]; then
        echo "📍 On main branch"
    else
        echo "⚠️  Branch doesn't follow issue-###-description convention"
    fi
    
    # Uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        echo "📝 Uncommitted changes:"
        git status --short | sed 's/^/   /'
    else
        echo "✅ Working directory clean"
    fi
    
    # Commits ahead/behind
    if [ "$CURRENT_BRANCH" != "main" ]; then
        COMMITS_AHEAD=$(git rev-list --count main.."$CURRENT_BRANCH" 2>/dev/null || echo "0")
        COMMITS_BEHIND=$(git rev-list --count "$CURRENT_BRANCH"..main 2>/dev/null || echo "0")
        
        if [ "$COMMITS_AHEAD" -gt 0 ]; then
            echo "📈 $COMMITS_AHEAD commits ahead of main"
        fi
        if [ "$COMMITS_BEHIND" -gt 0 ]; then
            echo "📉 $COMMITS_BEHIND commits behind main"
        fi
    fi
else
    echo "❌ Not in a git repository"
fi

# Current Issue Context
echo ""
echo "📋 Current Issue Context"
echo "------------------------"

if [ -f ".claude/context/current-issue.md" ]; then
    # Extract status from current-issue.md
    STATUS=$(grep "^\*\*Status\*\*:" .claude/context/current-issue.md | sed 's/\*\*Status\*\*: //')
    BRANCH_INFO=$(grep "^\*\*Branch\*\*:" .claude/context/current-issue.md | sed 's/\*\*Branch\*\*: //')
    LAST_UPDATE=$(grep "^\*\*Last Updated\*\*:" .claude/context/current-issue.md | sed 's/\*\*Last Updated\*\*: //')
    
    echo "Status: $STATUS"
    echo "Tracked branch: $BRANCH_INFO"
    echo "Last updated: $LAST_UPDATE"
    
    # Show active development section
    if grep -q "## Active Development" .claude/context/current-issue.md; then
        echo ""
        echo "Active work:"
        sed -n '/## Active Development/,/## Next Steps/p' .claude/context/current-issue.md | grep -v "^## " | head -5 | sed 's/^/   /'
    fi
else
    echo "⚠️  Current issue context file not found"
fi

# Test Status
echo ""
echo "🧪 Test Status"
echo "--------------"

# Quick test count from each service
TOTAL_TESTS=0
SERVICES=("hello-world" "game-registry" "game-engine" "game-frontend" "game-realtime")

for SERVICE in "${SERVICES[@]}"; do
    if [ -d "$SERVICE" ]; then
        # Quick check - don't run tests, just count test files
        TEST_FILES=$(find "$SERVICE/src" -name "*.rs" -exec grep -l "#\[test\]" {} \; 2>/dev/null | wc -l)
        if [ "$TEST_FILES" -gt 0 ]; then
            echo "  $SERVICE: $TEST_FILES test files found"
        else
            echo "  $SERVICE: No test files found"
        fi
    fi
done

echo "  💡 Run '/test-all' for comprehensive test execution"

# k3d Cluster Status
echo ""
echo "☸️  k3d Cluster Status"
echo "---------------------"

if command -v k3d >/dev/null 2>&1; then
    CLUSTER_STATUS=$(k3d cluster list | grep "clutchrun" | awk '{print $4}' 2>/dev/null || echo "not-found")
    
    case $CLUSTER_STATUS in
        "running")
            echo "✅ Cluster 'clutchrun' is running"
            
            if command -v kubectl >/dev/null 2>&1; then
                POD_COUNT=$(kubectl get pods -n my-games --no-headers 2>/dev/null | grep "Running" | wc -l || echo "0")
                TOTAL_PODS=$(kubectl get pods -n my-games --no-headers 2>/dev/null | wc -l || echo "0")
                
                if [ "$POD_COUNT" -eq "$TOTAL_PODS" ] && [ "$POD_COUNT" -gt 0 ]; then
                    echo "✅ All $POD_COUNT pods running in my-games namespace"
                elif [ "$TOTAL_PODS" -eq 0 ]; then
                    echo "⚠️  No pods deployed in my-games namespace"
                else
                    echo "⚠️  $POD_COUNT/$TOTAL_PODS pods running"
                fi
            fi
            ;;
        "stopped")
            echo "⏸️  Cluster 'clutchrun' is stopped"
            echo "   Start with: k3d cluster start clutchrun"
            ;;
        "not-found")
            echo "❌ Cluster 'clutchrun' not found"
            echo "   Create with: k3d cluster create clutchrun --agents 3"
            ;;
        *)
            echo "❓ Cluster status unknown: $CLUSTER_STATUS"
            ;;
    esac
else
    echo "⚠️  k3d not installed or not in PATH"
fi

# Available Commands
echo ""
echo "🎯 Available Commands"
echo "--------------------"
echo "  /ready-to-commit  - Full validation before committing"
echo "  /test-all         - Run all tests across services"  
echo "  /new-issue        - Create GitHub issue and branch"
echo "  /merge-friends    - Ask about friends-connect integration"
echo "  /update-docs      - Refresh documentation"
echo "  /status           - Show this status (current command)"

# Friends-Connect Integration Status
echo ""
echo "🤝 Friends-Connect Integration"
echo "------------------------------"

if [ -f ".claude/context/friends-integration.md" ]; then
    # Count pending integrations
    PENDING_COUNT=$(grep -c "⏳ PENDING" .claude/context/friends-integration.md || echo "0")
    INTEGRATED_COUNT=$(grep -c "✅ ALREADY INTEGRATED" .claude/context/friends-integration.md || echo "0")
    
    echo "  ✅ Integrated: $INTEGRATED_COUNT repositories"
    echo "  ⏳ Pending evaluation: $PENDING_COUNT repositories"
    
    if [ "$PENDING_COUNT" -gt 0 ]; then
        echo "  💡 Use '/merge-friends' when connection features are needed"
    fi
else
    echo "  ⚠️  Friends integration context not found"
fi

echo ""
echo "📈 Next Steps"
echo "-------------"
echo "1. Check current work with context files in .claude/context/"
echo "2. Run '/test-all' to validate current state"  
echo "3. Use '/ready-to-commit' before making commits"
echo "4. Create issues with '/new-issue' for new features"

# Update timestamp in current-issue.md
if [ -f ".claude/context/current-issue.md" ]; then
    TIMESTAMP=$(date +"%B %d, %Y at %H:%M")
    sed -i.bak "s/\*\*Last Updated\*\*:.*/\*\*Last Updated\*\*: $TIMESTAMP/" .claude/context/current-issue.md
    rm .claude/context/current-issue.md.bak 2>/dev/null || true
fi

echo ""
echo "🚀 Status check complete!"
