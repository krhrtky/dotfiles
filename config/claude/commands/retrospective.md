あなたは Tech Lead として振る舞う。
Sprint のふりかえりを実施する。

## 入力

$ARGUMENTS に Sprint 番号を指定する。

## 手順

### Step 1: データ収集

以下のソースから Sprint の実績データを収集する:

- `docs/sprint/{sprint-number}/plan.md` — Sprint 計画
- `docs/backlog/` — PBI のステータス
- `docs/analysis/` — 分析ドキュメント
- `docs/review/` — レビュー結果
- `docs/escalation/` — エスカレーション履歴
- `docs/adr/` — Sprint 中に作成された ADR
- `docs/sprint/logs/agent-activity.jsonl` — エージェント活動ログ
- `git log` — コミット履歴（`Decision:` trailer を含む）

### Step 2: メトリクス分析

以下のメトリクスを算出する:

| メトリクス | 説明 |
|-----------|------|
| PBI 完了率 | 計画した PBI のうち Done になった割合 |
| タスク完了率 | 計画したタスクのうち完了した割合 |
| エスカレーション数 | Blocking / Warning / Info の各件数 |
| レビュー指摘数 | Critical / Major / Minor の各件数 |
| 修正ループ回数 | 実装→テスト→修正のループが発生した回数 |
| エージェント起動回数 | 各エージェントの起動回数 |
| 不確実性ファーストの効果 | 不安量「高」のタスクで問題が早期発見された件数 |

### Step 3: ふりかえりドキュメント生成

`docs/sprint/{sprint-number}/retrospective.md` に以下を保存する:

```markdown
# Sprint {番号} ふりかえり

> **期間**: {開始日} - {終了日}
> **Sprint ゴール**: {計画時のゴール}

## メトリクス

| メトリクス | 値 |
|-----------|-----|
| PBI 完了率 | {n}/{m}（{%}） |
| タスク完了率 | {n}/{m}（{%}） |
| Blocking エスカレーション | {n} 件 |
| Warning エスカレーション | {n} 件 |
| Critical レビュー指摘 | {n} 件 |
| Major レビュー指摘 | {n} 件 |
| 修正ループ発生 | {n} 回 |
| エージェント起動回数 | architect: {n}, developer: {n}, qa: {n}, reviewer: {n} |

## Keep（続けること）

{うまくいったこと、続けるべきプラクティス}

## Problem（問題点）

{うまくいかなかったこと、改善が必要な点}

## Try（次に試すこと）

{次の Sprint で試す改善アクション}

## 不確実性ファーストの振り返り

- 不安量「高」のタスクを先に着手した結果: {効果の分析}
- 価値×不確実性マトリクスの精度: {予測と実績の乖離}
- Spike の成果: {Spike を実施した場合、その効果}

## 設計判断の振り返り

- ADR 件数: {n}
- commit trailer（Decision:）件数: {n}
- 振り返りが必要な判断: {あれば}
```

### Step 4: PM への報告

ふりかえり結果のサマリーを PM に提示する。
特に Problem と Try について PM のフィードバックを求める。
