# Swift Macros 系列 - 玩转 Swift 宏，从入门到精通



## 基础篇

### Swift Macros - 宏之起点
本文介绍了 **Swift 宏** 的背景与引入动机，阐述了宏在编程中的基本用途，帮助开发者理解宏如何简化代码编写、提升开发效率。内容还包括了宏的基本配置方式与使用场景，适合入门读者对宏有一个初步的了解。

[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/1.宏之起点.md)

### Swift Macros - 宏之全貌
这篇文章从宏的类型体系、执行原理到角色机制和协议模型，为读者提供了一个宏系统的全景鸟瞰。文章介绍了宏在 Swift 中的不同角色及其协议关系，阐述了宏的扩展、展开过程以及如何结合协议实现多角色配合，帮助有一定基础的开发者全面理解宏的设计和应用。

[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/2.宏之全貌.md)

### Swift Macros - 宏之职责与命名
本篇文章聚焦 Swift 宏系统中的“职责控制”与“命名控制”机制，系统讲解宏的三大核心组成：**宏类型（Macro Kind）**、**宏角色（Macro Role）** 和 **命名说明符（Name Specifier）**。通过区分独立宏与绑定宏、梳理各类宏角色，并结合命名说明符的使用方式，帮助开发者构建更清晰、稳定、可维护的宏能力体系。

[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/3.宏之职责与命名.md)

### Swift Macros - 宏之语法树

本篇文章聚焦 Swift 宏系统中的“语法基础”与“结构操控”能力，深入剖析宏所操作的核心结构——**语法节点（Syntax）**。通过讲解 SwiftSyntax 的节点体系、语法树的提取与构造方式、以及 `\(raw:)` 插值的正确用法，帮助开发者掌握宏展开背后的语法逻辑与生成原理，为构建结构化、类型安全的宏能力奠定坚实基础。

[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/4.宏之语法树.md)

### Swift Macros - 宏之节点指南

本文梳理了 SwiftSyntax 中常用的语法节点，涵盖表达式、声明、语句、类型、模式、属性、宏以及其他常用节点。每个节点均提供简要描述和快速构造示例，旨在为开发者在使用 Swift 宏和 SwiftSyntax 进行代码生成、分析和转换时，提供一份高效、准确的参考资料。

[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/5.宏之节点指南.md)

### Swift Macros - 宏之协议

Swift 宏系统通过不同的协议定义了宏的多种角色和能力，从表达式生成、声明插入，到成员绑定、访问控制等。本系列文章将逐个讲解这些协议的定义、特性及适用场景，帮助你系统理解宏的角色体系。

#### 宏协议概述

简要介绍 Swift 中所有宏协议的概念、作用及它们之间的关系，作为理解整个宏协议体系的入口。
[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/6.宏之协议.md)

#### 表达式独立宏（ExpressionMacro）

讲解 `ExpressionMacro` 协议的定义与使用场景，展示如何基于表达式节点生成动态代码。
[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/6.1表达式独立宏.md)

#### 声明式独立宏（DeclarationMacro）

分析 `DeclarationMacro` 如何生成声明代码，结合初始化器、变量、函数的实际生成场景讲解。
[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/6.2声明式独立宏.md)

#### 成员绑定宏（MemberMacro）

展示 `MemberMacro` 如何为结构体或类动态插入属性、方法等成员内容，是构建派生代码的核心手段。
[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/6.3成员绑定宏.md)

#### 对等绑定宏（PeerMacro）

说明 `PeerMacro` 的用途，即在同一层级下生成兄弟声明，常用于生成辅助类型或伴生属性等。
[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/6.4对等绑定宏.md)

#### 访问器宏（AccessorMacro）

讲解 `AccessorMacro` 如何为现有的属性生成 getter/setter 等访问逻辑，结合 UserDefault 等场景展开。
[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/6.5访问器绑定宏.md)

#### 扩展宏（ExtensionMacro）

展示 `ExtensionMacro` 用于生成扩展声明，实现协议适配、默认实现等功能。
[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/6.6扩展绑定宏.md)

#### 属性宏（MemberAttributeMacro）

讲解 `MemberAttributeMacro` 的应用，如为属性自动添加注解、权限、内联标识等修饰语。
[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/6.7成员属性绑定宏.md)

#### 方法体宏（BodyMacro）

说明 `BodyMacro` 的设计方式，以及如何为已有函数添加函数体代码，常用于方法插桩与默认实现生成。
[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SwiftMacro/docs/6.8替换声明体绑定宏.md)



## 进阶篇（todo）

#### 1. 宏的调试与优化
- **宏展开的可视化**：如何通过工具或命令查看宏展开后的实际代码，帮助开发者调试。  
- **性能考虑**：宏在编译时展开，是否会影响编译时间，如何优化宏的使用以避免不必要的性能损失。

#### 2. 宏与注释、文档生成
- **生成文档的宏**：如何使用宏为代码自动生成文档，或者为常用代码模式生成注释。  
- **自动化文档注释**：使用宏自动为函数、类型、属性等生成标准化的文档注释。



## 高阶篇（todo）

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

