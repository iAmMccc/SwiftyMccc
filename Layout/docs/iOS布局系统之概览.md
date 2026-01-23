#  iOS 布局系统：概览

每一款流畅的 iOS 应用，背后都有一个扎实的布局系统。不管界面多么酷炫，交互多么顺滑，最终都要回答一个最基础的问题：**每个界面元素应该放在哪，有多大？**

这个系列，我们就从这个最基础的问题出发，一层一层拆解 iOS 的布局系统：从我们写代码时看到的 API，到系统真正如何把界面“算”出来、再“画”出来。

在正式讨论布局之前，先明确前提：

> **界面，并不是在你改代码的那一刻立刻更新的。**



## 一、UI 是 “延迟更新” 的

在主线程的 RunLoop 中，除了处理用户事件、执行我们写的代码之外，还包含一个专门用于**界面更新**的阶段，通常被称为 **Update Cycle**。

一轮 RunLoop 的大致流程是：

1. 处理输入事件（触摸、手势、通知等）
2. 执行业务代码
3. **统一处理 UI 更新（布局、绘制）**
4. 进入休眠，等待下一次事件

也就是说，当你在代码里做了这些事：

```swift
label.text = "A"
label.text = "AB"
label.text = "ABC"
```

系统并不会立刻重新计算布局，而是先给对应的 view 打一个“脏（dirty）”标记，表示**这个视图需要更新，但先别急**。这些更新请求会被**合并**，并在下一次 Update Cycle 里统一处理。



### 为什么要这么设计？

iOS 的界面刷新频率通常是 **60 fps**（每秒 60 帧）。每一帧的所有 UI 计算和渲染，需要在 **1/60 秒 ≈ 16.7 ms** 内完成。如果每一次属性修改都立刻触发布局和重绘，就可能出现：

```
一帧内计算三次布局 → 性能浪费 → 帧率下降
```

所以 UIKit 选择了 **延后执行 + 批量合并**，在合适时机一次性算完。

理解这一点，对后面理解 `setNeedsLayout`、`layoutIfNeeded`、Auto Layout 的行为至关重要。



## 二、到底什么是“布局”?

在 iOS 开发里，“布局”要解决的是一个非常具体的问题：**在某个时间点，确定一个视图在屏幕上的位置和大小。**

这个问题可以拆成两个更小的部分：

- **位置**：这个视图在它父视图的坐标系里，左上角在哪
- **尺寸**：这个视图要占多大一块矩形区域

最终，这两个信息会落在同一个属性上：**`view.frame`**。

### 布局的三个核心几何属性

想真正搞懂布局，必须先分清这三个属性各自管什么：

| 属性       | 坐标系       | 作用                           | 对布局的影响                 |
| ---------- | ------------ | ------------------------------ | ---------------------------- |
| **frame**  | 父视图坐标系 | 决定视图在父视图里的位置和大小 | **布局的最终结果**           |
| **bounds** | 自身坐标系   | 决定视图内部可绘制区域         | 影响内容绘制，不影响外部位置 |
| **center** | 父视图坐标系 | 决定视图中心点的位置           | 常用于动画，更直观           |

**布局的最终产出，一定是一个确定的 frame。**

> 容易混淆的几个点：
>
> - **布局 ≠ 绘制**
>   布局只决定“放哪、多大”，不管“画什么”。画什么是 `draw(_:)` 或图层的事。
> - **布局 ≠ 动画**
>   动画只是让 frame / transform 随时间变化，布局决定的是动画前后那个“确定状态”。
> - **布局 ≠ 视图层级**
>   `addSubview()` 只是建立父子关系，真正的位置和大小，还是布局阶段决定的。



### 布局是一个“过程”

在 UIKit 里，布局不是一次性完成的静态结果，而是一个**持续、可触发的过程**。核心入口是：

```swift
override func layoutSubviews() {
    super.layoutSubviews()
    // 在这里重新安排子视图的位置和大小
}
```

当系统认为某个视图“需要重新布局”时：

- 调用 `setNeedsLayout()` → 下一个 RunLoop 执行布局
- 调用 `layoutIfNeeded()` → 立即布局（如果标记为脏）
- frame / bounds / center 改变
- 添加或移除子视图

它会在合适的时机调用这个方法。

搞明白**什么时候会触发布局、布局怎么算的**，才是掌握 iOS 布局系统的关键。



## 三、iOS 中的三种布局“写法”

在iOS开发实践中，我们主要通过三种方式来描述布局意图：

- **Frame 布局**
- **Auto Layout**
- **SwiftUI 布局**

需要强调的是：**这是我们“描述布局的方式”，而不是系统内部真正的布局机制。**

它们解决的是：**“我该怎么告诉系统我想要什么样的布局”，而不是“系统最终是怎么把界面画出来的”。**

### 三种方式比较

| 维度               | Frame            | Auto Layout  | SwiftUI         |
| ------------------ | ---------------- | ------------ | --------------- |
| 核心思路           | 直接给结果       | 声明关系     | 声明意图        |
| 我们提供           | 具体 frame       | 约束条件     | 视图结构 + 规则 |
| 系统工作量         | 几乎没有         | 解约束方程   | 多轮布局协商    |
| 是否直接控制 frame | 是               | 否（系统算） | 否（完全封装）  |
| 内容变化           | 手动重算         | 自动调整     | 自动调整        |
| 适合场景           | 自定义视图、动画 | 复杂界面     | 状态驱动 UI     |

可以把它们理解成三种不同层级的“抽象”：

- **Frame**：你直接给答案
- **Auto Layout**：你给规则，系统算答案
- **SwiftUI**：你说想要什么效果，系统自己想办法

示例：

```
// Frame



// Auto Layout
view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 10),
    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 10),
    view.widthAnchor.constraint(equalToConstant: 100),
    view.heightAnchor.constraint(equalToConstant: 50)
])

// SwiftUI
Text("Hello")
    .frame(width: 100, height: 50)
    .position(x: 60, y: 35)
```



## 四、不管怎么写，内核只有 Frame

不管你用 Frame、Auto Layout 还是 SwiftUI，最终一定都会变成 Frame。

### 为什么绕不开 Frame？

**1. 渲染系统只认识它**

- 每个 `CALayer` 都必须有确定的 `bounds`、`position` 和 `anchorPoint`。
- GPU 只认识绝对的坐标和纹理，不懂什么“左边距 10pt”。

**2. 调试工具看到的也是它**

无论是 Xcode View Debugger 还是 Reveal，最终看到的都是一层层矩形框。

**3. 事件分发依赖它**

触摸点落在哪个 view 上，靠 frame / bounds 几何判断

### 换个角度

| 布局方式    | 类比         | 系统在做什么   |
| ----------- | ------------ | -------------- |
| Frame       | 给精确地址   | 直接用         |
| Auto Layout | 给摆放规则   | 现场计算       |
| SwiftUI     | 描述期望效果 | 多轮协商后计算 |

> **Auto Layout 和 SwiftUI 没有发明新的布局机制，它们建立在同一套底层系统上，提供的更聪明、更自动的“Frame 计算器”**。

理解 iOS 布局系统，就是搞懂两件事：

1. **结果是什么**：最终都得变成 `CGRect`
2. **什么时候算**：转换发生的时机，谁负责算



## 五、隐形的布局陷阱：Autoresizing Mask

很多布局“怪问题”，其实都出在这里。

### 什么是 Autoresizing Mask？

在 Auto Layout 出现之前，iOS 使用的是 `frame` + `autoresizingMask`，描述父视图尺寸变化时，子视图如何跟随：

```
view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
```

意思是：父视图变大，我也跟着拉伸。

### 为什么它会和 Auto Layout 冲突？

因为 Auto Layout 靠 **约束** 算 frame，而 autoresizingMask 会被系统**偷偷转成约束**。

当：`translatesAutoresizingMaskIntoConstraints == true` 时，系统会生成一堆**隐式约束**。如果你又手动加了约束，就会出现：

- 约束冲突
- 拉伸压缩异常
- 控制台警告

### 解决办法

如果打算用 Auto Layout：

```
view.translatesAutoresizingMaskIntoConstraints = false
```

含义是：**“这块我自己来，别帮我生成隐式约束。”**



## 六、从描述到执行：布局的生命周期

现在我们知道，无论用什么方式描述布局，最终都得落到具体的 `frame`。但关键问题是：**这些 frame 到底什么时候计算？谁来计算？**

[下一篇：iOS 布局系统：布局原理 →]