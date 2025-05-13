# Swift Macros - 宏替换声明体绑定宏

在 Swift 宏体系中，`BodyMacro` 是一种专门用于**替换方法体实现**的宏协议。通过 `BodyMacro`，开发者可以为已有方法、构造器等提供新的实现代码，减少重复代码的书写，并将功能逻辑更加灵活地注入到已有的声明体中。它与其他宏类型（如 `MemberMacro` 或 `AccessorMacro`）的区别在于，它并不生成新的方法声明或属性，而是专注于**方法实现的替换**。

> 本节建议结合《Swift Macros - 宏之全貌》和《Swift Macros - 宏之协议》一并阅读，以便更好地理解宏在声明体中的角色和具体应用。



## 1. `BodyMacro` 的定义

`BodyMacro` 协议允许开发者实现一个宏，该宏的主要功能是**替换现有方法或构造器的实现部分**。它与 `FunctionDeclSyntax` 等声明节点交互，在不修改方法签名的前提下，将方法体替换为新的实现。

> 同时也支持为未实现的方法提供实现。

`BodyMacro` 协议的定义如下：

```
public protocol BodyMacro: AttachedMacro {
  static func expansion(
    of node: AttributeSyntax,
    providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
    in context: some MacroExpansionContext
  ) throws -> [CodeBlockItemSyntax]
}
```

其中参数含义如下：

| 参数               | 说明                                                         |
| ------------------ | ------------------------------------------------------------ |
| `node`             | 当前的宏语法节点，通常用作参数解析用途                       |
| `providingBodyFor` | 要生成实现的声明体，如 `func`, `init`, `var` 等              |
| `context`          | 提供宏展开时的上下文信息，可用于报错、追踪、生成唯一名称等用途 |





## 2. 适用范围与限制

| 语法结构            | 是否支持 `BodyMacro` | 说明                              |
| ------------------- | -------------------- | --------------------------------- |
| `func xxx() {}`     | ✅ 支持               | 替换函数体                        |
| `init() {}`         | ✅ 支持               | 替换构造器体                      |
| `deinit {}`         | ✅ 支持               | 替换析构器体                      |
| `var xxx: Type {}`  | ✅ 支持               | 替换计算属性的 getter/setter 实现 |
| `subscript(...) {}` | ✅ 支持               | 替换下标访问体                    |



------

### **不支持 `@attached(body)` 的声明类型：**

| 语法结构                    | 是否支持 | 原因                             |
| --------------------------- | -------- | -------------------------------- |
| `struct`, `class`           | ❌ 不支持 | 没有方法体可替换                 |
| 存储属性（`var a = 1`）     | ❌ 不支持 | 不是函数体结构，不能被 body 替换 |
| `enum case`, `typealias` 等 | ❌ 不支持 | 没有可替换的声明体               |



## 3. 参数解析

### `of node: AttributeSyntax`

`node` 表示宏的语法标记本身，它包含了宏调用的信息。例如，`@AutoEquatable` 中的 `@AutoEquatable` 会作为 `node`传递给宏处理方法。在宏实现中，开发者可以检查这个节点，解析传递给宏的参数，进而控制宏的行为。

### `attachedTo declaration: some DeclGroupSyntax`

`declaration` 是宏附加到的声明体。它代表了宏应用的上下文。例如，如果宏应用于一个方法或构造器，`declaration` 就会是该方法或构造器的语法节点。开发者可以从中获取类型名、方法签名等信息。

### `in context: some MacroExpansionContext`

`context` 提供了宏展开的上下文信息，包括文件路径、源代码位置等。这对于诊断错误、生成唯一名称以及确保代码的正确性非常重要。



## 4. `BodyMacro` 的返回值

`BodyMacro` 的返回值是一个数组，表示宏生成的 **新的方法体** 或 **实现代码**。这些方法体会替换原有方法的实现。

返回的代码会按照开发者的需求生成新的方法体，这些方法体将替代原始方法的内容，而不会影响方法签名。



## 5. 示例解析

### 示例1：ReplaceWithHello



#### 使用

```
@HelloBody
func greet() {
    print("Original implementation")
}


// 展开后
func greet() {
    print("Hello from macro!")
}
```

#### 宏实现

```
@attached(body)
public macro HelloBody() = #externalMacro(module: "McccMacros", type: "HelloBodyMacro")


public struct HelloBodyMacro: BodyMacro {
    public static func expansion(of node: AttributeSyntax, providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax, in context: some MacroExpansionContext) throws -> [CodeBlockItemSyntax] {
        let log = "print(\"Hello from macro!\")"
        let exitLogItem = CodeBlockItemSyntax(stringLiteral: log)
        return [exitLogItem]
    }
}
```



## 6. 总结

`BodyMacro` 是 Swift 宏体系中非常重要的一类宏，它允许开发者替换现有方法的实现部分。通过 `BodyMacro`，可以动态生成方法体，减少冗余代码，并提高代码的灵活性和可重用性。

- **适用于需要方法体替换的场景**；
- **简化重复逻辑**，提升代码可维护性；
- 可以结合 `AccessorMacro`、`MemberMacro` 等宏类型共同使用，构建更高层次的自动化功能。

未来，开发者可以利用 `BodyMacro` 更加灵活地控制方法实现，为 Swift 项目注入强大的元编程能力。
