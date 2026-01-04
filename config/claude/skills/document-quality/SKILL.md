---
name: document-quality
description: Automatically review documents against checklists and best practices. Use when creating or reviewing ADRs, Design Docs, meeting notes, technical proposals, or RFCs. Detects anti-patterns, vague expressions, and missing elements.
allowed-tools: Read, Grep
model: inherit
---

# Document Quality Checker

Automatically review technical documents based on best practices and quality checklists.

## Quick Start

This skill automatically activates when you create or update:
- ADR (Architecture Decision Record)
- Design Document
- Meeting notes or prep sheets
- Technical proposals or RFCs

No external files needed - all checks are built-in.

## Supported Document Types

### ADR (Architecture Decision Record)
**Detection**: Filename contains "ADR" or has ADR structure
**Required sections**: Context, Decision, Alternatives, Rationale, Consequences

### Design Doc
**Detection**: Filename contains "design-doc" or has Design Doc structure
**Required sections**: Overview, Background, Goals, Design, Alternatives, Plan

### Meeting Notes/Preparation
**Detection**: Contains meeting agenda or decision materials
**Required sections**: Purpose, Participants, Decision materials, Options

### Technical Proposals/RFCs
**Detection**: Contains proposal or RFC structure
**Focus**: Problem definition, Trade-off analysis, Concrete examples

## Review Process

### Step 1: Detect Document Type

Identify from:
- Filename patterns (ADR-, design-doc-, meeting-, RFC-)
- Document structure (headings)
- Content markers

### Step 2: Structural Check

Verify all required sections exist based on type.

#### ADR Required Sections
- [ ] Title with decision name
- [ ] Date and status
- [ ] Context (background and problem)
- [ ] Decision statement
- [ ] Alternatives considered (minimum 2)
- [ ] Decision rationale
- [ ] Consequences (positive AND negative)
- [ ] Related decisions/references

#### Design Doc Required Sections
- [ ] Header (author, date, reviewers, status)
- [ ] Overview (concise summary)
- [ ] Background and motivation
- [ ] Goals and non-goals (explicit)
- [ ] Detailed design with diagrams
- [ ] Alternatives considered
- [ ] Implementation plan
- [ ] Testing strategy
- [ ] Rollout/deployment plan

#### Meeting Prep Required Sections
- [ ] Meeting purpose (decision/consultation/sharing)
- [ ] Participants list
- [ ] Background and problem
- [ ] Options with pros/cons
- [ ] Recommendation with rationale

### Step 3: Anti-pattern Detection

See [ANTI_PATTERNS.md](ANTI_PATTERNS.md) for full catalog.

#### Common Anti-patterns

**1. 思考停止ワード (Vague Expressions)**

❌ Detected phrases:
- "適切に", "柔軟に", "効率的に" (appropriately, flexibly, efficiently)
- "必要に応じて" (as needed)
- "基本的に", "なるべく" (basically, preferably)
- "バランスが大事" (balance is important)

✅ Fix: Replace with specific criteria

```
❌ "データベースを適切に選択"
✅ "トラフィック1000req/s以下ならPostgreSQL、超える場合Cassandra"

❌ "パフォーマンスを改善"
✅ "レスポンスタイム500ms→200ms以下に改善"

❌ "必要に応じてスケール"
✅ "CPU使用率80%を5分間超えたら自動スケール"
```

**2. Missing Context**

❌ Problem: Document jumps to solution without explaining why

✅ Fix: Add background section explaining:
- Current situation
- Problem to solve
- Why this decision is needed

**3. Missing Trade-offs**

❌ Problem: Only positive aspects mentioned

✅ Fix: Add comparison table:

| Criterion | Option A | Option B | Option C |
|-----------|----------|----------|----------|
| Performance | 8/10 | 6/10 | 9/10 |
| Maintainability | 6/10 | 9/10 | 5/10 |
| Cost | Medium | High | Low |

**4. No Concrete Examples**

❌ Problem: Abstract descriptions only

✅ Fix: Add concrete examples:
- Code snippets
- API examples
- Sample data
- Use cases

**5. Vague Goals**

❌ "Improve system performance"
✅ "Reduce P95 latency from 500ms to <200ms"

❌ "Enhance security"
✅ "Implement TLS 1.3, AES-256 encryption, 90-day cert rotation"

### Step 4: Content Quality Check

#### Clarity
- Can a new team member understand this?
- Is jargon explained?
- Are assumptions stated?

#### Specificity
- Are statements measurable?
- Are thresholds/numbers provided?
- Are edge cases considered?

#### Completeness
- Are all necessary details included?
- Are open questions identified?
- Are next steps clear?

#### Balance
- Are both pros and cons documented?
- Are risks identified?
- Are limitations acknowledged?

### Step 5: Generate Feedback

**Output format**:

```markdown
## Document Quality Review

**Document Type**: [ADR/Design Doc/Meeting Prep/etc.]
**Overall Assessment**: [Excellent/Good/Needs Improvement/Critical Issues]

### Summary
[2-3 sentence assessment]

### Critical Issues (Must Fix)

1. **Missing Section: Alternatives**
   - Location: Entire document
   - Problem: No alternatives considered
   - Impact: Cannot verify this is the best option
   - Fix: Add section with at least 2 alternatives and trade-off analysis

2. **Vague Expression: Line 45**
   - Detected: "セキュリティを適切に設定"
   - Problem: No specific criteria
   - Fix: "TLS 1.3、AES-256暗号化、証明書90日ローテーション"

### Suggestions (Should Consider)

1. **Add Concrete Metrics**
   - Current: "Improve performance"
   - Suggestion: "Reduce P95 latency to <200ms (currently 500ms)"

2. **Include Diagrams**
   - Add architecture diagram (Mermaid recommended)
   - Add sequence diagram for complex flows

### Positive Aspects

- Clear decision rationale
- Well-structured trade-off analysis
- Concrete examples provided

### Checklist Results

ADR Completeness: 7/8 sections ✅
- ✅ Context
- ✅ Decision
- ✅ Alternatives
- ✅ Rationale
- ❌ Negative consequences (missing)
- ✅ Related decisions
```

## Built-in Checklists

### Document Creation Checklist

Before publishing any technical document:

- [ ] **Purpose is clear**: Can state objective in one sentence
- [ ] **Audience identified**: Know who will read this and their level
- [ ] **Structure is logical**: Follows established template
- [ ] **Context provided**: Background explains why this matters
- [ ] **Concrete examples**: At least 2-3 specific examples
- [ ] **No vague expressions**: Checked for 思考停止ワード
- [ ] **Trade-offs documented**: Pros and cons explicitly listed
- [ ] **Metrics are measurable**: Numbers, thresholds, or criteria provided
- [ ] **Next steps clear**: Action items or follow-ups identified

### Vague Expression Checklist

Check for these patterns and replace with specifics:

| Vague Expression | Specific Alternative |
|-----------------|---------------------|
| "適切に実装" | "TDD with 80%+ coverage, code review required" |
| "柔軟に対応" | "Support JSON and XML formats, add YAML in Q2" |
| "効率的に処理" | "Process <1000ms for 95% of requests" |
| "必要に応じて" | "When CPU >80% for 5min, auto-scale" |
| "基本的には" | "Always X, except for Y (documented in ADR-123)" |
| "なるべく" | "Target: 99%, minimum: 95%" |
| "バランスが大事" | "Prioritize speed (2mo), accept tech debt, refactor in Q3" |

### ADR Specific Checklist

- [ ] **Decision is stated clearly**: One sentence summary
- [ ] **Minimum 2 alternatives**: With pros/cons for each
- [ ] **Trade-off table**: Quantitative comparison
- [ ] **Rationale is specific**: Not just "better" or "recommended"
- [ ] **Negative consequences**: Explicitly documented
- [ ] **Migration plan**: If replacing existing system
- [ ] **Review date**: When to revisit this decision

### Design Doc Specific Checklist

- [ ] **3-sentence overview**: Captures essence of design
- [ ] **Goals AND non-goals**: Explicit scope boundaries
- [ ] **Success metrics**: Measurable (latency, throughput, etc.)
- [ ] **Architecture diagram**: Visual representation
- [ ] **API examples**: Concrete request/response
- [ ] **Alternative designs**: At least 1 other approach considered
- [ ] **Security reviewed**: Authentication, authorization, encryption
- [ ] **Testing strategy**: Unit, integration, e2e plans
- [ ] **Rollout plan**: Phased deployment with rollback

## Anti-pattern Detection Examples

### Example 1: Vague Adverb

**Input**: "パフォーマンスを適切に改善する"

**Detection**: "適切に" (vague adverb)

**Feedback**:
```
❌ Detected: 思考停止ワード "適切に"
   Location: Line 23
   Problem: No specific criteria for "appropriate"

✅ Fix: "レスポンスタイムを200ms以下に改善（現在500ms）"
```

### Example 2: Missing Trade-offs

**Input**: ADR with only chosen option, no alternatives

**Detection**: No "Alternatives" section

**Feedback**:
```
❌ Critical Issue: Missing Alternatives Analysis
   Location: Entire document
   Problem: No alternatives considered. Cannot verify best option.
   Impact: Future readers won't understand why other options rejected.

✅ Fix: Add "Alternatives Considered" section:
   | Option | Pros | Cons | Cost |
   |--------|------|------|------|
   | PostgreSQL (chosen) | ACID, team expertise | Higher ops cost | $1500/mo |
   | MongoDB | Simple ops, flexible schema | No ACID | $1000/mo |
```

### Example 3: Vague Goals

**Input**: "システムの性能を向上させる"

**Detection**: No metrics

**Feedback**:
```
❌ Vague Goal Detected
   Current: "システムの性能を向上させる"
   Problem: Not measurable

✅ Fix: "以下の性能目標を達成:
   - P95レイテンシ: 500ms → 200ms以下
   - スループット: 2000 req/s → 5000 req/s
   - エラー率: 0.5% → 0.1%以下"
```

## Integration

Works alongside:
- `doc-templates`: Reviews generated templates
- `tech-doc-reviewer`: Provides initial quick check
- `principle-guide`: Validates decision-making process

## Activation

Automatically activates when:
- Creating/editing files matching patterns (ADR-, design-doc-, etc.)
- Document structure matches known types
- User requests "review document quality"

## Limitations

- Pattern-based detection (not semantic analysis)
- Japanese 思考停止ワード focus
- Requires documents to follow common structures

## Getting Help

For detailed anti-pattern catalog: [ANTI_PATTERNS.md](ANTI_PATTERNS.md)

For templates: Use `doc-templates` skill

For detailed review: `tech-doc-reviewer` agent provides deeper analysis
