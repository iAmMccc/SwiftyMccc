# Swift Macros - 宏之协议

Swift 宏的强大能力，源于一套精心设计的协议体系。这套协议定义了：

- **基本行为规范**：所有宏必须遵循的标准接口
- **适用场景划分**：不同类型宏的专用能力边界
- **编译器交互方式**：宏展开过程中的通信机制

宏的本质，就是**实现对应协议方法**。
与日常编程不同，宏协议方法的返回值通常不是“结果”，而是**语法树节点**（如 `ExprSyntax`、`DeclSyntax` 等），代表最终插入到源代码中的结构。

在上一篇《Swift Macros - 宏之全貌》中，我们已全面了解了各宏协议及其作用。
本节将聚焦于它们的**共性特征**，为后续深入理解每个协议细节打好基础。

> 建议在阅读本节前，快速回顾上一篇中“宏角色协议详解”的内容，因为本文基于该部分进行提炼总结。



## Swift 宏协议的共性特征

虽然宏协议种类繁多，但其方法签名和调用方式高度统一，主要体现为以下几点：

| 编号 | 特征                       | 说明                                                         |
| ---- | -------------------------- | ------------------------------------------------------------ |
| 1    | 方法统一命名为 `expansion` | 所有宏协议通过 `static func expansion(...)` 实现展开逻辑。   |
| 2    | 支持 `throws` 异常机制     | 展开过程中可抛出错误，便于中止宏生成并提供诊断信息。         |
| 3    | 必带 `context` 参数        | 提供编译期上下文信息，用于辅助诊断、命名、位置定位等操作。   |
| 4    | 必带 `node` 参数           | 代表了**宏的调用现场**：也就是**源码中**触发宏展开的那段语法结构。 |
| 5    | 输入输出皆为 `Syntax` 类型 | 完全基于语法树节点操作，确保结构完整、可分析。               |
| 6    | 仅运行于静态上下文         | 无法访问运行时数据，所有逻辑基于源码与类型系统。             |
| 7    | 每种宏返回类型严格固定     | 如 `ExprSyntax`、`DeclSyntax`，类型明确，不可混用。          |





## 1. 统一的 `expansion` 方法设计

所有宏协议都通过 `static func expansion(...)` 实现核心逻辑，这种一致性带来以下优势：

- **降低认知成本**：开发者只需掌握一个核心方法
- **提升代码可读性**：明确表达"展开"语义
- **简化工具链支持**：编译器可以统一处理宏展开流程

```
// 各协议方法签名示例
protocol ExpressionMacro {
    static func expansion(...) throws -> ExprSyntax
}

protocol DeclarationMacro {
    static func expansion(...) throws -> [DeclSyntax]
}
```



## 2. 全面的错误处理机制

在所有宏协议方法  `expansion` 方法都支持 `throws`。允许在语义检查不通过时抛出异常，以终止代码生成并提示开发者。

![错误提示](../images/错误提示.png)

只需要在适当的地方抛出异常，你可以自行编辑异常的message，以便使用者更好的理解该异常。

```
public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        throw ASTError("错误提示: the macro does not have any arguments")
    }
}

struct ASTError: CustomStringConvertible, Error {
    let text: String
    init(_ text: String) { self.text = text }
    var description: String { text }
}
```





## 3. `context` 参数的关键作用

每个宏的 `expansion` 方法，都会接收一个 `context` 参数，类型为 `some MacroExpansionContext`。
它是宏与编译器交互的桥梁，拥有多种重要功能：

```
public protocol MacroExpansionContext: AnyObject {
  func makeUniqueName(_ name: String) -> TokenSyntax
  func diagnose(_ diagnostic: Diagnostic)
  func location(of node: some SyntaxProtocol, at position: PositionInSyntaxNode, filePathMode: SourceLocationFilePathMode) -> AbstractSourceLocation?
  var lexicalContext: [Syntax] { get }
}
```

它是宏与编译器对话的桥梁，是实现任何非纯粹语法转换时不可或缺的工具。以下是 Swift 宏系统中 `MacroExpansionContext` 协议四个核心成员的作用详解，按重要性分层说明：

### 3.1 **`makeUniqueName(_:)` → `TokenSyntax`**

#### 核心作用：安全生成唯一标识符

- 自动生成全局唯一、且易读的临时名称；
- 返回 `TokenSyntax`，可直接插入生成代码。

```
// 使用场景：生成临时变量
let uniqueVar = context.makeUniqueName("result")
// 输出结果可能是 `result_7FE3A1` 之类的唯一名称
```



### 3.2 **`diagnose(_:)`**

#### 核心作用：编译时错误报告系统

- **多级诊断**：支持 **error** / **warning** / **note** 三种严重级别
- **精准定位**：关联到具体语法节点（如高亮错误位置）
- **修复建议**：可附加自动修复方案（FixIt）

```
public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
    
        context.diagnose(Diagnostic(node: node, message: MacroDiagnostic.deprecatedUsage))
        throw ASTError("错误提示: xxxxxx")
    }
}
```

某些宏过期时，可以通过 `context.diagnose(...)` 给于警告提醒。

![警告提醒](../images/警告提醒.png)

> ##### DiagnosticMessage
>
> 这里的 `Diagnostic.message` 需要一个实现 `DiagnosticMessage` 协议的实例。
>
> ```
> public protocol DiagnosticMessage: Sendable {
>   /// The diagnostic message that should be displayed in the client.
>   var message: String { get }
> 
>   /// See ``MessageID``.
>   var diagnosticID: MessageID { get }
> 
>   var severity: DiagnosticSeverity { get }
> }
> ```
>
> * `message`：诊断信息的信息
>
> * `diagnosticID`：诊断 ID
>
> * `severity`：诊断严重程度
>
>   ```
>   public enum DiagnosticSeverity {
>       case error    // 编译错误，阻止构建。
>       case warning  // 编译警告，不阻止构建。
>       case note     // 提示信息，常用于补充说明。
>   }
>   ```
>

### 3.3 `location(of:at:filePathMode:)`：获取源码位置

#### 核心作用：获取精准源代码位置

```
public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
) throws -> ExprSyntax {   
    let loc = context.location(of: node, at: .afterLeadingTrivia, filePathMode: .fileID )
    ......
}
```

` func location(  of node: some SyntaxProtocol,  at position: PositionInSyntaxNode,  filePathMode: SourceLocationFilePathMode ) -> AbstractSourceLocation?`



>  从 **AbstractSourceLocation** 返回值中，可以获取以下信息：
>
> ```
> public struct AbstractSourceLocation: Sendable {
>   /// 文件位置
>   public let file: ExprSyntax
> 
>   /// 行的位置
>   public let line: ExprSyntax
> 
>   /// 字符位置
>   public let column: ExprSyntax
> ```

- **四种定位模式**：

  ```
  enum PositionInSyntaxNode {
      case beforeLeadingTrivia  // 包含注释/空格
      case afterLeadingTrivia   // 实际代码起始处
      case beforeTrailingTrivia // 实际代码结束处
      case afterTrailingTrivia  // 包含尾部注释
  }
  ```

- **路径显示控制**：

  - `.fileID` → `"ModuleName/FileName.swift"`（安全格式）
  - `.filePath` → 完整系统路径（调试用）

### 3.4 `lexicalContext`：词法作用域追踪

#### 核心作用：获取词法作用域上下文

以数组形式，记录从当前节点向外的层层包裹结构；

经过脱敏处理（如移除函数体、清空成员列表）。

```
// 检查是否在类方法中
let isInClassMethod = context.lexicalContext.contains { 
    $0.is(FunctionDeclSyntax.self) && 
    $0.parent?.is(ClassDeclSyntax.self) != nil
}
```



## 4. `node` 参数的核心作用

每个宏的 `expansion` 方法，除了 `context` 外，还会接收一个 `node` 参数，类型通常是 `some SyntaxProtocol`（如 `FreestandingMacroExpansionSyntax`、`AttributeSyntax` 等）。

它代表了**宏的调用现场**——也就是**源码中**触发宏展开的那段语法结构。

> 简单理解：`node` 就是“#宏名(...)”或“@宏名” 这一整段的解析结果。

以自由宏为例，`node` 类型通常是 `FreestandingMacroExpansionSyntax`，它包含了调用宏时的所有组成元素：

```
public protocol FreestandingMacroExpansionSyntax: SyntaxProtocol {
  var pound: TokenSyntax { get set }  // "#" 符号
  var macroName: TokenSyntax { get set }  // 宏名
  var genericArgumentClause: GenericArgumentClauseSyntax? { get set } // 泛型参数
  var leftParen: TokenSyntax? { get set }  // 左括号 "("
  var arguments: LabeledExprListSyntax { get set }  // 参数列表
  var rightParen: TokenSyntax? { get set }  // 右括号 ")"
  var trailingClosure: ClosureExprSyntax? { get set }  // 尾随闭包
  var additionalTrailingClosures: MultipleTrailingClosureElementListSyntax { get set }  // 多个尾随闭包
}
```

### 具体能做什么？

通过解析 `node`，可以在宏内部获取宏调用时传递的信息，从而进行自定义生成：

- **提取参数**：解析 `arguments`，得到用户传入的内容；
- **读取宏名**：从 `macroName` 获取调用者使用的名字（有些宏支持重名扩展）；
- **处理泛型**：如果 `genericArgumentClause` 存在，可以根据泛型参数生成不同代码；
- **解析闭包**：支持分析和利用用户传递的尾随闭包；
- **实现自定义行为**：比如根据传入参数数量、类型、值，决定生成什么样的代码。

### 示例

```
public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
) throws -> ExprSyntax {
    // 取出第一个参数
    guard let firstArg = node.arguments.first?.expression else {
        throw ASTError("缺少参数")
    }
    
    // 根据参数生成不同表达式
    return "print(\(firstArg))"
}
```

> 小结：
> `node` = 宏调用时的**源码快照**，
> `context` = **辅助功能工具箱**。

两者结合使用，才能让宏既能理解调用现场，又能灵活地生成对应代码。





## 5. 输入输出皆基于 `Syntax` 节点

Swift 宏以结构化 AST（抽象语法树）为基础，输入输出都基于 `SwiftSyntax` 类型，例如：

- 输入：`AttributeSyntax`、`FreestandingMacroExpansionSyntax`、`DeclSyntaxProtocol`；
- 输出：`ExprSyntax`、`[DeclSyntax]`、`[AccessorDeclSyntax]` 等。

这种设计保证了宏生成的代码具备：

- 与手写代码一致的结构完整性；
- 良好的可分析性与可重构性；
- 自动享受 IDE 语法高亮、错误检测等支持。

> Swift 宏不是简单拼接字符串，而是真正生成 AST。



## 6. 宏仅运行于静态上下文

Swift 宏只能在编译期运行，这意味着它们不能访问运行时信息、全局变量、实例状态或外部服务。所有宏的行为都必须建立在静态源代码、类型系统和语法结构之上。

这为宏提供了如下保证：

- **可预测性**：展开结果与运行环境无关，确保行为一致；
- **可分析性**：工具链可以分析宏行为，进行语法检查与补全；
- **可维护性**：宏代码不会隐藏运行时副作用，有利于重构和测试。

开发者在编写宏时，也应遵循“编译时思维”，尽可能将逻辑转化为静态分析与结构转换。



## 7. 每种宏的返回类型固定

每个宏协议都明确限定了其 `expansion` 方法的返回类型，这种限制具有强约束力：

| 宏协议                 | 返回类型                |
| ---------------------- | ----------------------- |
| `ExpressionMacro`      | `ExprSyntax`            |
| `DeclarationMacro`     | `[DeclSyntax]`          |
| `MemberMacro`          | `[DeclSyntax]`          |
| `AccessorMacro`        | `[AccessorDeclSyntax]`  |
| `BodyMacro`            | `[CodeBlockItemSyntax]` |
| `ExtensionMacro`       | `[ExtensionDeclSyntax]` |
| `MemberAttributeMacro` | `[AttributeSyntax]`     |

这种强约束带来：

- 类型安全；
- 生成结果合法；
- 避免不同宏角色混淆使用。

比如：成员宏只能生成成员声明，不能直接生成表达式或代码块。

