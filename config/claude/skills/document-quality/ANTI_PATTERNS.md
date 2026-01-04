# Anti-patterns in Documentation

Detailed catalog of anti-patterns to detect and fix in technical documents.

Reference: docs/reference/anti-patterns.md, docs/reference/checklists.md (line 285+)

## 1. 思考停止ワード (Vague Expressions)

### 1.1 Vague Adverbs

**Pattern**: 適切に、柔軟に、効率的に、正しく

**Problem**: No concrete criteria or measurement

**Detection**:
- "適切に実装する" (implement appropriately)
- "柔軟に対応する" (respond flexibly)
- "効率的に処理する" (process efficiently)
- "正しく設定する" (configure correctly)

**Fix**:
```
❌ Before: パフォーマンスを適切に改善する
✅ After: レスポンスタイムを200ms以下に改善する

❌ Before: データベースを柔軟に選択する
✅ After: トラフィックが1000req/s以下ならPostgreSQL、超える場合はCassandraを選択

❌ Before: セキュリティを正しく設定する
✅ After: TLS 1.3、AES-256暗号化、定期的な証明書ローテーション（90日）を設定
```

### 1.2 Conditional Without Criteria

**Pattern**: 必要に応じて、状況に応じて、場合によっては

**Problem**: No decision criteria specified

**Detection**:
- "必要に応じてスケールする" (scale as needed)
- "状況に応じて判断する" (decide based on situation)
- "場合によっては○○を使う" (use ○○ in some cases)

**Fix**:
```
❌ Before: 必要に応じてキャッシュを使う
✅ After: 同一データへのアクセスが10回/秒を超える場合、Redisキャッシュを使用

❌ Before: 状況に応じてロールバックする
✅ After: エラー率が5%を超えた場合、自動的に前バージョンにロールバック
```

### 1.3 Hedging Expressions

**Pattern**: 基本的に、なるべく、できるだけ、原則として

**Problem**: Exception handling unclear

**Detection**:
- "基本的には○○する" (basically do ○○)
- "なるべく早く" (as soon as possible)
- "できるだけ避ける" (avoid if possible)

**Fix**:
```
❌ Before: 基本的にはテストを書く
✅ After: すべての新機能に対してユニットテストを書く。レガシーコードは段階的にカバレッジ向上

❌ Before: なるべく早く対応する
✅ After: P0: 1時間以内、P1: 4時間以内、P2: 翌営業日に対応

❌ Before: できるだけ複雑さを避ける
✅ After: 循環的複雑度10以下、ネスト深さ3以下を維持
```

### 1.4 Abstract Justifications

**Pattern**: バランスが大事、結局は人、結局はお金

**Problem**: No specific trade-off analysis

**Detection**:
- "バランスが大事" (balance is important)
- "結局は人の問題" (ultimately a people problem)
- "結局はコスト次第" (ultimately depends on cost)

**Fix**:
```
❌ Before: スピードと品質のバランスが大事
✅ After: 初期リリースは2週間で最小機能、品質向上は3ヶ月かけて段階的に実施

❌ Before: 結局は人の問題
✅ After: Goの経験者2名が必要。外部採用（2ヶ月）または内部育成（4ヶ月）で対応

❌ Before: コスト次第で決める
✅ After: 月額$500以下ならSaaS、超える場合はセルフホスト（初期費用$2000）
```

## 2. Structural Anti-patterns

### 2.1 Missing Context

**Pattern**: 背景説明なしに結論

**Problem**: Reader cannot understand why

**Detection**:
- Document starts with solution
- No "Background" or "Context" section
- Missing problem statement

**Fix**:
```
❌ Before:
# ADR-001: Use PostgreSQL
We will use PostgreSQL.

✅ After:
# ADR-001: Use PostgreSQL

## Context
Current MySQL setup has reached scaling limits:
- 10K writes/sec causing replication lag (5+ seconds)
- Complex joins on 100M+ row tables timing out
- Need for JSON field support for flexible schemas

## Problem
Need database that handles:
- High write throughput (20K+ writes/sec)
- Complex analytical queries
- Flexible schema evolution
```

### 2.2 Missing Trade-off Analysis

**Pattern**: Only positive aspects mentioned

**Problem**: No consideration of alternatives or downsides

**Detection**:
- No "Alternatives Considered" section
- Only benefits listed, no drawbacks
- No comparison table

**Fix**:
```
❌ Before:
We choose microservices because it's scalable.

✅ After:
## Alternatives Considered

| Criterion | Monolith | Microservices | Serverless |
|-----------|----------|---------------|------------|
| Development Speed | Fast (1x) | Slow (2x) | Medium (1.5x) |
| Operational Complexity | Low | High | Medium |
| Scaling Flexibility | Low | High | Very High |
| Cost at current scale | Low ($500/mo) | High ($2000/mo) | Medium ($800/mo) |

## Decision
Choose Microservices despite higher cost and complexity because:
1. Team scaling: 15+ engineers need independent deployment
2. Service-specific scaling: Payment service needs 10x capacity of others
3. Technology diversity: ML team needs Python, core team uses Go
```

### 2.3 No Concrete Examples

**Pattern**: Abstract descriptions only

**Problem**: Hard to verify understanding

**Detection**:
- No code examples
- No concrete use cases
- No sample data

**Fix**:
```
❌ Before:
API will be RESTful and handle user operations.

✅ After:
## API Design

### Example: Create User
```http
POST /api/v1/users
Content-Type: application/json

{
  "email": "user@example.com",
  "name": "John Doe",
  "role": "viewer"
}
```

Response:
```json
{
  "id": "usr_1234567890",
  "email": "user@example.com",
  "name": "John Doe",
  "role": "viewer",
  "created_at": "2026-01-04T12:00:00Z"
}
```
```

## 3. Meeting/Communication Anti-patterns

### 3.1 Unprepared Meeting

**Pattern**: "えっと..."、"どうしましょうか..."

**Problem**: Wasting participants' time

**Detection**:
- No agenda in meeting notes
- No pre-meeting materials
- No clear objective

**Fix**: Use docs/reference/checklists.md (line 18+) meeting preparation checklist

### 3.2 Information Overload

**Pattern**: 10分話しても結論が見えない

**Problem**: Too much information, no structure

**Detection**:
- No PREP structure (Point, Reason, Example, Point)
- More than 5 main points
- No prioritization

**Fix**: Use PREP method, limit to 3 key points

### 3.3 Jargon Overload

**Pattern**: Technical terms for non-technical audience

**Problem**: Audience cannot understand

**Detection**:
- Technical terms without explanation
- No audience consideration
- Missing context for business stakeholders

**Fix**: Adapt language to audience level, provide analogies

## 4. Decision-Making Anti-patterns

### 4.4 Repeat Decisions

**Pattern**: Making same decision repeatedly

**Problem**: No principle established

**Detection**:
- Similar decisions appear multiple times
- No documented decision framework
- Team asks "how should we decide X?" frequently

**Fix**: Create principles (see docs/guides/decision-making.md)

```
❌ Before: Deciding library choice every time
✅ After: Establish principle:
"Use established libraries with 1000+ GitHub stars,
active maintenance (commit in last 3 months),
and compatible license (MIT/Apache2)"
```

## 5. Detection Checklist

Use this checklist to scan documents:

### Vague Expressions
- [ ] 適切に、柔軟に、効率的に → Replace with specific criteria
- [ ] 必要に応じて → Specify conditions
- [ ] 基本的に、なるべく → Define exceptions
- [ ] バランスが大事 → Specify trade-offs

### Structure
- [ ] Missing context/background → Add problem statement
- [ ] No alternatives → Add comparison table
- [ ] No examples → Add concrete use cases
- [ ] Only benefits → Add drawbacks and risks

### Completeness
- [ ] No "why" explanation → Add rationale
- [ ] No success criteria → Add measurable goals
- [ ] No timeline → Add milestones
- [ ] No risks → Identify and document

## 6. Quick Reference Table

| Anti-pattern | Detection | Fix |
|-------------|-----------|-----|
| "適切に" | Vague adverb | Specific criteria/numbers |
| "必要に応じて" | Conditional without criteria | Define threshold |
| "バランスが大事" | Abstract justification | Explicit trade-off |
| No context | Starts with solution | Add background/problem |
| No alternatives | Single option | Comparison table |
| No examples | Abstract only | Concrete use cases |
| No metrics | Vague goals | Measurable criteria |

## Related Resources

- Full anti-patterns list: docs/reference/anti-patterns.md
- 思考停止ワードチェックリスト: docs/reference/checklists.md (line 285+)
- Decision-making guide: docs/guides/decision-making.md
- Documentation guide: docs/guides/documentation.md
