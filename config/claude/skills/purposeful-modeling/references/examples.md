# 視点別モデリング例

同じドメイン概念を3つの視点でモデリングする具体例を提供する。

## 目次

- 例1：注文管理
- 例2：顧客分類
- 例3：ECチェックアウト
- アンチパターン例

---

## 例1：注文管理

### シナリオ

ECシステムで、異なる配送オプションを持つ注文をモデリングする必要がある。

### 概念モデル

**目的**: ビジネスドメインにおける注文の仕組みを理解する。

```
<<concept>> Order
├── deliveryCharge: Money
├── orderDate: Date
└── items: OrderItemの集合

<<concept>> UrgentOrder extends Order
├── <<dynamic>> deliveryCharge: Money
└── guaranteedDeliveryDate: Date

注: "<<dynamic>>"は注文が作成後に緊急になれることを示す
    （ビジネスの現実）
```

**主なモデリング決定**:
- UrgentOrderは動的サブタイプ（注文は緊急になれる）
- 実装の関心事なし（ID、外部キー）
- ビジネスが注文をどう考えるかを反映

### 仕様モデル

**目的**: ソフトウェアが注文に対して何をすべきかを定義する。

```
<<type>> Order
├── deliveryCharge: Money
├── isUrgent: Boolean
├── orderDate: Date
├── getItems(): List<OrderItem>
├── beUrgent(): void
└── calculateTotal(): Money

<<interface>> DeliveryChargeCalculator
└── calculate(order: Order): Money
```

**主なモデリング決定**:
- 動的サブタイピングはboolean属性に集約
- 操作は必要な振る舞いを定義
- まだ実装戦略は選択していない

### 実装モデル

**目的**: 実際のコード設計を文書化する。

```
<<class>> Order
├── -id: UUID
├── -deliveryStrategy: DeliveryStrategy
├── -items: List<OrderItem>
├── +deliveryCharge(): Money
├── +isUrgent(): Boolean
├── +beUrgent(): void
└── +calculateTotal(): Money

<<interface>> DeliveryStrategy
└── +getCharge(): Money

<<class>> RegularDeliveryStrategy implements DeliveryStrategy
└── +getCharge(): Money  // 定額を返す

<<class>> UrgentDeliveryStrategy implements DeliveryStrategy
└── +getCharge(): Money  // プレミアム料金を返す

<<class>> OrderRepository
├── +findById(id: UUID): Order
├── +save(order: Order): void
└── +findByCustomer(customerId: UUID): List<Order>
```

**主なモデリング決定**:
- 配送料金の変動にStrategyパターン
- 永続化にRepositoryパターン
- 実装固有のIDと型

---

## 例2：顧客分類

### シナリオ

銀行が顧客を取引関係のステータスで分類する。

### 概念モデル

**目的**: 銀行ドメインにおける顧客関係を理解する。

```
<<concept>> Customer
├── name: PersonName
├── dateJoined: Date
└── accounts: Accountの集合

<<concept>> StandardCustomer extends Customer

<<concept>> PreferredCustomer extends Customer
├── relationshipManager: Employee
├── discountRate: Percentage
└── <<dynamic>>  // 残高に基づいてアップグレード/ダウングレード可能

<<concept>> PrivateBankingCustomer extends PreferredCustomer
└── dedicatedTeam: Employeeの集合
```

**捉えたドメインの知見**:
- 顧客ステータスは動的に変化可能
- プライベートバンキングは優良顧客の特別なケース
- スタッフとの関係は双方向

### 仕様モデル

**目的**: 顧客関連のシステム振る舞いを定義する。

```
<<type>> Customer
├── name: String
├── status: CustomerStatus
├── getAccounts(): List<Account>
├── getTotalBalance(): Money
└── upgradeStatus(): void

<<enumeration>> CustomerStatus
├── STANDARD
├── PREFERRED
└── PRIVATE_BANKING

<<interface>> CustomerStatusPolicy
├── evaluateStatus(customer: Customer): CustomerStatus
└── getEligibleBenefits(status: CustomerStatus): List<Benefit>
```

**仕様の決定**:
- ステータスはenumeration（ソフトウェアの制限）
- ステータス判定ルール用のPolicyインターフェース
- 特典を明示的にモデル化

### 実装モデル

**目的**: 実際のコード構造を文書化する。

```
<<class>> Customer
├── -id: Long
├── -name: String
├── -status: CustomerStatus
├── -accounts: Set<Account>
├── +getStatus(): CustomerStatus
└── +evaluateForUpgrade(): void

<<class>> CustomerStatusService
├── -policyEngine: StatusPolicyEngine
├── -notificationService: NotificationService
├── +evaluateAndUpdateStatus(customerId: Long): void
└── -notifyStatusChange(customer: Customer, newStatus: CustomerStatus): void

<<class>> StatusPolicyEngine
├── -rules: List<StatusRule>
├── +evaluate(customer: Customer): CustomerStatus
└── +loadRulesFromConfig(): void

<<class>> CustomerRepository extends JpaRepository<Customer, Long>
├── +findByStatus(status: CustomerStatus): List<Customer>
└── +findEligibleForUpgrade(): List<Customer>
```

**実装の決定**:
- 永続化にJPA
- 柔軟なポリシー用のルールエンジン
- オーケストレーション用のサービスレイヤー
- 通知との統合

---

## 例3：ECチェックアウト

### シナリオ

オンラインストアのチェックアウトプロセスをモデル化する。

### 概念モデル（アクティビティ図中心）

**目的**: ビジネスのチェックアウトプロセスを理解する。

```
[業務プロセス: チェックアウト]

顧客            │  在庫          │  決済
────────────────┼────────────────┼────────────────
   │            │                │
   ▼            │                │
┌─────────┐     │                │
│カート   │     │                │
│確認     │     │                │
└────┬────┘     │                │
     │          │                │
     ▼          │                │
┌─────────┐     │                │
│配送方法 │     │                │
│選択     │     │                │
└────┬────┘     │                │
     │          ▼                │
     │     ┌─────────┐           │
     │     │在庫     │           │
     │     │確認     │           │
     │     └────┬────┘           │
     │          │                │
     ▼          │                ▼
┌─────────┐     │          ┌─────────┐
│支払情報 │     │          │決済     │
│入力     │─────┼─────────►│処理     │
└────┬────┘     │          └────┬────┘
     │          │                │
     │          ▼                │
     │     ┌─────────┐           │
     │     │商品     │◄──────────┘
     │     │引当     │
     │     └────┬────┘
     ▼          ▼
┌──────────────────────┐
│  注文確定            │
└──────────────────────┘
```

### 仕様モデル（シーケンス図中心）

**目的**: 必要なシステム相互作用を定義する。

```
<<type>> CheckoutService
├── initiateCheckout(cartId: CartId): Checkout
├── setShipping(checkoutId, shippingOption): void
├── processPayment(checkoutId, paymentDetails): PaymentResult
└── confirmOrder(checkoutId): Order

シーケンス: 正常系チェックアウト

User -> CheckoutService: initiateCheckout(cartId)
CheckoutService -> InventoryService: checkAvailability(items)
InventoryService --> CheckoutService: AvailabilityResult
CheckoutService --> User: Checkout(在庫あり商品, 配送オプション)

User -> CheckoutService: setShipping(checkoutId, EXPRESS)
CheckoutService --> User: UpdatedCheckout(配送込み合計)

User -> CheckoutService: processPayment(checkoutId, paymentDetails)
CheckoutService -> PaymentGateway: authorize(amount, details)
PaymentGateway --> CheckoutService: AuthorizationResult
CheckoutService -> InventoryService: reserve(items)
CheckoutService --> User: PaymentResult(success)

User -> CheckoutService: confirmOrder(checkoutId)
CheckoutService -> PaymentGateway: capture(authorizationId)
CheckoutService -> OrderService: createOrder(checkout)
CheckoutService --> User: Order
```

### 実装モデル（クラス + シーケンス）

**目的**: 実際のチェックアウト実装を文書化する。

```
<<class>> CheckoutController
├── -checkoutService: CheckoutService
├── +initiateCheckout(cartId: UUID): ResponseEntity<CheckoutDTO>
├── +updateShipping(checkoutId: UUID, request: ShippingRequest): ResponseEntity<CheckoutDTO>
├── +processPayment(checkoutId: UUID, request: PaymentRequest): ResponseEntity<PaymentResultDTO>
└── +confirmOrder(checkoutId: UUID): ResponseEntity<OrderDTO>

<<class>> CheckoutServiceImpl implements CheckoutService
├── -checkoutRepository: CheckoutRepository
├── -inventoryClient: InventoryClient
├── -paymentGateway: PaymentGateway
├── -orderService: OrderService
├── -transactionTemplate: TransactionTemplate
├── +initiateCheckout(cartId: UUID): Checkout
└── ...

<<class>> PaymentGatewayAdapter implements PaymentGateway
├── -stripeClient: StripeClient
├── -retryTemplate: RetryTemplate
├── +authorize(amount: Money, details: PaymentDetails): AuthResult
├── +capture(authId: String): CaptureResult
└── -handleStripeError(e: StripeException): PaymentException
```

---

## アンチパターン例

### アンチパターン1: 視点の混在

**間違い**: 概念と実装の関心事を混在させる。

```
// やってはいけない
<<concept>> Customer
├── id: Long                    // 実装の詳細！
├── name: String
├── customerRepository: Repository  // 実装！
└── accounts: List<Account>     // ジェネリック型は実装
```

**正しい方法**: 視点を分離する。

```
// 概念
<<concept>> Customer
├── name: PersonName
└── accounts: Accountの集合

// 実装（別の図）
<<class>> Customer
├── -id: Long
├── -name: String
└── -accounts: List<Account>
```

### アンチパターン2: ラベルなしの図

**間違い**: 視点を示さないクラス図。

```
// これは何？概念？仕様？実装？
Order
├── deliveryCharge: Money
└── items: List
```

**正しい方法**: 常に視点をラベル付けする。

```
// 図のタイトル: 注文概念モデル
// 視点: 概念
// 目的: ドメイン理解を文書化

<<concept>> Order
├── deliveryCharge: Money
└── items: Itemの集合
```

### アンチパターン3: 過度に詳細な概念モデル

**間違い**: 概念モデルに不要な技術的詳細を追加する。

```
<<concept>> Order
├── id: UUID                     // 不要
├── version: int                 // 技術的関心事
├── deliveryCharge: decimal(10,2) // データベース型！
├── createdAt: timestamp         // 技術的関心事
└── updatedAt: timestamp         // 技術的関心事
```

**正しい方法**: ドメイン概念に焦点を当てる。

```
<<concept>> Order
├── deliveryCharge: Money
├── orderDate: Date
└── items: OrderItemの集合
```
