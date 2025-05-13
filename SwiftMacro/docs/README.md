# Swift Macros 系列 - 玩转 Swift 宏，从入门到精通

## 基础篇

### Swift Macros - 宏之起点
介绍宏的背景、为何被引入、基本用途、开发配置方式

[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/1.%20宏之起点.md)

### Swift Macros - 宏之全貌
宏的类型体系、执行原理、角色机制和协议模型全景鸟瞰

[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/2.%20宏之全貌.md)

---

### Swift Macros - 宏之角色
> 核心内容：freestanding vs attached、8大角色类型（expression/member/...）  
> 用通俗例子说明每种角色负责“干什么”

[查看详情]()

### Swift Macros - 宏之命名说明符

> `@names`, `@peerNames`, `@bodyNames` 等，解决命名冲突和精细控制  
> 与“角色”天然绑定，是角色机制的补充说明

宏的命名规范与组织

> 如何规范化宏的命名，确保代码的可读性与维护性。

[查看详情]()

---

#### Swift Macros - 宏之协议

1. **宏协议概述**  
   简要介绍所有宏协议的概念，作用及其关系。  
2. **表达式独立宏（ExpressionMacro）**  
   讲解 `ExpressionMacro` 协议的定义与作用，举例展示如何使用它。  
3. **声明式独立宏（DeclarationMacro）**  
   讲解 `DeclarationMacro` 协议的定义与作用，结合实际场景示例。  
4. **成员绑定宏（MemberMacro）**  
   讲解 `MemberMacro` 协议的定义与作用，具体应用示例分析。  
5. **对等绑定宏（PeerMacro）**  
   讲解 `PeerMacro` 协议的定义与作用，并结合代码示例说明。  
6. **访问器宏（AccessorMacro）**  
   讲解 `AccessorMacro` 协议的定义与作用，提供相应的实现示例。  
7. **扩展宏（ExtensionMacro）**  
   讲解 `ExtensionMacro` 协议的定义与作用，结合使用场景进行讲解。  
8. **属性宏（MemberAttributeMacro）**  
   讲解 `MemberAttributeMacro` 协议的定义与作用，展示常见的用法。  
9. **方法体宏（BodyMacro）**  
   讲解 `BodyMacro` 协议的定义与作用，展示如何为现有函数体添加代码。



## 进阶篇

#### 1. 宏的调试与优化
- **宏展开的可视化**：如何通过工具或命令查看宏展开后的实际代码，帮助开发者调试。  
- **性能考虑**：宏在编译时展开，是否会影响编译时间，如何优化宏的使用以避免不必要的性能损失。

#### 2. 宏与注释、文档生成
- **生成文档的宏**：如何使用宏为代码自动生成文档，或者为常用代码模式生成注释。  
- **自动化文档注释**：使用宏自动为函数、类型、属性等生成标准化的文档注释。

---

## 高阶篇

> 本篇将探讨 Swift 宏的进阶应用，重点讲解宏的多角色结合、宏与泛型及协议的结合等高阶技巧。通过这些技巧，开发者可以在复杂的应用场景中充分利用宏的潜力，简化开发流程。

#### 1. 宏的多角色结合
- **多角色宏的定义与实现**：结合 `MemberMacro` 与 `AccessorMacro` 实现一个宏，既为类型添加成员，又为其生成访问器。  
- **实际应用场景**：例如，自动为模型类生成属性的 `getter` 和 `setter`，同时自动提供 `Codable` 支持。  
- **如何处理多个协议间的冲突与优先级**：讨论宏角色的冲突管理与组合时的优先级控制。

#### 2. 宏的嵌套与组合
- **宏嵌套使用**：如何将多个宏组合起来使用，以及宏之间的依赖关系，如何处理冲突和优先级问题。  
- **宏组合模式**：如何设计和使用组合宏，如何处理嵌套宏的展开顺序和结果。

#### 3. 宏与泛型结合
- **如何在宏中使用泛型**：使用泛型参数生成不同类型的代码，例如根据类型生成不同的 `Codable` 支持。  
- **泛型约束与宏的结合**：如何在宏中对泛型类型设置约束，例如只为符合某协议的类型生成代码。  
- **实际案例**：生成不同类型的 `Equatable` 或 `Comparable` 支持，自动为泛型类型添加协议扩展。

#### 4. 宏与协议协作
- **自动生成协议实现**：如何利用宏为类型自动实现协议（如 `Codable`、`Equatable` 等）。  
- **协议要求与宏的结合**：通过宏自动插入符合协议要求的成员或方法，例如自动生成 `init(from:)` 方法来支持 `Codable`。  
- **协议与扩展结合**：利用 `ExtensionMacro` 和协议自动扩展，为已有类型添加协议方法和属性。  
- **宏生成的协议兼容性与维护**：如何确保生成的协议实现与原有代码的兼容，避免重复代码或类型冲突。

#### 5. 宏的生命周期与版本管理
> 讨论如何管理宏的生命周期，如何设计和更新宏，确保兼容性。

---

## 实战篇

### 1. 宏与依赖注入
- **使用宏生成依赖注入代码**：自动为类型生成初始化方法，提供所需依赖。  
- **结合 `@inject` 宏简化代码**：通过宏自动生成属性注入的 getter/setter，简化构造方法和依赖管理。

### 2. 宏的扩展性与插件化
- **如何为宏编写插件**：编写一个简单的宏插件，扩展现有的宏系统，支持更多自定义功能。  
- **与第三方库集成**：使用宏与第三方库的结合，自动为库类型生成支持代码。  
- **宏与框架的协同工作**：展示如何通过宏将外部框架的功能集成到项目中，自动生成接口和属性。









## 参考资料

* [Swift 编程语言 - 宏](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/)

* [Apple开发文档 - 应用宏](https://developer.apple.com/documentation/swift/externalmacro(module:type:))

* [WWCD2023 - 编写 Swift 宏](https://developer.apple.com/cn/videos/play/wwdc2023/10166)

* [WWDC2023 - 深入了解 Swift 宏](https://developer.apple.com/cn/videos/play/wwdc2023/10167)



## 反馈与参与

- 欢迎通过 [Issue](https://github.com/iAmMccc/SwiftyMccc/issues) 提出建议或疑问  
- 也欢迎提交 PR，丰富此系列内容  
- 若你喜欢这个系列，别忘了点个 ⭐️ 哦！

---

© 2025 [SwiftyMccc](https://github.com/iAMMccc/SwiftyMccc) · Powered by Swift · Written with ❤️ by Mccc

