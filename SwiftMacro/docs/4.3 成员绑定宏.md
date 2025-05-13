# Swift Macros - 成员绑定宏

在 Swift 中，结构体和类的声明体（即 `{}` 中的内容）常常会包含许多重复或模式化的成员声明。为了提升开发效率并避免重复劳动，Swift 宏系统提供了一种用于自动生成成员声明的宏协议：`MemberMacro`。在 Swift 宏体系中，`MemberMacro` 是一种具有极高实用价值的宏协议，它专门用于在**类型声明内部**生成新的成员（如属性、方法、构造器等）。这种宏是典型的**附加宏（attached macro）**，能够大幅减少重复成员定义的样板代码，提高类型声明的表达能力。

> 本节建议结合《Swift Macros - 宏之全貌》和《Swift Macros - 宏之协议》一并阅读，以便更好地理解宏在声明结构中的角色。



## 1. `MemberMacro` 的定义

`MemberMacro` 是一种 **附加宏协议**，用于将成员注入至类型声明体中。它只作用于结构体、类、actor、枚举这些具备声明体的类型定义，不能用于函数、变量或其他非类型声明。

它在 Swift 中的声明为：

```
public protocol MemberMacro: AttachedMacro {
  static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax]
}
```

| 参数名        | 类型                         | 说明                                           |
| ------------- | ---------------------------- | ---------------------------------------------- |
| `node`        | `AttributeSyntax`            | 当前宏调用的语法节点（包含宏名与参数）         |
| `declaration` | `some DeclGroupSyntax`       | 宏所附加的类型声明体，例如 `struct` 或 `class` |
| `context`     | `some MacroExpansionContext` | 提供诊断、源文件信息等上下文能力               |

你可以通过 `MacroExpansionContext` 提供的 `diagnose()` 方法抛出编译错误，也可以用 `context.location(of:)` 进行精确定位。

返回值为 `[DeclSyntax]`，表示你希望宏注入的成员声明数组。例如你可以生成变量、函数、嵌套类型等内容：

```
return [
  "var id: String = UUID().uuidString",
  "func reset() { self.id = UUID().uuidString }"
]
.map { DeclSyntax(stringLiteral: $0) }
```

💡 注意：返回的成员会插入到原始类型声明体中，因此要避免命名冲突。

> ### 📌 使用限制
>
> - 只可用于具有声明体（`{}`）的类型定义：`struct`、`class`、`enum`、`actor`
> - 不可用于 `func`、`var`、`extension` 等其他声明
> - 若注入的成员包含具名声明（如 `var id`），必须在宏声明中通过 `names:` 显式声明，以避免命名未覆盖错误（`Declaration name 'id' is not covered by macro`）



## 2. 使用场景分析

`MemberMacro` 适用于所有**需要自动生成类型成员**的场景，特别是：

| 场景             | 示例             | 说明                                |
| ---------------- | ---------------- | ----------------------------------- |
| 自动生成协议实现 | `@AutoEquatable` | 自动实现 `Equatable` 的 `==` 方法   |
| 自动添加辅助属性 | `@Observe`       | 为属性生成 `_xxx` 存储与监控 getter |
| 自动实现构造器   | `@AutoInit`      | 基于属性自动生成初始化函数          |
| 自动生成默认值   | `@WithDefaults`  | 为成员属性自动附加默认实现          |



## 3. 示例解析

### 示例1：AddID

#### 用法：

```
@AddID
struct User {
  var name: String
}

// 等价于
struct User {
  var name: String
  var id = UUID().uuidString
}
```

#### 实现：

```
@attached(member, names: named(id))
public macro AddID() = #externalMacro(
  module: "MyMacroImpl",
  type: "AddIDMacro"
)

public struct AddIDMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    return [
      "var id = UUID().uuidString"
    ].map { DeclSyntax(stringLiteral: $0) }
  }
}
```

> 如果不明确名称
>
> ```
> @attached(member)
> ```
>
> 运行会报错：
>
> ```
> ❗️Declaration name 'id' is not covered by macro 'AddID'
> ```
>
> 说明你使用的是 `@attached(member)` 宏，但**没有在宏声明中说明要生成的成员名字**，Swift 宏系统默认是不允许你偷偷“注入”成员名的，除非你通过 `names:` 明确标注。



### 示例2：CodableSubclass

对于继承自某个父类的子类，我们希望自动生成 `CodingKeys` 与 `init(from:)` 方法.

#### 用法

```
class BaseModel: Codable {
    var name: String = ""
}

@CodableSubclass
class StudentModel: BaseModel {
    var age: Int = 0
}


// 宏展开后等效于
class StudentModel: BaseModel {
    var age: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case age
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.age = try container.decode(Int.self, forKey: .age)
    }
}
```



#### 实现

```
@attached(member, names: named(init(from:)), named(CodingKeys))
public macro CodableSubclass() = #externalMacro(module: "McccMacros", type: "CodableSubclassMacro")


public struct CodableSubclassMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // 1. 验证是否是类声明
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            throw MacroError.message("@CodableSubclass 只能用于类")
        }
        
        // 2. 验证是否有父类
        guard let inheritanceClause = classDecl.inheritanceClause,
              inheritanceClause.inheritedTypes.contains(where: { type in
                  type.type.trimmedDescription == "BaseModel" ||
                  type.type.trimmedDescription.contains("Codable")
              }) else {
            throw MacroError.message("@CodableSubclass 需要继承自 Codable 父类")
        }
        
        // 3. 收集所有存储属性
        let storedProperties = classDecl.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .filter { $0.bindingSpecifier.text == "var" }
            .flatMap { $0.bindings }
            .compactMap { binding -> String? in
                guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else {
                    return nil
                }
                return pattern.identifier.text
            }
        
        // 4. 生成 CodingKeys 枚举
        let codingKeysEnum = try EnumDeclSyntax("private enum CodingKeys: String, CodingKey") {
            for property in storedProperties {
                "case \(raw: property)"
            }
        }
        
        // 5. 生成 init(from:) 方法
        let initializer = try InitializerDeclSyntax("required init(from decoder: Decoder) throws") {
            // 调用父类解码器
            "try super.init(from: decoder)"
            
            // 创建容器
            "let container = try decoder.container(keyedBy: CodingKeys.self)"
            
            // 解码每个属性
            for property in storedProperties {
                "self.\(raw: property) = try container.decode(\(raw: getTypeName(for: property, in: declaration)).self, forKey: .\(raw: property))"
            }
        }
        
        return [DeclSyntax(codingKeysEnum), DeclSyntax(initializer)]
    }
    
    private static func getTypeName(for property: String, in declaration: some DeclGroupSyntax) -> String {
        for member in declaration.memberBlock.members {
            guard let varDecl = member.decl.as(VariableDeclSyntax.self) else { continue }
            
            for binding in varDecl.bindings {
                guard let identifierPattern = binding.pattern.as(IdentifierPatternSyntax.self),
                      identifierPattern.identifier.text == property else {
                    continue
                }
                
                if let typeAnnotation = binding.typeAnnotation {
                    return typeAnnotation.type.trimmedDescription
                }
            }
        }
        
        // 默认返回 Any，如果找不到匹配
        return "Any"
    }
}

public enum MacroError: Error, CustomStringConvertible {
    case message(String)
    
    public var description: String {
        switch self {
        case .message(let text):
            return text
        }
    }
}
```



## 4. 总结

`MemberMacro` 是 Swift 宏体系中连接语法结构与声明注入的关键机制。它让开发者能够根据类型结构自动生成成员，真正实现：

- 结构自动扩展；
- 代码样板消除；
- 类型驱动式逻辑推导。

未来你可以将它与 `AccessorMacro`、`PeerMacro` 等组合使用，构建更高层次的声明式元编程能力。
