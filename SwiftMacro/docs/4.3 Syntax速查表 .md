# Swift Macros - SwiftSyntax 节点速查表

版本：2025.04.27, 欢迎大家维护补充。



## 目录

- [1. 表达式 (ExprSyntax)](#1-表达式-exprsyntax)

- [2. 声明 (DeclSyntax)](#2-声明-declsyntax)

- [3. 语句 (StmtSyntax)](#3-语句-stmtsyntax)

- [4. 类型 (TypeSyntax)](#4-类型-typesyntax)

- [5. 模式 (PatternSyntax)](#5-模式-patternsyntax)

- [6. 属性 (AttributeSyntax)](#6-属性-attributesyntax)

- [7. 宏 (MacroExpansionSyntax)](#7-宏-macroexpansionsyntax)

- [8. 其他常用节点](#8-其他常用节点)

  



## 1. 表达式 (ExprSyntax)

| 名称                          | 描述                      | 快速构造示例                                                 |
| ----------------------------- | ------------------------- | ------------------------------------------------------------ |
| **ArrayExprSyntax**           | 数组表达式 `[a, b, c]`    | `ArrayExprSyntax(elements: [...])`                           |
| **BooleanLiteralExprSyntax**  | 布尔字面量 `true / false` | `BooleanLiteralExprSyntax(value: true)`                      |
| **IntegerLiteralExprSyntax**  | 整数字面量 `123`          | `IntegerLiteralExprSyntax(literal: "123")`                   |
| **FloatLiteralExprSyntax**    | 浮点数字面量 `1.23`       | `FloatLiteralExprSyntax(floatingDigits: "1.23")`             |
| **StringLiteralExprSyntax**   | 字符串字面量 `"abc"`      | `StringLiteralExprSyntax(content: "abc")`                    |
| **IdentifierExprSyntax**      | 标识符 `foo`              | `IdentifierExprSyntax(identifier: .identifier("foo"))`       |
| **FunctionCallExprSyntax**    | 函数调用 `foo(a, b)`      | `FunctionCallExprSyntax(calledExpression: ..., arguments: [...])` |
| **MemberAccessExprSyntax**    | 成员访问 `a.b`            | `MemberAccessExprSyntax(base: ..., name: .identifier("b"))`  |
| **PrefixOperatorExprSyntax**  | 前缀操作 `-a`             | `PrefixOperatorExprSyntax(operator: "-", expression: ...)`   |
| **PostfixOperatorExprSyntax** | 后缀操作 `a!`             | `PostfixOperatorExprSyntax(expression: ...)`                 |
| **NilLiteralExprSyntax**      | 空值 `nil`                | `NilLiteralExprSyntax()`                                     |
| **ClosureExprSyntax**         | 闭包 `{ a in a + 1 }`     | `ClosureExprSyntax(parameters: ..., statements: [...])`      |
| **TupleExprSyntax**           | 元组 `(a, b)`             | `TupleExprSyntax(elements: [...])`                           |
| **TryExprSyntax**             | `try` 表达式              | `TryExprSyntax(expression: ...)`                             |
| **AwaitExprSyntax**           | `await` 表达式            | `AwaitExprSyntax(expression: ...)`                           |
| **AsExprSyntax**              | 类型转换 `as` 表达式      | `AsExprSyntax(expression: ..., type: ...)`                   |
| **IsExprSyntax**              | 类型检查 `is` 表达式      | `IsExprSyntax(expression: ..., type: ...)`                   |
| **TernaryExprSyntax**         | 三目表达式 `a ? b : c`    | `TernaryExprSyntax(condition: ..., thenExpr: ..., elseExpr: ...)` |
| **SequenceExprSyntax**        | 表达式序列 `1 + 2 * 3`    | `SequenceExprSyntax(elements: [...])`                        |

💡 小技巧：

> 中缀表达式（+、-、*）在新版 SwiftSyntax 统统用 `SequenceExprSyntax` 来组合，不再有独立的 BinaryOperator 节点！



## 2. 声明 (DeclSyntax)

| 名称                         | 描述                     | 快速构造示例                                                 |
| ---------------------------- | ------------------------ | ------------------------------------------------------------ |
| **VariableDeclSyntax**       | 变量声明 `let a = 1`     | `VariableDeclSyntax(bindingSpecifier: "let", bindings: [...])` |
| **FunctionDeclSyntax**       | 函数声明 `func foo()`    | `FunctionDeclSyntax(name: "foo", signature: ..., body: ...)` |
| **StructDeclSyntax**         | 结构体 `struct Foo {}`   | `StructDeclSyntax(identifier: "Foo", memberBlock: ...)`      |
| **ClassDeclSyntax**          | 类 `class Foo {}`        | `ClassDeclSyntax(identifier: "Foo", memberBlock: ...)`       |
| **EnumDeclSyntax**           | 枚举 `enum Foo {}`       | `EnumDeclSyntax(identifier: "Foo", memberBlock: ...)`        |
| **ExtensionDeclSyntax**      | 扩展 `extension Foo {}`  | `ExtensionDeclSyntax(extendedType: ..., memberBlock: ...)`   |
| **ProtocolDeclSyntax**       | 协议 `protocol Foo {}`   | `ProtocolDeclSyntax(identifier: "Foo", memberBlock: ...)`    |
| **ImportDeclSyntax**         | 导入 `import Foundation` | `ImportDeclSyntax(path: ["Foundation"])`                     |
| **TypeAliasDeclSyntax**      | 类型别名                 | `TypeAliasDeclSyntax(identifier: "Alias", type: ...)`        |
| **AssociatedTypeDeclSyntax** | 关联类型                 | `AssociatedTypeDeclSyntax(identifier: "T")`                  |
| **MacroDeclSyntax**          | 宏定义                   | `MacroDeclSyntax(identifier: "MyMacro")`                     |
| **OperatorDeclSyntax**       | 自定义操作符             | `OperatorDeclSyntax(operatorKeyword: "operator", name: "+")` |



## 3. 语句 (StmtSyntax)

| 名称                      | 描述              | 快速构造示例                                          |
| ------------------------- | ----------------- | ----------------------------------------------------- |
| **IfStmtSyntax**          | if 语句           | `IfStmtSyntax(conditions: [...], body: ...)`          |
| **GuardStmtSyntax**       | guard 语句        | `GuardStmtSyntax(conditions: [...], body: ...)`       |
| **WhileStmtSyntax**       | while 循环        | `WhileStmtSyntax(conditions: [...], body: ...)`       |
| **RepeatWhileStmtSyntax** | repeat-while 循环 | `RepeatWhileStmtSyntax(body: ..., condition: ...)`    |
| **ForStmtSyntax**         | for 循环          | `ForStmtSyntax(pattern: ..., inExpr: ..., body: ...)` |
| **SwitchStmtSyntax**      | switch 语句       | `SwitchStmtSyntax(expression: ..., cases: [...])`     |
| **ReturnStmtSyntax**      | return 语句       | `ReturnStmtSyntax(expression: ...)`                   |
| **ThrowStmtSyntax**       | throw 异常        | `ThrowStmtSyntax(expression: ...)`                    |
| **BreakStmtSyntax**       | break 跳出        | `BreakStmtSyntax()`                                   |
| **ContinueStmtSyntax**    | continue 继续     | `ContinueStmtSyntax()`                                |
| **DeferStmtSyntax**       | defer 延迟执行    | `DeferStmtSyntax(body: ...)`                          |



## 4. 类型 (TypeSyntax)

| 名称                           | 描述                       | 快速构造示例                                                 |
| ------------------------------ | -------------------------- | ------------------------------------------------------------ |
| **SimpleTypeIdentifierSyntax** | 简单类型 `Int, String`     | `SimpleTypeIdentifierSyntax(name: "Int")`                    |
| **OptionalTypeSyntax**         | 可选类型 `Int?`            | `OptionalTypeSyntax(wrappedType: ...)`                       |
| **ArrayTypeSyntax**            | 数组 `[Int]`               | `ArrayTypeSyntax(elementType: ...)`                          |
| **DictionaryTypeSyntax**       | 字典 `[String: Int]`       | `DictionaryTypeSyntax(keyType: ..., valueType: ...)`         |
| **TupleTypeSyntax**            | 元组 `(Int, String)`       | `TupleTypeSyntax(elements: [...])`                           |
| **FunctionTypeSyntax**         | 函数类型 `(Int) -> String` | `FunctionTypeSyntax(parameters: [...], returnType: ...)`     |
| **AttributedTypeSyntax**       | 属性修饰类型 `@Sendable`   | `AttributedTypeSyntax(attributes: [...], baseType: ...)`     |
| **SomeTypeSyntax**             | `some` 类型                | `SomeTypeSyntax(baseType: ...)`                              |
| **MetatypeTypeSyntax**         | `.Type` `.Protocol`        | `MetatypeTypeSyntax(baseType: ..., period: ".", typeOrProtocol: ...)` |
| **ExistentialTypeSyntax**      | `any` 类型                 | `ExistentialTypeSyntax(type: ...)`                           |



## 5. 模式 (PatternSyntax)

| 名称                          | 描述              | 快速构造示例                                                 |
| ----------------------------- | ----------------- | ------------------------------------------------------------ |
| **IdentifierPatternSyntax**   | 标识符模式        | `IdentifierPatternSyntax(identifier: .identifier("name"))`   |
| **TuplePatternSyntax**        | 元组模式 `(x, y)` | `TuplePatternSyntax(elements: [...])`                        |
| **WildcardPatternSyntax**     | 通配 `_` 匹配     | `WildcardPatternSyntax()`                                    |
| **ValueBindingPatternSyntax** | let/var 绑定      | `ValueBindingPatternSyntax(bindingSpecifier: "let", pattern: ...)` |
| **ExpressionPatternSyntax**   | 表达式模式        | `ExpressionPatternSyntax(expression: ...)`                   |



## 6. 属性 (AttributeSyntax)

| 名称                      | 描述       | 快速构造示例                                        |
| ------------------------- | ---------- | --------------------------------------------------- |
| **AttributeSyntax**       | 标准属性   | `AttributeSyntax(attributeName: "available")`       |
| **CustomAttributeSyntax** | 自定义属性 | `CustomAttributeSyntax(attributeName: "MyWrapper")` |



## 7. 宏 (MacroExpansionSyntax)

| 名称                                 | 描述                              | 快速构造示例                                                 |
| ------------------------------------ | --------------------------------- | ------------------------------------------------------------ |
| **FreestandingMacroExpansionSyntax** | 表达式独立宏 `#stringify(x)`      | `FreestandingMacroExpansionSyntax(macroName: "stringify", arguments: [...])` |
| **AttributeMacroExpansionSyntax**    | 属性宏 `@MyMacro`                 | `AttributeMacroExpansionSyntax(macroName: "MyMacro", arguments: [...])` |
| **AccessorMacroExpansionSyntax**     | Accessor 宏（自动 getter/setter） | `AccessorMacroExpansionSyntax(macroName: "MyAccessor")`      |



## 8. 其他常用节点

| 名称                           | 描述                             | 快速构造示例                                  |
| ------------------------------ | -------------------------------- | --------------------------------------------- |
| **CodeBlockSyntax**            | 代码块 `{}`                      | `CodeBlockSyntax(statements: [...])`          |
| **MemberDeclListSyntax**       | 成员列表                         | `MemberDeclListSyntax(members: [...])`        |
| **ParameterClauseSyntax**      | 参数列表 `(x: Int)`              | `ParameterClauseSyntax(parameters: [...])`    |
| **TupleExprElementListSyntax** | 元组元素列表                     | `TupleExprElementListSyntax(elements: [...])` |
| **TokenSyntax**                | 单个 Token（符号/关键字/标识符） | `.identifier("foo")`, `.keyword(.func)`       |
| **SourceFileSyntax**           | 整个 Swift 文件                  | `SourceFileSyntax(statements: [...])`         |
