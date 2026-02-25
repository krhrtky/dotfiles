---
name: rop-patterns
description: Railway Oriented Programming の基本概念、Kotlin での Result 型実装、エラー型の設計。developer エージェントが使用する。
---

# Railway Oriented Programming パターン集

## 基本概念

処理を「成功の線路」と「失敗の線路」の2本のレールで表現する。各関数は Result を受け取り Result を返す。失敗が発生した時点で以降の処理はスキップされる。

```
Input → [validate] → [transform] → [save] → Output
           ↓              ↓            ↓
         Error           Error        Error
```

## Kotlin での実装パターン

### エラー型の定義（sealed class）

```kotlin
sealed class OrderError {
    data class NotFound(val id: OrderId) : OrderError()
    data class InvalidStatus(val current: OrderStatus, val expected: OrderStatus) : OrderError()
    data class InsufficientStock(val productId: ProductId, val requested: Int, val available: Int) : OrderError()
    data object Unauthorized : OrderError()
}
```

### Result チェーン（flatMap）

```kotlin
fun processOrder(command: ProcessOrderCommand): Result<OrderProcessed, OrderError> =
    validateCommand(command)
        .flatMap { findOrder(it.orderId) }
        .flatMap { checkStock(it) }
        .flatMap { calculateTotal(it) }
        .flatMap { saveOrder(it) }
        .map { OrderProcessed(it.id) }
```

### エラーからの復帰（recover）

```kotlin
fun findOrCreateUser(email: Email): Result<User, UserError> =
    userRepository.findByEmail(email)
        .recover { error ->
            when (error) {
                is UserError.NotFound -> createNewUser(email)
                else -> Result.failure(error)
            }
        }
```

### IO 境界での例外変換

```kotlin
fun findById(id: OrderId): Result<Order, OrderError> = runCatching {
    jooq.selectFrom(ORDERS)
        .where(ORDERS.ID.eq(id.value))
        .fetchOneInto(OrderRecord::class.java)
        ?: throw NoResultException()
}.fold(
    onSuccess = { Result.success(it.toDomain()) },
    onFailure = { Result.failure(OrderError.NotFound(id)) }
)
```

### 複数の Result の合成

```kotlin
fun validateOrder(order: Order): Result<Order, List<ValidationError>> {
    val errors = listOfNotNull(
        validateItems(order.items).errorOrNull(),
        validateAddress(order.address).errorOrNull(),
        validatePayment(order.payment).errorOrNull()
    )
    return if (errors.isEmpty()) Result.success(order)
           else Result.failure(errors)
}
```

## アンチパターン

```kotlin
// Bad: 例外でフロー制御
fun processOrder(id: OrderId): Order {
    val order = findOrder(id) ?: throw NotFoundException()
    if (!order.isValid()) throw ValidationException()
    return save(order)
}

// Bad: Result を無視して get()
val order = findOrder(id).getOrThrow() // ROP の意味がない
```
