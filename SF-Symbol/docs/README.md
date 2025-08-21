# Swift SF Symbol 系列 - 玩转 SF Symbol，从入门到精通



本篇内容配套 [Demo 演示](https://github.com/iAmMccc/SwiftyMccc/tree/main/SF-Symbol/example/McccSymbols)，将代码示例与文档讲解紧密结合，让学习更直观、高效。



## 基础篇

### 1. 起点，认识符号

本篇作为 **SF Symbol 系列的开篇**，带你全面认识 Apple 提供的矢量符号库 —— **SF Symbols**。文章不仅介绍了它在 iOS 界面设计中的核心作用，还结合 **SF Symbols App** 展示了符号的命名规律、搜索方法和导出方式，并通过代码示例讲解了如何在 UIKit 中加载符号、插入文本、调整样式。最后，总结了 SF Symbols 在动态适配、无障碍支持和视觉一致性方面的独特优势。

无论你是初学者还是有经验的开发者，都能通过本文快速掌握 SF Symbols 的基础使用方法，为后续的样式变体与动画应用打下坚实的基础。

[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SF-Symbol/docs/1.SF-Symbol%20Base.md)

### 2. 变体，灵活扩展

在掌握了 SF Symbols 的基础用法后，本篇将聚焦于 **符号的变体（Variants）**。从 iOS 15 起，Apple 为众多系统符号提供了更丰富的语义化样式，例如 **填充、裁剪、斜线、徽章、方向变化** 等。

这些变体不仅是视觉上的“替换”，更是 Apple 设计体系中预设的 **状态表达与交互语义**。文章将通过示例代码与配图，系统拆解以下几类常见变体：

- **填充 / 轮廓** → 默认与高亮状态对比
- **形状背景** → 圆形、方形裁剪与组合
- **斜线** → 否定或禁用语义
- **裁剪** → 头像、缩略图场景
- **徽章** → 添加、删除、警告、提示
- **方向** → 箭头、手势、交通方向

最后还会介绍一些不规则的特殊变体（如 `.dotted`、`.inverse`），并分享在 **SF Symbols App** 中探索和确认可用性的技巧。

**这篇文章将帮助你在日常开发中，灵活运用符号的多样样式，让图标既美观统一，又具备清晰的语义表达。**

[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SF-Symbol/docs/2.SF-Symbol%20Variants.md)



### 3. 样式，外观控制

当掌握了符号的基础用法与变体之后，本篇将进一步深入 **样式（Style）** 的定制。
在 iOS 中，SF Symbols 并非死板的图标，而是具备高度可配置性的 **符号对象**。
通过 `UIImage.SymbolConfiguration`，开发者可以灵活调整符号的大小、粗细、缩放比例与颜色，从而与文字排版和界面视觉保持一致。

本篇将系统拆解以下关键能力：

- **大小 / 粗细 / 缩放** → 如何与文字字号、字重精确对齐
- **字体与动态类型** → 让符号随系统字体自动适配
- **配置组合与微调** → 灵活拼接、覆盖或删除配置
- **四大渲染模式**
  - 单色（Monochrome）
  - 分层（Hierarchical）
  - 多色（Multicolor）
  - 调色盘（Palette）

结合实际代码示例与对比图，本篇将帮助你全面掌握符号的样式控制与渲染模式选择，在 **不同背景、配色与动态字体场景** 下，依旧保持符号的清晰度与一致性。

**这是 SF Symbols 的“进阶外观篇”，解决的不只是“显示图标”，而是“如何让图标在你的 App 中始终好看”。**

[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SF-Symbol/docs/3.SF-Symbol%20Style.md)



### 4. 效果，动态与表现

本篇专注于 **iOS 17+ 的 Symbol Effects**：它直接作用在 **符号的图层与可变部分**，而非传统视图动画。你将系统化掌握 **动画类型、分类维度与调用方式**，把系统图标“动”得既自然又有语义。

**主要内容一览：**

- **四大协议维度的分类**：
  `Discrete`（一次性）、`Indefinite`（持续循环）、`Transition`（状态过渡）、`Content Transition`（内容替换过渡）
- **具体效果总览与支持矩阵**：
  `Bounce`、`Pulse`、`Breathe`、`Rotate`、`VariableColor`、`Wiggle`、`Scale`、`Appear`、`Disappear`、`Replace`
- **UIKit 调用与参数**：
  `addSymbolEffect` 重载、`SymbolEffectOptions` 的 `speed` 与重复控制（含 iOS 18+ `RepeatBehavior`：`periodic` / `continuous`）
- **控制维度**：
  分层 vs 整体（`byLayer` / `wholeSymbol`）、方向与可见性（如 `reversing` / `nonReversing`、`hideInactiveLayers` / `dimInactiveLayers`）
- **组合与移除**：
  多效果叠加的原则与示例；`removeSymbolEffect(ofType:)`、`removeAllSymbolEffects()`

配合示例代码与 Demo，你可以迅速为常见符号（如 Wi-Fi、下载、播放/暂停、铃铛）添加**语义清晰、节奏统一**的动画表达。

[查看详情](https://github.com/iAmMccc/SwiftyMccc/blob/main/SF-Symbol/docs/4.SF-Symbol%20Animation.md)





## 实战篇（todo）

### 1. 符号在列表与按钮中的应用

- **列表示例**：如何在 TableView 或 CollectionView 中使用符号展示状态。
- **按钮与标签示例**：动态调整符号样式以匹配交互状态。

### 2. 符号与 UI 动画结合

- **加载动画与状态指示**：通过符号动画提升用户体验。
- **符号与颜色渐变结合**：实现更加生动的 UI 效果。





## 参考资料

- [SF Symbols 介绍](https://developer.apple.com/cn/sf-symbols/)
- [SF 符号设计指南](https://developer.apple.com/cn/design/human-interface-guidelines/sf-symbols)



## 反馈与参与

- 欢迎通过 [Issue](https://github.com/iAmMccc/SwiftyMccc/issues) 提出建议或疑问
- 也欢迎提交 PR，丰富此系列内容
- 若你喜欢这个系列，别忘了点个 ⭐️ 哦！

------

© 2025 [SwiftyMccc](https://github.com/iAMMccc/SwiftyMccc) · Powered by Swift · Written with ❤️ by Mccc
