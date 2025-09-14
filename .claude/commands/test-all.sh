#!/bin/bash

# Test All Services Script
# Run comprehensive test suite across all services
# Usage: ./test-all.sh

set -e

echo "🧪 Running comprehensive test suite..."
echo "======================================"

# Initialize counters
TOTAL_TESTS=0
FAILED_SERVICES=()

# Check if we're in the right directory
if [ ! -f "README.md" ] || [ ! -d ".claude" ]; then
    echo "❌ Error: Please run from the my-games repository root"
    exit 1
fi

# Run Rust service tests
echo ""
echo "🦀 Rust Service Tests"
echo "--------------------"

SERVICES=("hello-world" "game-registry" "game-engine" "game-frontend" "game-realtime")

for SERVICE in "${SERVICES[@]}"; do
    if [ -d "$SERVICE" ]; then
        echo "Testing $SERVICE..."
        cd "$SERVICE"
        
        if TEST_OUTPUT=$(cargo test 2>&1); then
            # Extract test count
            TEST_COUNT=$(echo "$TEST_OUTPUT" | grep -o "[0-9]* passed" | head -1 | grep -o "[0-9]*" || echo "0")
            TOTAL_TESTS=$((TOTAL_TESTS + TEST_COUNT))
            echo "  ✅ $SERVICE: $TEST_COUNT tests passed"
        else
            echo "  ❌ $SERVICE: Tests failed"
            echo "     Error output:"
            echo "$TEST_OUTPUT" | sed 's/^/     /'
            FAILED_SERVICES+=("$SERVICE")
        fi
        
        cd ..
    else
        echo "  ⏭️  $SERVICE: Directory not found"
    fi
done

# Frontend-specific tests (if different from Rust tests)
echo ""
echo "🌐 Frontend Integration Tests"
echo "-----------------------------"

if [ -d "game-frontend" ]; then
    cd "game-frontend"
    echo "Running frontend-specific validations..."
    
    # Check for key frontend files
    if [ -f "src/main.rs" ]; then
        echo "  ✅ Frontend service structure verified"
    fi
    
    # Cargo check for compilation
    if cargo check >/dev/null 2>&1; then
        echo "  ✅ Frontend compilation check passed"
    else
        echo "  ❌ Frontend compilation check failed"
        FAILED_SERVICES+=("frontend-compilation")
    fi
    
    cd ..
else
    echo "  ⏭️  game-frontend directory not found"
fi

# k3d Integration Tests
echo ""
echo "☸️  k3d Integration Tests" 
echo "------------------------"

if command -v k3d >/dev/null 2>&1; then
    # Check cluster status
    if k3d cluster list | grep -q "clutchrun.*running"; then
        echo "  ✅ k3d cluster 'clutchrun' is running"
        
        if command -v kubectl >/dev/null 2>&1; then
            # Check namespace
            if kubectl get namespace my-games >/dev/null 2>&1; then
                echo "  ✅ my-games namespace exists"
                
                # Check pod status
                POD_COUNT=$(kubectl get pods -n my-games --no-headers 2>/dev/null | grep "Running" | wc -l)
                TOTAL_PODS=$(kubectl get pods -n my-games --no-headers 2>/dev/null | wc -l)
                
                if [ "$POD_COUNT" -eq "$TOTAL_PODS" ] && [ "$POD_COUNT" -gt 0 ]; then
                    echo "  ✅ All $POD_COUNT pods are running"
                elif [ "$TOTAL_PODS" -eq 0 ]; then
                    echo "  ⚠️  No pods found in my-games namespace"
                    echo "     Run: kubectl apply -k apps/base/"
                else
                    echo "  ⚠️  $POD_COUNT/$TOTAL_PODS pods running"
                    echo "     Some pods may be starting or failed"
                fi
            else
                echo "  ❌ my-games namespace not found"
                FAILED_SERVICES+=("k8s-namespace")
            fi
        else
            echo "  ⚠️  kubectl not available - skipping pod checks"
        fi
    else
        echo "  ❌ k3d cluster 'clutchrun' not running"
        echo "     Start with: k3d cluster start clutchrun"
        FAILED_SERVICES+=("k3d-cluster")
    fi
else
    echo "  ⚠️  k3d not available - skipping cluster tests"
fi

# Documentation Tests
echo ""
echo "📚 Documentation Tests"
echo "----------------------"

DOC_FILES=(
    "README.md"
    ".claude/README.md" 
    ".claude/context/current-issue.md"
    ".claude/context/test-requirements.md"
    ".claude/context/friends-integration.md"
    ".claude/context/decision-log.md"
)

DOC_PASSED=0
for DOC_FILE in "${DOC_FILES[@]}"; do
    if [ -f "$DOC_FILE" ]; then
        # Basic validation - file exists and is not empty
        if [ -s "$DOC_FILE" ]; then
            echo "  ✅ $DOC_FILE ($(wc -l < "$DOC_FILE") lines)"
            DOC_PASSED=$((DOC_PASSED + 1))
        else
            echo "  ❌ $DOC_FILE (empty file)"
            FAILED_SERVICES+=("docs-$DOC_FILE")
        fi
    else
        echo "  ❌ $DOC_FILE (missing)"
        FAILED_SERVICES+=("docs-$DOC_FILE")
    fi
done

echo "  📊 Documentation: $DOC_PASSED/${#DOC_FILES[@]} files validated"

# Final Summary
echo ""
echo "📊 Test Summary"
echo "==============="

echo "🦀 Rust tests passed: $TOTAL_TESTS"
echo "📚 Documentation files: $DOC_PASSED/${#DOC_FILES[@]}"

if [ ${#FAILED_SERVICES[@]} -eq 0 ]; then
    echo ""
    echo "🎉 All tests passed!"
    echo "✅ Ready for development or commit"
    exit 0
else
    echo ""
    echo "❌ Failed services/checks:"
    for FAILED in "${FAILED_SERVICES[@]}"; do
        echo "   - $FAILED"
    done
    echo ""
    echo "💡 Fix the above issues before committing"
    exit 1
fi
