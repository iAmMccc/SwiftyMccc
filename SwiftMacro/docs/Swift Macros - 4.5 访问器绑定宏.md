# Swift Macros - 访问器绑定宏

在 Swift 宏体系中，`AccessorMacro` 是一种专用于**自动生成属性访问器（如 getter、setter、willSet、didSet 等）**的宏协议。它适用于那些希望对属性访问行为进行自定义、跟踪或扩展的场景，在构建声明式属性模型和状态观察系统中极具价值。



## 1. `AccessorMacro` 的定义

标准库中 `AccessorMacro` 的协议定义如下：

```
public protocol AccessorMacro: AttachedMacro {
  static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclSyntaxProtocol,
    providingAccessorsOf storedProperty: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax]
}
```

这表示：

- 它是一种 `@attached(accessor)` 类型的宏；
- 专门用于**属性级别（property-level）**绑定；
- 它的返回值为 `[AccessorDeclSyntax]`，即访问器数组；
- 与 `MemberMacro` 不同，它不生成新成员，只生成该属性的访问逻辑。

------

## 2. 使用场景分析

| 应用场景       | 示例          | 说明                               |
| -------------- | ------------- | ---------------------------------- |
| 自动打印追踪   | `@Observe`    | 自动打印属性变化前后的值           |
| 自动脏标记更新 | `@DirtyTrack` | 属性变更时自动设置脏标志           |
| 数据合法性校验 | `@Validate`   | 在 setter 中自动进行值的合法性校验 |
| 双向绑定触发器 | `@Bindable`   | 在 set 时触发 UI 更新或事件回调    |

只要你希望**控制属性访问行为（特别是赋值过程）**，`AccessorMacro` 就是首选工具。



## 3. 参数详解

### `of node: AttributeSyntax`

代表宏标记语法本身，例如 `@Observe`，可用于参数识别与行为控制。

### `attachedTo declaration: some DeclSyntaxProtocol`

表示宏所附着的原始属性声明，一般是 `VariableDeclSyntax`。

### `providingAccessorsOf storedProperty: some DeclSyntaxProtocol`

同样表示所操作的属性本身，与 `attachedTo` 通常相同，但语义更明确：你要为它提供访问器。

### `in context: some MacroExpansionContext`

上下文信息：用于生成唯一标识符、定位源文件位置或报告错误。

## 4. 返回值 `[AccessorDeclSyntax]`

返回值是访问器声明数组，可以包含任意组合，如：

```
[
   AccessorDeclSyntax("get { _value }"),
   AccessorDeclSyntax("set { print(\"New value: \\(newValue)\"); _value = newValue }")
]
```

这些访问器将完全替换原始属性的访问行为。

------

## 5. 示例解析

### 示例：@UserDefault

我们定义一个宏 `@UserDefault`，为属性生成 getter 和 setter，提供存储和获取能力。

#### 使用

```
struct Settings {
    @UserDefault
    var username: String
    
    @UserDefault
    var age: Int?
}

// 展开后
struct Settings {
   
    var username: String
    {
        get {
            (UserDefaults.standard.value(forKey: "username") as? String)!
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "username")
        }
    }
    
    var age: Int?
    {
        get {
            UserDefaults.standard.value(forKey: "age") as? Int
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "age")
        }
    }
}
```





#### 实现

```
@attached(accessor, names: arbitrary)
public macro UserDefault() = #externalMacro(module: "McccMacros", type: "UserDefaultMacro")

public struct UserDefaultMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        
        // 把通用声明转成变量声明
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              // 获取属性名
              let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
              // 获取属性类型
              let typeSyntax = binding.typeAnnotation?.type
        else {
            throw ASTError("UserDefault can only be applied to variables with explicit type")
        }

        
        let isOptional: Bool
        let type: String

        
        // 判断是否可选类型
        if let optionalType = typeSyntax.as(OptionalTypeSyntax.self) {
            isOptional = true
            // 去掉 `?` 获取实际类型
            type = optionalType.wrappedType.description
        } else {
            // 普通类型
            isOptional = false
            type = typeSyntax.description
        }

        // ✅ 构造 getter
        let getter: AccessorDeclSyntax
        if isOptional {
            getter = """
            get {
                UserDefaults.standard.value(forKey: "\(raw: name)") as? \(raw: type)
            }
            """
        } else {
            getter = """
            get {
                (UserDefaults.standard.value(forKey: "\(raw: name)") as? \(raw: type))! 
            }
            """
        }

        // ✅ 构造 setter
        let setter = AccessorDeclSyntax(
            """
            set {
                UserDefaults.standard.setValue(newValue, forKey: "\(raw: name)")
            }
            """
        )

        return [getter, setter]
    }
}

```



## 6. 与 `PeerMacro` 配合使用

通常 `AccessorMacro` 与 `PeerMacro` 是组合使用的：

- `PeerMacro`：负责生成底层的 `_xxx` 存储属性；
- `AccessorMacro`：负责生成代理的访问逻辑，访问 `_xxx` 并包裹额外行为。

例如：

```
@WithStorage
@Observe
var name: String
```

展开后等价于：

```
private var _name: String = ""

var name: String {
    get { _name }
    set {
        print("[name] 旧值：\(_name)，新值：\(newValue)")
        _name = newValue
    }
}
```

------

## 7. 限制与注意事项

- 访问器宏只能附着在 `var` 属性上；
- 不能生成 `willSet` 和 `didSet` 与 `get/set` 同时存在的混合访问器（Swift 语法限制）；
- 原始属性必须有 backing 存储（可配合 `PeerMacro` 生成）；
- 与 `@propertyWrapper` 不同，它不会引入额外类型或语义负担。

------

## 8. 总结

`AccessorMacro` 是 Swift 宏系统中控制“属性行为”的关键工具。它通过访问器代码生成机制，将属性语义与行为解耦，适用于：

- 监听属性变化；
- 构建数据流响应逻辑；
- 执行赋值约束与处理。

结合 `MemberMacro`、`PeerMacro`，你可以构建出完整的声明式状态模型系统，实现真正的结构驱动式编程体验。
