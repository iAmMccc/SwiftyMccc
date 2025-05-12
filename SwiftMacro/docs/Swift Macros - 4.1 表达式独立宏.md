# Swift Macros - 表达式独立宏

在 Swift 宏体系中，`ExpressionMacro` 是一种非常重要且常用的角色。它专门用于生成**表达式级别**的代码，并且属于**独立宏（freestanding macro）**的一种。

本节将深入讲解 `ExpressionMacro` 的定义、用途、特点，以及其参数、返回值的详细分析，帮助你全面掌握这一类型宏的设计与使用。

> 在阅读本节前，建议先了解基础篇《Swift Macros - 宏之全貌》和协议篇《Swift Macros - 宏之协议》，可以更流畅地理解本节内容。



## 1. `ExpressionMacro` 的定义

Swift 标准库中，`ExpressionMacro` 协议的定义如下：

```
public protocol ExpressionMacro: FreestandingMacro {
  static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> ExprSyntax
}
```

简而言之，**表达式独立宏**就是：

- 触发位置：可以直接单独使用在表达式的位置；
- 作用对象：生成一个新的 `ExprSyntax` 节点；
- 典型场景：封装复杂逻辑、生成动态表达式、优化代码书写。

> 注意：`ExpressionMacro` 必须是 **freestanding** 的，意味着它本身不附加到其他声明上，而是以独立表达式的形式展开。



## 2. `ExpressionMacro` 的作用分析

### 核心作用

- **生成一个完整的表达式节点（`ExprSyntax`）**
- **简化复杂表达式的手写工作**
- **在编译期根据参数动态生成逻辑**

### 常见应用场景

| 场景         | 示例                  | 说明                           |
| ------------ | --------------------- | ------------------------------ |
| 自动封装日志 | `#log("message")`     | 自动插入打印或记录代码         |
| 调试辅助工具 | `#dump(expr)`         | 在调试时自动格式化输出         |
| 表达式改写   | `#optimize(expr)`     | 将通用表达式展开成更高效的版本 |
| 自动计时     | `#measure { work() }` | 计算某段代码的执行时间         |

可以看出，**凡是需要在编译期生成"一个表达式"的场景，都可以使用 `ExpressionMacro` 实现。**



## 3. `ExpressionMacro` 的参数分析

### `of node: some FreestandingMacroExpansionSyntax`

- 代表宏调用语法本身。
- `node` 包含了宏的**名字**、**参数列表**、**调用位置**等信息。
- 通过解析 `node`，可以获取用户传递给宏的具体内容。

> 小提示：常用 `node.argumentList` 来解析参数。

例如，对于调用：

```
#stringify(a + b)
```

则 `node` 会表示整个 `#stringify(a + b)`，你可以从中取出 `a + b` 作为参数。

------

### `in context: some MacroExpansionContext`

- 提供宏展开时的上下文信息。
- 可以用于：
  - 生成唯一名称；
  - 报告诊断错误或警告；
  - 获取节点的源代码位置；
  - 获取当前词法作用域。

> `context` 是你在编写宏时的"万能工具箱"，尤其在需要辅助信息（如生成辅助变量名、给出友好错误提示）时特别重要。



## 4. `ExpressionMacro` 的返回值分析

### 返回类型：`ExprSyntax`

- 代表一个标准的 Swift 表达式；
- 会直接替换调用宏的位置。

举个简单例子，假设你写了一个 `@ExpressionMacro` 宏 `#double(x)`，展开后返回的是：

```
ExprSyntax("(\(x) * 2)")
```

那么用户代码：

```
let value = #double(21)
```

最终编译器看到的是：

```
let value = (21 * 2)
```

注意：**表达式宏必须返回单个表达式，不能直接返回语句、声明或其他结构。**



## 5. `ExpressionMacro` 示例解析

### 示例1：生成字符串化表达式

```
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "McccMacros", type: "StringifyMacro")

public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            throw ASTError("stringify 宏必须至少传入一个参数")
        }
        
        return "(\(literal: argument.description), \(argument))"
    }
}
```

调用：

```
let result = #stringify(a + b)
```

展开后等同于：

```
let result = ("a + b", a + b)
```





### 示例2：加法

定义一个宏 `#sum`，用于在编译期间将一组整数字面量求和，提升运行时性能。

```
@freestanding(expression)
public macro sum(_ values: Int...) -> Int = #externalMacro(module: "McccMacros", type: "SumMacro")


public struct SumMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        
        // 确保传入的是整数字面量，并进行转换
        let values: [Int] = try node.arguments.map { element in
            // 逐个检查每个参数是否是 IntegerLiteralExprSyntax
            guard let literalExpr = element.expression.as(IntegerLiteralExprSyntax.self),
                  let intValue = Int(literalExpr.literal.text) else {
                throw ASTError("All arguments to #sum must be integer literals.")
            }
            return intValue
        }
        
        // 求和
        let sum = values.reduce(0, +)

        // 返回表达式
        return "\(raw: sum)"
    }
}
```

调用：

```
let sums = #sum(1, 2, 3, 4)
```

展开后等同于：

```
let sums = 10
```

