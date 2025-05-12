# Swift Macros - 成员属性绑定

Swift 宏系统中，`MemberAttributeMacro` 是一种用于**为类型中的成员声明自动附加属性标记**的宏。它适用于需要为多个成员统一附加如 `@available`、`@objc`、`@discardableResult` 等语义的场景。

------

## 1. 定义与原理

`MemberAttributeMacro` 的定义如下：

```
public protocol MemberAttributeMacro: AttachedMacro {
  static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingAttributesFor member: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AttributeSyntax]
}
```

这说明它具备以下特征：

| 项目     | 说明                                     |
| -------- | ---------------------------------------- |
| 类型     | `attached` 宏                            |
| 作用范围 | 附加在结构体、类、枚举等类型声明上       |
| 作用目标 | 对类型内部的每个成员声明自动附加额外属性 |
| 返回值   | `[AttributeSyntax]`，即附加的属性标记    |



## 2. 使用场景

| 场景                          | 示例宏          | 功能描述                                 |
| ----------------------------- | --------------- | ---------------------------------------- |
| 批量附加可用性标记            | `@iOSOnly`      | 为所有成员添加 `@available(iOS 13.0, *)` |
| 自动添加 `@discardableResult` | `@AllowDiscard` | 避免函数返回值未使用时警告               |
| 自动标记为 `@objc`            | `@ExposeToObjC` | 支持 Objective-C 可见性                  |



## 3. 参数详解

| 参数                                | 用途                                  |
| ----------------------------------- | ------------------------------------- |
| `of node: AttributeSyntax`          | 宏本身语法节点                        |
| `attachedTo declaration`            | 宏所附加的类型体（struct/class/enum） |
| `providingAttributesFor member`     | 被作用的每一个成员（方法、属性等）    |
| `in context: MacroExpansionContext` | 用于生成诊断、唯一名等辅助功能        |



你可以在 `member` 中判断成员类型、名称，并进行有选择性地附加属性。



## 4. 示例

### 为成员批量添加 `@available` 标记

#### 宏实现

```
@attached(memberAttribute)
public macro iOSOnly() = #externalMacro(module: "McccMacros", type: "iOSOnlyMacro")

public struct iOSOnlyMacro: MemberAttributeMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        return [
            try AttributeSyntax("@available(iOS 13.0, *)")
        ]
    }
}
```

#### 使用示例

```
@iOSOnly
struct LegacyAPI {
    func oldMethod() { }
    var status: String { "ok" }
}

// 展开效果
struct LegacyAPI {
    @available(iOS 13.0, *)
    func oldMethod() { }

    @available(iOS 13.0, *)
    var status: String { "ok" }
}
```



### 为成员添加@UserDefalut

在 **访问器绑定宏** 中我们提供了 `@UserDefalut`, 我们可以通过 **成员属性绑定宏**  给属性都添加上。



#### 使用

```
@UserDefaultsProperty
struct SettingsProperty {
    var username: String?
    var age: Int
}

// 展开


struct SettingsProperty {
    @UserDefault
    var username: String?
    @UserDefault
    var age: Int
}
```



#### 实现

```
@attached(memberAttribute)
public macro UserDefaultsProperty() = #externalMacro(module: "McccMacros", type: "UserDefaultMacro")

extension UserDefaultMacro: MemberAttributeMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {

         // 通过字符串 "@UserDefault" 构造了一个 AttributeSyntax 实例（语法树中表示 @UserDefault 的对象）。
         // AttributeSyntax 是 SwiftSyntax 提供的一个类型，用来描述“一个属性修饰器”。
         // 因为手写 AttributeSyntax 很麻烦，要写一堆 AST 结构，但 Swift 宏允许我们偷懒，支持用字符串解析成 AST 片段，这个字符串只要符合 Swift 语法就可以。
         // 因为 MemberAttributeMacro 的返回类型是 [AttributeSyntax]，也就是：可以对一个成员添加 多个 宏属性.
        
        // `.init(stringLiteral: "@UserDefault")`
        // 等同于：
        // `AttributeSyntax(stringLiteral: "@UserDefault")`
        return [.init(stringLiteral: "@UserDefault")]
    }
}
```





## 5. 条件属性附加

例如，我们可以只为方法名以 `"old"` 开头的函数添加 `@available`：

```
if let funcDecl = member.as(FunctionDeclSyntax.self),
   funcDecl.identifier.text.hasPrefix("old") {
    return [try AttributeSyntax("@available(iOS 13.0, *)")]
}
return []
```



## 6. 限制与注意事项

| 限制           | 说明                             |
| -------------- | -------------------------------- |
| 只能附加属性   | 不能添加新方法或修改函数体       |
| 不影响嵌套类型 | 仅作用于第一层成员               |
| 与手动属性并存 | 可以手动添加属性，宏添加不会冲突 |



## 7. 总结

`MemberAttributeMacro` 是一种细粒度的声明增强工具，非常适合用于：

- 给成员自动附加语义注解；
- 降低重复写标记属性的成本；
- 实现统一标记、跨平台适配等能力。

它的设计理念是“轻量级修饰”，通过规则生成统一的标记代码，是一种常见的声明式元编程方式。
