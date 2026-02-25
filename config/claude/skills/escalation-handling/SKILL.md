---
name: escalation-handling
description: エスカレーションマーカーの検出、判定フロー、テンプレート選択、PM報告形式。Tech Lead が使用する。
---

# Escalation Handling ガイド

## マーカー形式

サブエージェントは問題検出時に結果に以下のマーカーを埋め込む:

```
[ESCALATION:{BLOCKING|WARNING|INFO}]
種別: {scope|design|technical|replan}
概要: {1行要約}
詳細: {具体的な内容}
選択肢: {ある場合}
```

## 判定フロー

```
サブエージェントの結果を受信
  │
  ├── [ESCALATION:BLOCKING] を検出
  │     → 作業停止
  │     → テンプレートからエスカレーションドキュメントを作成
  │     → PM に判断を求める
  │
  ├── [ESCALATION:WARNING] を検出
  │     → 作業続行
  │     → エスカレーションドキュメントを作成
  │     → 次の判断ポイントで PM に報告
  │
  ├── [ESCALATION:INFO] を検出
  │     → 作業続行
  │     → 成果物ドキュメント内に記録
  │
  └── マーカーなし
        → 正常続行
```

## テンプレート選択

| 種別 | テンプレート | 使用場面 |
|------|------------|---------|
| scope | `docs/escalation/templates/scope.md` | Issue のスコープを超える変更が必要 |
| design | `docs/escalation/templates/design-adr.md` | 設計判断が必要（ADR にも配置） |
| technical | `docs/escalation/templates/technical.md` | 技術的ブロッカーが見つかった |
| replan | `docs/escalation/templates/replan.md` | 計画の見直しが必要 |

## エスカレーションドキュメントの配置

ファイル名: `docs/escalation/{issue-id}-{type}-{n}.md`

例: `docs/escalation/PBI-003-technical-1.md`

## PM への報告形式

### Blocking の場合

```
🚨 Blocking エスカレーション

Issue: {issue-id}
フェーズ: {現在のフェーズ}
種別: {scope|design|technical|replan}

概要: {1行要約}

詳細:
{問題の具体的な内容}

選択肢:
1. {選択肢A}: {メリット / デメリット}
2. {選択肢B}: {メリット / デメリット}

推奨: {推奨する選択肢と理由}

ドキュメント: {エスカレーションドキュメントのパス}

→ PM の判断をお願いします。判断後に /execute continue で再開できます。
```

### Warning の場合

```
⚠️ Warning エスカレーション

Issue: {issue-id}
種別: {type}
概要: {1行要約}

作業は続行しています。次の判断ポイントでご確認ください。
ドキュメント: {パス}
```

## 修正ループ上限到達時のエスカレーション

修正ループが上限に達した場合は `replan` テンプレートを使用し、根本原因の分類（A: 分析の見落とし / B: 仕様の曖昧さ / C: 技術的困難）と各分類に対応する選択肢を提示する。詳細は `/implement` コマンド定義の「修正ループ上限到達時の処理」を参照。
