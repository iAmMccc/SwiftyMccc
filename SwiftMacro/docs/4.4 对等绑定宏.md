# Swift Macros - 对等绑定宏

在 Swift 宏体系中，`PeerMacro` 是一种非常灵活且强大的宏协议，专用于生成**与绑定声明处于同一作用域的“对等”声明**，常用于自动扩展同级的变量、函数或类型定义。

本节将深入介绍 `PeerMacro` 的用途、定义、参数结构以及实际示例，帮助你理解它在元编程场景中的独特价值。

> 建议结合《Swift Macros - 宏之全貌》和《Swift Macros - 宏之协议》一并阅读，便于全面理解宏系统的角色协作模型。

## 1. `PeerMacro` 的定义

标准库中 `PeerMacro` 的定义如下：

```
public protocol PeerMacro: AttachedMacro {
  static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax]
}
```

这意味着：

- 它是一个 **附加宏（attached macro）**；
- **不能生成成员，而是生成与附着声明同级的其他声明**；
- 它的返回值为 `[DeclSyntax]`，即可以注入多个顶层/局部声明；
- 使用范围包括变量、函数、类型、扩展等几乎所有可声明位置。

------

## 2. `PeerMacro` 的典型用途

Peer 宏的应用场景非常广泛，常用于：

| 场景             | 示例              | 说明                               |
| ---------------- | ----------------- | ---------------------------------- |
| 自动生成伴生变量 | `@WithWrapper`    | 为属性生成 `_xxx` 存储变量         |
| 自动生成伴生函数 | `@BindAction`     | 为属性自动生成相关行为函数         |
| 生成衍生声明     | `@AutoObservable` | 为属性自动生成观察者包装及通知机制 |
| 声明反射信息     | `@Reflectable`    | 自动生成结构体元信息注册代码       |



特别适合那些**需要基于现有声明生成“相关声明”的情境**，但不适合直接插入原声明体内的场合。

------

## 3. 参数详解

### `of node: AttributeSyntax`

代表宏的语法标记本身，例如 `@WithWrapper`。可用于：

- 宏参数提取；
- 判断具体调用语法。

------

### `attachedTo declaration: some DeclSyntaxProtocol`

- 表示宏附着的原始声明节点；
- 类型是 `DeclSyntaxProtocol`，表示可以是变量、函数、类型等；
- 你可以从中提取关键元信息（如变量名、类型名、访问级别等）。

------

### `in context: some MacroExpansionContext`

上下文对象，常用于：

- 生成唯一名称（防止冲突）；
- 获取源文件路径、位置；
- 报告诊断信息（如参数错误）。

------

## 4. 对等声明的展开位置

Peer 宏生成的声明会插入到**与原声明相同的作用域中**，而**不是类型或函数内部**。

例如：

```
@WithWrapper
var name: String
```

展开后等同于：

```
var name: String
private var _name: String = ""
```

即：`_name` 是 `name` 的“对等声明”，它们在同一语法级别上。

------

## 5. 示例解析

### 示例：为变量自动生成属性

####  用法

```
struct User {
    @DebugEqual
    var userName: String = ""
}

// 展开后
struct User {
    var userName: String = ""
    
    var debug_userName: String {
        "userName = \(userName)"
    }
}
```



#### 实现

```
@attached(peer, names: arbitrary)
public macro DebugEqual() = #externalMacro(module: "McccMacros", type: "DebugEqualMacro")

public struct DebugEqualMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // 把通用声明转成变量声明
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              // 变量可鞥有多个绑定（var a = 1, b = 2）,这里获取第一个。
              let binding = varDecl.bindings.first,
              // 获取变量名，比如”userName“
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text
        else {
            return []
        }


        // 生成新的变量名，如 debug_username
        // raw: 的作用？原样插入这个标识符文本，不会加引号，也不会逃逸。这是写 Swift 宏时推荐的写法之一。
        return [
            """
            var debug_\(raw: identifier): String {
                "\(raw: identifier) = \\(\(raw: identifier))"
            }
            """
        ]
    }
}
```





## 6. 注意事项

- `PeerMacro` 会生成**多个完整的顶层声明节点**，开发者需手动控制命名与作用域；
- 若生成的名称不一致，建议配合 `names:` 标注宏声明；
- 生成类型或函数声明时，需手动处理访问修饰符和重名冲突。



## 7. 总结

`PeerMacro` 是 Swift 宏系统中“横向扩展”的核心工具，它允许开发者在不修改原始声明的前提下添加紧密关联的辅助声明。适用于：

- **分离逻辑与存储**
- **为现有属性扩展行为能力**
- **构建声明式属性模型**

当你需要构建“围绕声明的附属结构”，`PeerMacro` 就是你的利器。
