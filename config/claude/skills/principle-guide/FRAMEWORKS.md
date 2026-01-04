# Decision-Making Frameworks and Templates

Practical frameworks and templates for systematic decision-making.

Reference: docs/guides/decision-making.md

## 1. Trade-off Analysis Template

Use this template to systematically compare alternatives.

### Basic Template

```markdown
## Trade-off Analysis

| Criterion | Weight | Option A | Option B | Option C | Notes |
|-----------|--------|----------|----------|----------|-------|
| Performance | High | 8/10 | 6/10 | 9/10 | Option C fastest but... |
| Maintainability | High | 6/10 | 9/10 | 5/10 | Option B most readable |
| Cost | Medium | 7/10 | 5/10 | 6/10 | Initial + ongoing |
| Time to market | High | 9/10 | 7/10 | 4/10 | Option A quickest |
| Risk | Medium | 6/10 | 8/10 | 5/10 | Option B lowest risk |

### Weighted Score Calculation

Weight values: High = 3, Medium = 2, Low = 1

**Option A**: (8×3 + 6×3 + 7×2 + 9×3 + 6×2) / (3+3+2+3+2) = 97/13 = 7.5
**Option B**: (6×3 + 9×3 + 5×2 + 7×3 + 8×2) / (3+3+2+3+2) = 87/13 = 6.7
**Option C**: (9×3 + 5×3 + 6×2 + 4×3 + 5×2) / (3+3+2+3+2) = 76/13 = 5.8

**Winner**: Option A (7.5) - Best overall balance given our priorities
```

### Detailed Template with Rationale

```markdown
## Detailed Trade-off Analysis

### Criterion 1: Performance

**Weight**: High (3)
**Why Important**: Customer SLA requires P95 latency < 200ms

| Option | Score | Rationale |
|--------|-------|-----------|
| PostgreSQL | 8/10 | 50ms P95 latency at 10K writes/sec. Exceeds requirements with margin. |
| MongoDB | 6/10 | 100ms P95 latency. Meets requirements but no margin. |
| DynamoDB | 9/10 | 20ms P95 latency. Best performance but vendor lock-in concern. |

### Criterion 2: Maintainability

**Weight**: High (3)
**Why Important**: Team of 5 must maintain without DBA

| Option | Score | Rationale |
|--------|-------|-----------|
| PostgreSQL | 6/10 | Complex tuning needed. Mature but requires expertise. |
| MongoDB | 9/10 | Simple operations, good tooling, team familiar. |
| DynamoDB | 5/10 | AWS-specific knowledge. Limited local dev experience. |

[Continue for all criteria...]
```

## 2. Decision Matrix Framework

For complex decisions with many stakeholders and criteria.

### Step 1: List All Criteria

```markdown
## Decision Criteria

### Must-Have (Eliminatory)
- [ ] ACID compliance (required for financial data)
- [ ] Horizontal scalability to 100K req/s
- [ ] Data residency in EU (GDPR)

### Important (Weighted)
- Performance (weight: 3)
- Maintainability (weight: 3)
- Cost (weight: 2)
- Team expertise (weight: 2)

### Nice-to-Have (Bonus)
- Built-in caching
- GraphQL support
- Cloud-agnostic
```

### Step 2: Eliminate Options

```markdown
## Must-Have Check

| Option | ACID | Scalability | EU Residency | Pass? |
|--------|------|-------------|--------------|-------|
| PostgreSQL | ✅ | ✅ (with sharding) | ✅ | ✅ |
| MongoDB | ❌ (eventual consistency) | ✅ | ✅ | ❌ Eliminated |
| DynamoDB | ✅ | ✅ | ✅ (eu-west-1) | ✅ |
| MySQL | ✅ | ⚠️ (limited) | ✅ | ⚠️ Borderline |

**Remaining Options**: PostgreSQL, DynamoDB
```

### Step 3: Score Remaining Options

Apply trade-off analysis to remaining options.

## 3. Build vs Buy Framework

Specific framework for build vs buy decisions.

### Decision Tree

```
Start
  ↓
Is this core competency?
  ├─ YES → Lean toward Build
  │   ↓
  │   Is there time/budget?
  │   ├─ YES → Build
  │   └─ NO → Buy with plan to replace
  │
  └─ NO → Lean toward Buy
      ↓
      Is suitable solution available?
      ├─ YES → Buy
      └─ NO → Build minimal version
```

### Evaluation Template

```markdown
## Build vs Buy Analysis

### Core Competency Check
- [ ] This is unique to our business
- [ ] This provides competitive advantage
- [ ] We have deep expertise in this area
- [ ] We can maintain this long-term

**Score**: 1/4 → **Not core competency** → Lean toward Buy

### Available Solutions

| Solution | Pros | Cons | Cost | Score |
|----------|------|------|------|-------|
| Auth0 | Proven security, low maintenance | Vendor lock-in, limited customization | $200/mo | 8/10 |
| AWS Cognito | AWS integration, cheap | Limited features, AWS lock-in | $50/mo | 6/10 |
| Build Custom | Full control, no lock-in | High maintenance, security risk | $50K initial + $10K/mo | 4/10 |

**Recommendation**: Buy (Auth0)
- Not core competency
- Proven solution available
- Security-critical (don't build yourself)
- Cost justified by reduced risk
```

## 4. Technology Adoption Framework

For evaluating new technologies or frameworks.

### Maturity Assessment

```markdown
## Technology Maturity

| Factor | Score | Notes |
|--------|-------|-------|
| **Community** | | |
| GitHub stars | 8/10 | 50K+ stars |
| Active contributors | 7/10 | 200+ contributors, 50+ active |
| Stack Overflow questions | 9/10 | 10K+ questions answered |
| **Maintenance** | | |
| Last commit | 10/10 | Yesterday |
| Release frequency | 8/10 | Monthly releases |
| Issue response time | 7/10 | < 48 hours median |
| **Stability** | | |
| Version | 9/10 | v3.5 (mature) |
| Breaking changes | 6/10 | Some in major versions |
| Deprecation policy | 8/10 | 6-month notice |
| **Adoption** | | |
| Production use | 9/10 | Used by Netflix, Airbnb |
| Case studies | 8/10 | Multiple public case studies |
| Enterprise support | 7/10 | Commercial support available |

**Overall Score**: 8.1/10 → **Safe to adopt**
```

### Risk Assessment

```markdown
## Adoption Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Abandoned project | Low | High | Active community, large companies using |
| Breaking changes | Medium | Medium | Pin to specific version, test before upgrading |
| Security vulnerabilities | Low | High | Regular security audits, CVE monitoring |
| Performance issues | Low | Medium | Load testing before production |
| Skill gap | High | Medium | 2-week training, documentation |

**Overall Risk**: **Medium** → Proceed with mitigations
```

## 5. Performance vs Maintainability Framework

Common trade-off in software development.

### Decision Guide

```markdown
## Performance vs Maintainability

### When to Optimize (Choose Performance)

- [ ] User-facing latency critical (< 200ms SLA)
- [ ] High-scale system (1M+ req/day)
- [ ] Performance directly impacts revenue
- [ ] Bottleneck identified and isolated
- [ ] Cost of poor performance > cost of complexity

**Example**: API endpoint with 2-second latency
→ Optimize (add caching, index database)

### When to Keep Simple (Choose Maintainability)

- [ ] Internal tool (not user-facing)
- [ ] Low traffic (< 1K req/day)
- [ ] Performance acceptable (meets SLA)
- [ ] Optimization adds significant complexity
- [ ] Team small or junior

**Example**: Admin dashboard with 1-second load time
→ Keep simple (acceptable for internal use)
```

### Hybrid Approach

```markdown
## Staged Optimization

1. **Start Simple** (Maintainability priority)
   - Write clear, readable code
   - No premature optimization
   - Measure performance

2. **Identify Bottlenecks** (Data-driven)
   - Profile in production
   - Identify top 3 bottlenecks
   - Calculate impact vs effort

3. **Optimize Selectively** (Balanced)
   - Optimize only critical paths
   - Keep non-critical code simple
   - Document optimization reasons

4. **Maintain** (Ongoing)
   - Monitor performance metrics
   - Refactor when needed
   - Don't over-engineer
```

## 6. Risk Assessment Framework

Evaluate and quantify risks in decisions.

### Risk Matrix

```markdown
## Risk Assessment

| Risk | Probability | Impact | Score | Priority |
|------|------------|--------|-------|----------|
| Database failure | Low (10%) | High (5) | 0.5 | P1 |
| DDoS attack | Medium (30%) | High (5) | 1.5 | P0 |
| Key engineer leaves | High (50%) | Medium (3) | 1.5 | P0 |
| Vendor price increase | Medium (30%) | Low (1) | 0.3 | P2 |
| Technology becomes obsolete | Low (10%) | Medium (3) | 0.3 | P2 |

**Risk Score** = Probability × Impact

**Priority**:
- P0 (Score > 1.0): Must mitigate immediately
- P1 (Score 0.5-1.0): Mitigate within month
- P2 (Score < 0.5): Monitor

### Mitigation Plans

**P0: DDoS Attack**
- Risk Score: 1.5 (30% × 5)
- Mitigation: CloudFlare DDoS protection ($200/mo)
- Residual Risk: 0.15 (5% × 3) → P2

**P0: Key Engineer Leaves**
- Risk Score: 1.5 (50% × 3)
- Mitigation: Documentation, pair programming, knowledge sharing
- Residual Risk: 0.6 (30% × 2) → P1
```

## 7. Principle Application Template

When establishing a new principle.

```markdown
## Principle Template

### Principle Name
[Short, memorable name]

### Context
[When does this principle apply?]

### Statement
[Clear, actionable statement of the principle]

### Rationale
[Why this principle exists, what it optimizes for]

### Application
[How to apply this principle in practice]

### Examples

**✅ Good Example**:
[Concrete example following the principle]

**❌ Bad Example**:
[Concrete example violating the principle]

### Exceptions
[When NOT to apply this principle]

### Related Principles
[Other principles that interact with this one]

---

## Example Principle

### Principle Name
Database Selection for OLTP Workloads

### Context
When choosing a database for transactional workloads with ACID requirements

### Statement
Use PostgreSQL as default for OLTP unless specific requirements dictate otherwise

### Rationale
- Team expertise (5 years experience)
- ACID compliance
- Proven at scale
- Rich ecosystem
- Avoid decision fatigue

### Application
1. Start with PostgreSQL
2. Switch if:
   - Write throughput > 50K/sec → Cassandra
   - Document-heavy → MongoDB
   - Time-series → TimescaleDB
   - Key-value only → Redis

### Examples

**✅ Good**: User service needs ACID, complex joins
→ Use PostgreSQL

**❌ Bad**: Analytics service with time-series data
→ Use TimescaleDB (specialized for time-series)

### Exceptions
- Greenfield project with no ACID requirements
- Team has no PostgreSQL experience
- Specific features needed (e.g., graph queries → Neo4j)

### Related Principles
- Choose boring technology
- Optimize for team expertise
- Avoid premature optimization
```

## 8. Quick Reference: Common Patterns

### Pattern: Technology Choice

1. Check if principle exists
2. Evaluate against principle criteria
3. If exception needed, document why
4. Make decision
5. Document in ADR

### Pattern: Build vs Buy

1. Core competency check
2. Solution availability check
3. Cost-benefit analysis
4. Risk assessment
5. Make decision
6. Document in ADR

### Pattern: Performance Optimization

1. Measure current performance
2. Identify bottleneck
3. Calculate impact vs effort
4. Decide optimize or defer
5. If optimize, isolate complexity
6. Document rationale

### Pattern: Architectural Change

1. Define problem and constraints
2. List alternatives (minimum 3)
3. Trade-off analysis
4. Risk assessment
5. Migration plan
6. Document in Design Doc + ADR

## 9. Templates for Common Decisions

### Database Choice Template

```markdown
## Database Selection

**Workload Type**: [OLTP/OLAP/Mixed/Time-series/Document]
**ACID Required**: [Yes/No]
**Expected Scale**: [req/sec, data size]
**Query Complexity**: [Simple K-V / Complex joins / Analytics]
**Team Expertise**: [PostgreSQL/MongoDB/MySQL/Other]

## Evaluation

[Use trade-off analysis template]

## Recommendation

[State choice with rationale]
```

### Library/Framework Choice Template

```markdown
## Library Selection: [Purpose]

**Requirements**:
- [ ] Active maintenance (commit in last 3 months)
- [ ] 1000+ GitHub stars
- [ ] Compatible license (MIT/Apache2)
- [ ] TypeScript support (if applicable)
- [ ] Good documentation

**Candidates**:

| Library | Stars | Last Update | License | Score |
|---------|-------|-------------|---------|-------|
| Option A | 50K | 2 days ago | MIT | 9/10 |
| Option B | 5K | 1 month ago | Apache2 | 7/10 |

**Recommendation**: [Choice with rationale]
```

---

## Integration with Other Tools

These frameworks integrate with:
- `/adr` command: Document final decision
- `principle-guide` skill: Apply frameworks interactively
- `tech-doc-reviewer` agent: Verify decisions follow frameworks
- docs/guides/decision-making.md: Philosophical foundation

## References

- Decision-making philosophy: docs/guides/decision-making.md
- ADR template: docs/reference/templates.md (line 44+)
- Checklist: docs/reference/checklists.md (line 186+)
