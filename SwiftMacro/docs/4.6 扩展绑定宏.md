# Swift Macros - 扩展绑定宏

在 Swift 宏系统中，`ExtensionMacro` 是一种用于**自动生成扩展（`extension`）代码块**的宏协议，适用于为类型生成协议实现、工具方法、便捷功能等**“类型之外”的附加内容**。它是 Swift 中唯一专门用于生成类型扩展的宏角色。



## 1. `ExtensionMacro` 的定义

Swift 标准库中对 `ExtensionMacro` 的定义如下：

```
public protocol ExtensionMacro: AttachedMacro {
  static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax]
}
```

这意味着：

- 它是一种 `@attached(extension)` 宏；
- 必须绑定在结构体、类、枚举等 **类型声明体** 上；
- 它的职责是为该类型生成一个或多个完整的 `extension`；
- 返回的是 `[ExtensionDeclSyntax]`，即多个扩展声明语法。

------

## 2. 使用场景分析

| 应用场景     | 示例             | 说明                                |
| ------------ | ---------------- | ----------------------------------- |
| 自动协议实现 | `@AutoEquatable` | 在扩展中实现 `Equatable` 协议方法   |
| 添加工具方法 | `@Stringifyable` | 为类型扩展一个 `stringify()` 方法   |
| 组合属性行为 | `@Bindable`      | 在扩展中添加辅助函数支持绑定逻辑    |
| 动态特性注入 | `@Observable`    | 在扩展中生成 `Publisher` 等观察能力 |



## 3. 参数详解

### `of node: AttributeSyntax`

代表宏标记语法本身，例如 `@AutoEquatable`，可用于分析传入参数、控制行为。



### attachedTo declaration: some DeclGroupSyntax`

表示宏绑定的**原始类型声明体**，例如：

```
@AutoEquatable
struct User {
    var name: String
}
```

此处 `declaration` 就是整个 `struct User { ... }` 的结构。



### `providingExtensionsOf type: some TypeSyntaxProtocol`

即绑定的类型名（如 `User`），可以用于组装扩展语法，例如：

```
extension \(type.trimmedDescription): Equatable { ... }
```



### `in context: some MacroExpansionContext`

上下文信息，包括定位宏展开位置、生成唯一 ID、发出诊断信息等。

------

## 4. 返回值 `[ExtensionDeclSyntax]`

返回的是多个完整的 `extension` 语法块：

```
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.name == rhs.name
    }
}
```

宏系统将这些扩展插入到类型作用域之外。



## 5. 示例解析

### 示例：自动生成 Equatable 实现

#### 使用

````
@AutoEquatable
struct UserEquatable {
    var name: String = ""
}

// 展开后 
struct UserEquatable {
    var name: String = ""
}
extension UserEquatable: Equatable {
    public static func == (lhs: UserEquatable, rhs: UserEquatable) -> Bool {
        lhs.name == rhs.name
    }
}
````



#### 实现

```
@attached(extension, conformances: Equatable, names: named(==))
public macro AutoEquatable() = #externalMacro(module: "McccMacros", type: "AutoEquatableMacro")

public struct AutoEquatableMacro: ExtensionMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw MacroError.message("@AutoEquatable 目前只支持结构体")
        }
        
        // 获取属性名
        let properties = structDecl.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .flatMap { $0.bindings }
            .compactMap { $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text }
        
        // 拼接对比表达式
        let comparisons = properties.map { "lhs.\($0) == rhs.\($0)" }.joined(separator: " && ")
        
        let ext: ExtensionDeclSyntax = try ExtensionDeclSyntax("""
        extension \(raw: type.trimmedDescription): Equatable {
            public static func == (lhs: \(raw: type.trimmedDescription), rhs: \(raw: type.trimmedDescription)) -> Bool {
                \(raw: comparisons)
            }
        }
        """)
        
        return [ext]
    }
}

```



## 6. 小贴士与进阶建议

- 如果你只需要添加扩展方法（而不希望暴露在类型体内），推荐使用 `ExtensionMacro`；
- 若生成 `static` 方法、协议实现，优先考虑 `ExtensionMacro` 而非 `MemberMacro`；
- 你可以生成多个扩展块（比如将静态方法和实例方法拆分）；
- 不要与 `@attached(member)` 搞混，两者生成的位置与作用域不同。



## 7. 总结

`ExtensionMacro` 是一种强大的宏类型，它让你能够**安全、清晰地将协议实现或工具逻辑注入到类型之外**，而不干扰类型本身的结构声明。

适合用于：

- 自动协议实现；
- 类型功能模块化；
- 属性绑定支持函数等逻辑的注入。

它是宏系统中实现“非侵入式增强”的关键角色。
