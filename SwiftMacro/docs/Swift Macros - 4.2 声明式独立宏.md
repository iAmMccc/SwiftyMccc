# Swift Macros - 声明式独立宏

在 Swift 宏体系中，`DeclarationMacro` 是一种用途广泛的角色，专门用于**生成声明级别的代码**，如变量、函数、结构体等。它同样属于**自由悬挂宏（freestanding macro）\**的一种，但与 `ExpressionMacro` 不同，它不会展开为表达式，而是生成一个或多个\**完整的声明语法节点（DeclSyntax）**。

本节将深入讲解 `DeclarationMacro` 的定义、用途、特点，以及其参数、返回值的结构分析，并通过示例帮助你掌握其使用方式。

> 建议先阅读基础篇《Swift Macros - 宏之全貌》与协议篇《Swift Macros - 宏之协议》，以更好地理解本节内容。



## 1. `DeclarationMacro` 的定义

`DeclarationMacro` 协议由标准库提供，其定义如下：

```
public protocol DeclarationMacro: FreestandingMacro {
  static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax]
}
```

简而言之，**声明式独立宏**具备以下特性：

- **触发位置**：可直接作为独立语句出现在作用域中；
- **作用对象**：生成一个或多个完整的声明（如变量声明、函数定义）；
- **返回类型**：必须是 `[DeclSyntax]` 数组，支持生成多个声明。



## 2. `DeclarationMacro` 的作用分析

### 核心作用

- **在当前作用域中插入新的声明**；
- **通过参数驱动，动态生成声明代码**；
- **避免重复书写、提升可维护性与一致性**。

### 常见应用场景

| 场景             | 示例                        | 说明                                 |
| ---------------- | --------------------------- | ------------------------------------ |
| 自动生成函数     | `#makeDebugFunction("log")` | 生成具名的调试函数                   |
| 统一封装声明     | `#injectCommonImports()`    | 插入一批通用 import 语句             |
| 构建配置项常量集 | `#defineKeys("id", "name")` | 根据传入字符串列表定义常量           |
| 静态信息注入     | `#generateBuildInfo()`      | 生成包含版本、时间、构建号的静态变量 |



## 3. `DeclarationMacro` 的参数解析

与 `ExpressionMacro` 一样，`DeclarationMacro` 的 `expansion` 函数也接受以下两个参数：

### `of node: some FreestandingMacroExpansionSyntax`

- 代表宏本身的调用语法；
- 可通过 `.argumentList` 访问用户传入的参数列表；
- 每个参数都是一个 `LabeledExprSyntax` 类型，可以进一步分析是否为字面量、表达式等。

### `in context: some MacroExpansionContext`

- 提供宏展开的上下文信息；
- 可用于生成唯一名称、获取调用源位置、报错诊断等；
- 与 `ExpressionMacro` 中的 `context` 功能完全一致。



## 4. `DeclarationMacro` 的返回值

### 返回类型：`[DeclSyntax]`

- 宏必须返回一个 **声明语法节点数组**；
- 每个元素都必须是合法的声明类型（例如 `VariableDeclSyntax`、`FunctionDeclSyntax`、`StructDeclSyntax`等）；
- 所有返回的声明会被直接插入到调用宏的位置。

```
return [
  DeclSyntax("let name = \"Mccc\""),
  DeclSyntax("let age = 30")
]
```

调用：

```
#defineProfile()
```

展开：

```
let name = "Mccc"
let age = 30
```

------

## 5. `DeclarationMacro` 示例解析

### 示例1：定义常量

定义一个宏 `#defineKeys`，接受一组字符串参数，并为每个参数生成一个常量：

```
@freestanding(declaration)
public macro defineKeys(_ keys: String...) = #externalMacro(module: "McccMacros", type: "DefineKeysMacro")
```

实现：

```
public struct DefineKeysMacro: DeclarationMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let identifiers: [String] = try node.arguments.map {
      guard let stringLiteral = $0.expression.as(StringLiteralExprSyntax.self),
            let key = stringLiteral.segments.first?.description.trimmingCharacters(in: .init(charactersIn: "\"")) else {
        throw ASTError("#defineKeys 参数必须为字符串字面量")
      }
      return key
    }

    return identifiers.map { name in
      DeclSyntax("let \(raw: name) = \"\(raw: name)\"")
    }
  }
}
```

调用：

```
#defineKeys("id", "name", "email")
```

展开后：

```
let id = "id"
let name = "name"
let email = "email"
```

------

### 示例2：生成通用 Imports

宏定义：

```
@freestanding(declaration)
public macro commonImports() = #externalMacro(module: "McccMacros", type: "ImportMacro")
```

实现：

```
public struct ImportMacro: DeclarationMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    return [
      DeclSyntax("import Foundation"),
      DeclSyntax("import SwiftUI"),
      DeclSyntax("import Combine")
    ]
  }
}
```

调用：

```
#commonImports()
```

展开：

```
import Foundation
import SwiftUI
import Combine
```

------

## 总结

- `DeclarationMacro` 是声明级别的独立宏，适合生成变量、函数等完整声明；
- 它通过 `expansion` 返回 `[DeclSyntax]`，一次可插入多条声明；
- 场景广泛，尤其适合模板生成、批量定义、封装声明逻辑等；
- 相比表达式宏，它更接近“代码插入器”的角色。
