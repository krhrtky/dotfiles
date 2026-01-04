---
description: Generate ADR (Architecture Decision Record) from built-in template
argument-hint: [decision-title]
---

Create an Architecture Decision Record for: $ARGUMENTS

Use the built-in ADR template:

# ADR-XXX: [Decision Title]

**Date**: YYYY-MM-DD
**Status**: Proposed / Accepted / Rejected / Superseded
**Deciders**: [List of people involved in decision]

## Context

### Background
[Why is this decision necessary?]
[What is the current situation?]

### Problem Statement
[What specific problem needs to be solved?]
[What are the requirements?]

## Decision

[What was decided? State in 1-2 clear sentences]

## Considered Alternatives

### Option A: [Name]

**Pros**:
- [Specific advantage with evidence/metrics]
- [Specific advantage with evidence/metrics]

**Cons**:
- [Specific disadvantage with impact]
- [Specific disadvantage with impact]

**Cost**: [Initial + Ongoing costs]
**Timeline**: [Implementation time]

### Option B: [Name]

**Pros**:
- [Specific advantage]
- [Specific advantage]

**Cons**:
- [Specific disadvantage]
- [Specific disadvantage]

**Cost**: [Initial + Ongoing costs]
**Timeline**: [Implementation time]

### Option C: [Name]

[Same structure as above]

## Decision Rationale

[Why was this option chosen over alternatives?]

**Key factors**:
1. [Factor with specific reasoning]
2. [Factor with specific reasoning]
3. [Factor with specific reasoning]

**Trade-offs accepted**:
- [What we're giving up and why it's acceptable]

## Consequences

### Positive
- [Specific positive impact]
- [Specific positive impact]

### Negative
- [Specific negative impact and mitigation plan]
- [Specific negative impact and mitigation plan]

### Neutral
- [Changes that are neither clearly positive nor negative]

## Implementation Notes

[How will this decision be implemented?]
[Any migration plan needed?]

## Related Decisions

- ADR-XXX: [Related decision]
- [Links to related documentation]

## Review Date

[When should this decision be revisited?]

---

## ADR Quality Checklist

Before finalizing:
- [ ] All alternatives are documented with pros/cons
- [ ] Decision rationale is specific and evidence-based
- [ ] Both positive and negative consequences are listed
- [ ] No vague expressions (避ける: "適切に", "柔軟に", "効率的に")
- [ ] Concrete metrics or examples are provided
- [ ] Related decisions are linked
- [ ] Trade-offs are explicitly stated
- [ ] Migration plan is included (if applicable)

**Important**: Avoid 思考停止ワード
- ❌ "適切に設定する"
- ✅ "TLS 1.3、AES-256暗号化、証明書90日ローテーション"

- ❌ "必要に応じてスケール"
- ✅ "CPU 80%を5分間超えたら自動スケール"
