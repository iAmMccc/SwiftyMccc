# Swift Macros - 成员绑定宏

在 Swift 宏体系中，`MemberMacro` 是一种具有极高实用价值的宏协议，它专门用于在**类型声明内部**生成新的成员（如属性、方法、构造器等）。这种宏是典型的**附加宏（attached macro）**，能够大幅减少重复成员定义的样板代码，提高类型声明的表达能力。

> 本节建议结合《Swift Macros - 宏之全貌》和《Swift Macros - 宏之协议》一并阅读，以便更好地理解宏在声明结构中的角色。



## 1. `MemberMacro` 的定义

在 Swift 标准库中，`MemberMacro` 协议的定义如下：

```
public protocol MemberMacro: AttachedMacro {
  static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingMembersOf type: some TypeSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax]
}
```

这意味着：

- 它是一个**attached** 宏；
- 必须绑定在结构体、类、枚举等**声明体（DeclGroup）**上；
- 它的职责是**为类型注入新的成员声明**；
- 返回值是 `[DeclSyntax]`，表示多个新增的声明。



## 2. 使用场景分析

`MemberMacro` 适用于所有**需要自动生成类型成员**的场景，特别是：

| 场景             | 示例             | 说明                                |
| ---------------- | ---------------- | ----------------------------------- |
| 自动生成协议实现 | `@AutoEquatable` | 自动实现 `Equatable` 的 `==` 方法   |
| 自动添加辅助属性 | `@Observe`       | 为属性生成 `_xxx` 存储与监控 getter |
| 自动实现构造器   | `@AutoInit`      | 基于属性自动生成初始化函数          |
| 自动生成默认值   | `@WithDefaults`  | 为成员属性自动附加默认实现          |



------

## 3. 参数详解

### `of node: AttributeSyntax`

代表宏的语法标记本身，例如 `@AutoEquatable`。

你可以：

- 检查传参；
- 根据参数控制宏行为。

------

### `attachedTo declaration: some DeclGroupSyntax`

代表宏附着的声明体，例如：

```
@AutoEquatable
struct User {
    let id: Int
    let name: String
}
```

这里的 `declaration` 是整个 `struct User { ... }` 的语法树。你可以从中提取类型名、属性列表等内容。

------

### `providingMembersOf type: some TypeSyntaxProtocol`

表示当前类型的名称语法节点，如 `User`。

它可用于：

- 生成扩展成员时保留类型信息；
- 用于构建唯一名称（如 `_User_Equatable_impl`）；

------

### `in context: some MacroExpansionContext`

上下文信息，常用于：

- 生成唯一标识名；
- 记录宏展开位置；
- 报告错误、警告等诊断信息。

------

## 4. 返回值 `[DeclSyntax]`

该宏返回一组新的声明成员，会**直接插入到类型内部**。

这些成员可以是：

- 属性（`VariableDeclSyntax`）
- 方法（`FunctionDeclSyntax`）
- 构造器（`InitializerDeclSyntax`）
- 嵌套类型（`StructDeclSyntax` / `EnumDeclSyntax` 等）

------

## 5. 示例解析

### 示例1：自动实现 Equatable

```
@attached(member)
public macro AutoEquatable() = #externalMacro(module: "McccMacros", type: "AutoEquatableMacro")

public struct AutoEquatableMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingMembersOf type: some TypeSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // 获取所有属性名
        let props = declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .flatMap { $0.bindings.map { $0.pattern.description } }

        // 生成等号方法
        let comparison = props.map { "lhs.\($0) == rhs.\($0)" }.joined(separator: " && ")
        let equalsFunc = """
        static func ==(lhs: \(type), rhs: \(type)) -> Bool {
            return \(comparison)
        }
        """

        return [DeclSyntax(stringLiteral: equalsFunc)]
    }
}
```

使用方式：

```
@AutoEquatable
struct User {
    let id: Int
    let name: String
}
```

宏展开后会在结构体内部追加：

```
static func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}
```

------

### 示例2：为属性生成监控存储变量

```
swift


复制编辑
@attached(member, names: prefixed(_))
public macro Observe() = #externalMacro(module: "McccMacros", type: "ObserveMacro")

public struct ObserveMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingMembersOf type: some TypeSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              let varName = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
              let varType = binding.typeAnnotation?.type.description else {
            throw MacroExpansionError("Observe 只能用于单个具名变量")
        }

        let backingName = "_" + varName
        let storage = "private var \(backingName): \(varType)"
        let proxy = """
        var \(varName): \(varType) {
            get { \(backingName) }
            set {
                print("🔍 \(varName) changed from \\(\(backingName)) to \\(newValue)")
                \(backingName) = newValue
            }
        }
        """

        return [
            DeclSyntax(stringLiteral: storage),
            DeclSyntax(stringLiteral: proxy)
        ]
    }
}
```

使用方式：

```
swift


复制编辑
struct Settings {
    @Observe var volume: Int = 5
}
```

宏展开后等效于：

```
swift


复制编辑
private var _volume: Int = 5

var volume: Int {
    get { _volume }
    set {
        print("🔍 volume changed from \(_volume) to \(newValue)")
        _volume = newValue
    }
}
```

------

## 6. 总结

`MemberMacro` 是 Swift 宏体系中连接语法结构与声明注入的关键机制。它让开发者能够根据类型结构自动生成成员，真正实现：

- 结构自动扩展；
- 代码样板消除；
- 类型驱动式逻辑推导。

未来你可以将它与 `AccessorMacro`、`PeerMacro` 等组合使用，构建更高层次的声明式元编程能力。
