---
argument-hint: [feature description]
description: Evaluate friends-connect integration options for connection features
---

Based on .claude/context/friends-integration.md, I need connection features for: $ARGUMENTS

## Analysis Steps

### 1. Review Available Resources
Examine the friends-connect repositories listed in .claude/context/friends-integration.md:
- **friends-connect** - Primary connection strategies  
- **hello-friends-connect** - Hello world connection patterns
- **sandbox-friends-connect** - Experimental connection patterns

### 2. Current Platform Assessment
Consider our existing real-time architecture:
- Server-Sent Events (SSE) with proxy architecture
- k3d microservices deployment
- 5 production services with Jeremy Chone patterns
- Manual shareable links for friend-to-friend gaming

### 3. Integration Decision Framework
For the requested feature "$ARGUMENTS", analyze:

**Connection Need Analysis:**
- What specific connection capability is required?
- How does this extend beyond current SSE/shareable link approach?
- What are the performance and complexity implications?

**Pattern Evaluation:**
- Which friends-connect repository contains relevant patterns?
- What are 2-3 specific implementation approaches?
- What are the trade-offs of each approach?

**Integration Recommendation:**
Present options as:
1. **Option A**: [Specific pattern] from [repository]
   - **Benefits**: [clear advantages]
   - **Trade-offs**: [complexity/limitations]
   - **Effort**: [small/medium/large]

2. **Option B**: [Alternative approach]
   - **Benefits**: [clear advantages] 
   - **Trade-offs**: [complexity/limitations]
   - **Effort**: [small/medium/large]

3. **Option C**: [Third option or "keep current approach"]
   - **Benefits**: [clear advantages]
   - **Trade-offs**: [complexity/limitations]
   - **Effort**: [small/medium/large]

### 4. Next Steps Decision
Ask me:
- "Which option do you prefer and why?"
- "Should this become a GitHub issue for structured implementation?"
- "Are there any specific constraints or requirements I should consider?"

**Important**: Don't implement anything yet - this is a decision-making conversation to evaluate options before committing to an approach.