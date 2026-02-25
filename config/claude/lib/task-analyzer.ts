/**
 * タスク特性分析とアプローチ推奨機能
 *
 * ユーザーリクエストを分析し、Agent Teams または Sub-agent のどちらが最適かを判断します。
 */

// ==================== インターフェース定義 ====================

/**
 * タスク特性分析結果
 */
interface TaskCharacteristics {
  /** 対象フェーズ */
  targetPhase: "PLANNING" | "EXECUTION";
  /** 推定ファイル数 */
  estimatedFileCount: number;
  /** 相互議論が必要か */
  requiresMutualDiscussion: boolean;
  /** 依存関係があるか */
  hasDependencies: boolean;
  /** タスクの複雑性 */
  complexity: "LOW" | "MEDIUM" | "HIGH";
  /** セキュリティ要件があるか */
  hasSecurityRequirements: boolean;
  /** アーキテクチャ変更があるか */
  hasArchitectureChanges: boolean;
}

/**
 * 推奨アプローチの結果
 */
interface RecommendedApproach {
  /** 推奨方式 */
  approach: "AGENT_TEAMS" | "SUB_AGENT_SEQUENTIAL" | "SUB_AGENT_PARALLEL";
  /** 推奨理由 */
  reason: string;
  /** 期待されるトークンコスト */
  expectedTokenCost: "LOW" | "MEDIUM" | "HIGH";
  /** 期待される時間短縮効果 */
  expectedTimeReduction: string;
  /** リスク */
  risks: string[];
  /** 推奨の確信度 (0-100) */
  confidence: number;
}

/**
 * タスク分析の入力
 */
interface AnalysisInput {
  /** ユーザーリクエスト */
  request: string;
  /** 対象フェーズ */
  targetPhase: "PLANNING" | "EXECUTION";
  /** コードベースパス */
  codebasePath?: string;
}

// ==================== メイン関数 ====================

/**
 * タスク特性を分析し、最適なアプローチを推奨
 */
function recommendApproach(task: TaskCharacteristics): RecommendedApproach {
  // PLANNING フェーズの判断ロジック
  if (task.targetPhase === "PLANNING") {
    return recommendForPlanning(task);
  }

  // EXECUTION フェーズの判断ロジック
  if (task.targetPhase === "EXECUTION") {
    return recommendForExecution(task);
  }

  // デフォルト: Sub-agent Sequential
  return {
    approach: "SUB_AGENT_SEQUENTIAL",
    reason: "不明な対象フェーズのため、デフォルトの Sequential 実行を推奨",
    expectedTokenCost: "LOW",
    expectedTimeReduction: "なし",
    risks: ["対象が不明確"],
    confidence: 50
  };
}

/**
 * PLANNING フェーズ向けの推奨ロジック
 */
function recommendForPlanning(task: TaskCharacteristics): RecommendedApproach {
  // 複雑なプロジェクトの判定
  if (task.requiresMutualDiscussion || isComplexProject(task)) {
    return {
      approach: "AGENT_TEAMS",
      reason: "複数観点での相互議論により、矛盾を早期発見できる。" +
              (task.hasSecurityRequirements ? "セキュリティ要件と他の観点で矛盾が予想されます。" : "") +
              (task.hasArchitectureChanges ? "アーキテクチャ変更により影響範囲が広範です。" : ""),
      expectedTokenCost: "HIGH",
      expectedTimeReduction: "なし（品質向上優先）",
      risks: ["トークンコスト増（+30-50%）", "実行時間増（+20%）"],
      confidence: 85
    };
  }

  // シンプルなプロジェクト: Sub-agent 並列実行
  return {
    approach: "SUB_AGENT_PARALLEL",
    reason: "観点間の矛盾リスクが低く、並列実行で高速化できます",
    expectedTokenCost: "LOW",
    expectedTimeReduction: "なし（元々並列実行）",
    risks: ["観点間の矛盾を PDA で初めて発見"],
    confidence: 75
  };
}

/**
 * EXECUTION フェーズ向けの推奨ロジック（Refactoring）
 */
function recommendForExecution(task: TaskCharacteristics): RecommendedApproach {
  const fileCount = task.estimatedFileCount;

  // 1-2 ファイル: Sequential 推奨
  if (fileCount <= 2) {
    return {
      approach: "SUB_AGENT_SEQUENTIAL",
      reason: "少数のファイルのため、並列化のオーバーヘッドが大きい",
      expectedTokenCost: "LOW",
      expectedTimeReduction: "なし",
      risks: [],
      confidence: 90
    };
  }

  // 3-4 ファイル: Sequential 推奨（コスト重視）
  if (fileCount <= 4) {
    return {
      approach: "SUB_AGENT_SEQUENTIAL",
      reason: "トークンコスト増加に見合う効果が限定的です",
      expectedTokenCost: "LOW",
      expectedTimeReduction: "なし",
      risks: ["実行時間がやや長い"],
      confidence: 80
    };
  }

  // 5-9 ファイル: 依存関係に応じて判断
  if (fileCount <= 9) {
    if (task.hasDependencies) {
      return {
        approach: "SUB_AGENT_SEQUENTIAL",
        reason: "ファイル間に依存関係があるため、順次実行が安全です",
        expectedTokenCost: "LOW",
        expectedTimeReduction: "なし",
        risks: [],
        confidence: 85
      };
    }

    return {
      approach: "AGENT_TEAMS",
      reason: "独立した複数ファイルのリファクタリングを並列実行できる",
      expectedTokenCost: "MEDIUM",
      expectedTimeReduction: "50-60%",
      risks: ["ファイル競合リスク（低）", "統合検証の複雑化"],
      confidence: 90
    };
  }

  // 10+ ファイル: Agent Teams 強く推奨
  if (!task.hasDependencies) {
    return {
      approach: "AGENT_TEAMS",
      reason: "大規模な独立ファイルへのリファクタリングで大幅な高速化が期待できる",
      expectedTokenCost: "MEDIUM",
      expectedTimeReduction: "60-70%",
      risks: ["ファイル競合リスク（中）", "統合検証の複雑化"],
      confidence: 95
    };
  }

  // 依存関係がある 10+ ファイル
  return {
    approach: "SUB_AGENT_SEQUENTIAL",
    reason: "大規模だが依存関係が強く、並列実行が困難です。バッチ実行を検討してください。",
    expectedTokenCost: "LOW",
    expectedTimeReduction: "なし",
    risks: ["実行時間が非常に長い"],
    confidence: 70
  };
}

// ==================== ヘルパー関数 ====================

/**
 * 複雑なプロジェクトかどうかを判定
 */
function isComplexProject(task: TaskCharacteristics): boolean {
  // 複雑性スコアを計算
  let complexityScore = 0;

  if (task.complexity === "HIGH") complexityScore += 3;
  else if (task.complexity === "MEDIUM") complexityScore += 2;
  else complexityScore += 1;

  if (task.hasSecurityRequirements) complexityScore += 2;
  if (task.hasArchitectureChanges) complexityScore += 2;
  if (task.estimatedFileCount >= 10) complexityScore += 2;

  // スコアが 5 以上で複雑と判定
  return complexityScore >= 5;
}

/**
 * リクエストからファイル数を推定
 */
function estimateFileCount(request: string): number {
  // ファイルパスが明示されている場合
  const filePatterns = request.match(/\S+\.(ts|js|tsx|jsx|py|go|java|kt|rs)/g);
  if (filePatterns) {
    return filePatterns.length;
  }

  // ディレクトリが指定されている場合（推定）
  if (request.includes("src/") || request.includes("lib/") || request.includes("components/")) {
    return 10; // 仮の推定値
  }

  // キーワードベースの推定
  if (request.match(/全体|すべて|プロジェクト全体|大規模/)) {
    return 20;
  }
  if (request.match(/複数|いくつか|数ファイル/)) {
    return 5;
  }

  // デフォルト
  return 3;
}

/**
 * リクエストの複雑性を分析
 */
function analyzeComplexity(request: string): "LOW" | "MEDIUM" | "HIGH" {
  let score = 0;

  // キーワードベースの分析
  const highComplexityKeywords = [
    "アーキテクチャ", "設計変更", "リファクタリング全体", "大規模",
    "migration", "architecture", "refactor entire"
  ];
  const mediumComplexityKeywords = [
    "複数", "統合", "共通化", "抽出",
    "multiple", "integrate", "extract"
  ];

  for (const keyword of highComplexityKeywords) {
    if (request.toLowerCase().includes(keyword.toLowerCase())) {
      score += 2;
    }
  }
  for (const keyword of mediumComplexityKeywords) {
    if (request.toLowerCase().includes(keyword.toLowerCase())) {
      score += 1;
    }
  }

  if (score >= 3) return "HIGH";
  if (score >= 1) return "MEDIUM";
  return "LOW";
}

/**
 * セキュリティ要件を検出
 */
function detectSecurityRequirements(request: string): boolean {
  const securityKeywords = [
    "認証", "auth", "セキュリティ", "security",
    "暗号", "encrypt", "権限", "permission",
    "トークン", "token", "ログイン", "login"
  ];

  return securityKeywords.some(keyword =>
    request.toLowerCase().includes(keyword.toLowerCase())
  );
}

/**
 * アーキテクチャ変更を検出
 */
function detectArchitectureChanges(request: string): boolean {
  const architectureKeywords = [
    "アーキテクチャ", "architecture",
    "設計変更", "design change",
    "構造変更", "restructure",
    "分離", "separate", "統合", "integrate"
  ];

  return architectureKeywords.some(keyword =>
    request.toLowerCase().includes(keyword.toLowerCase())
  );
}

/**
 * 依存関係を分析（簡易版）
 */
function analyzeDependencies(request: string): boolean {
  const dependencyKeywords = [
    "依存", "depend",
    "連鎖", "chain",
    "順序", "order",
    "統合", "integrate"
  ];

  return dependencyKeywords.some(keyword =>
    request.toLowerCase().includes(keyword.toLowerCase())
  );
}

/**
 * タスクを分析して特性を返す
 */
function analyzeTask(input: AnalysisInput): TaskCharacteristics {
  const request = input.request;

  return {
    targetPhase: input.targetPhase,
    estimatedFileCount: estimateFileCount(request),
    requiresMutualDiscussion: detectSecurityRequirements(request) ||
                               detectArchitectureChanges(request),
    hasDependencies: analyzeDependencies(request),
    complexity: analyzeComplexity(request),
    hasSecurityRequirements: detectSecurityRequirements(request),
    hasArchitectureChanges: detectArchitectureChanges(request)
  };
}

// ==================== エクスポート（疑似） ====================

/**
 * エントリーポイント: タスクを分析し、推奨アプローチを返す
 */
function analyzeAndRecommend(input: AnalysisInput): RecommendedApproach {
  const characteristics = analyzeTask(input);
  return recommendApproach(characteristics);
}

// Export (for module usage)
export {
  analyzeTask,
  recommendApproach,
  analyzeAndRecommend,
  type TaskCharacteristics,
  type RecommendedApproach,
  type AnalysisInput
};
