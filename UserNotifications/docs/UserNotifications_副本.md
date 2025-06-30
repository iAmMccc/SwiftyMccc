# 《iOS通知系统全解》完整目录

## 第一章：系统总览（当前章节）

**从闹钟到智能中枢 - iOS通知的进化论**
• 行业数据：通知对留存/活跃的核心价值
• 技术演进：从UILocalNotification到Live Activities
• 架构图解：UserNotifications框架核心组件
• 能力矩阵：本地通知 vs 远程推送的战术选择

------

### **基础篇**

#### 第二章：权限获取的艺术

**如何让用户心甘情愿说"好"**
• 黄金时机：首次启动 vs 场景化触发
• 话术设计：从"允许通知"到"获得专属服务"
• 被拒后的挽回策略：系统设置引导页

#### 第三章：本地通知的精准控制

**时间、位置、情境的三角法则**
• 触发器全解：UNCalendarNotificationTrigger实战
• 地理围栏通知：CLLocationManager的协同作战
• 后台任务与通知的配合：BGTaskScheduler

------

### **体验篇**

#### 第四章：吸引眼球的秘密

**从文字到富媒体的感官升级**
• 附件优化：图片/视频/GIF的尺寸与格式规范
• 自定义UI：NotificationContentExtension实战
• 声音心理学：选择最合适的提示音

#### 第五章：用户互动设计

**让通知成为微型交互入口**
• 动作按钮：UNNotificationAction的四种类型
• 文本输入：UNTextInputNotificationAction的妙用
• 深层链接：URL Schemes与Universal Links

------

### **进阶篇**

#### 第六章：推送扩展能力

**在抵达用户前完成魔法改造**
• Notification Service Extension：内容解密与富媒体下载
• 加密推送：使用端到端加密保护敏感信息
• 流量节省：智能压缩策略

#### 第七章：远程推送全链路

**从服务器到锁屏的完美旅程**
• Token管理：设备注册与更新的最佳实践
• Payload设计：aps字典的22个关键字段
• 质量保障：APNs错误码排查手册

------

### **策略篇**

#### 第八章：数据驱动优化

**用数字证明通知的价值**
• 核心指标：送达率/展示率/点击率/转化率
• 归因分析：通知点击与后续行为的关联
• A/B测试框架：标题/内容/发送时间的对决

#### 第九章：智能推送策略

**在正确的时间，推给正确的人**
• 用户分群：基于RFM模型的推送分级
• 时间算法：预测用户最佳接收时段
• 疲劳度控制：推送频次与用户流失的平衡

------

### **实战篇**

#### 第十章：调试与优化

**从开发到上线的避坑指南**
• 模拟推送：使用NWPusher工具链
• 真机调试：Notification Payload校验清单
• 性能优化：减少通知延迟的6个技巧

------

### 目录设计逻辑：

1. **循序渐进**：从基础概念→技术实现→策略优化
2. **模块清晰**：每篇聚焦一个核心维度（权限/本地/远程/策略等）
3. **实战导向**：每章包含"最佳实践"和"常见陷阱"板块
4. **数据贯穿**：基础篇之后都有对应的数据验证章节







# UserNotifications

## ✅ **第一篇：通知框架总览与核心概念**

### ✅ 建议标题：

> 【通知开发全解 | 01】UserNotifications 框架总览与核心架构

### ✅ 推荐结构：

1. **开篇引导：为什么还要关注通知系统？**
   - 通知是用户留存、活跃、召回的重要手段
   - 推送通知 ≠ 本地通知；iOS 通知系统发展简史（从 UILocalNotification 到 UNUserNotificationCenter）
2. **UserNotifications 框架定位**
   - 主要用于管理本地通知和响应通知行为
   - 不直接发起远程推送（那是 APNs 的工作）
3. **核心类结构图/表（推荐图示）**
   - `UNUserNotificationCenter`：主入口
   - `UNNotificationRequest`：通知包装
   - `UNNotificationContent / UNMutableNotificationContent`：通知内容
   - `UNNotificationTrigger`：触发条件（时间、日历、位置）
   - `UNNotificationCategory`：定义可交互动作
   - `UNNotificationResponse`：响应结果
   - `UNNotificationAttachment`：富媒体支持
4. **UNNotification 与 UILocalNotification 对比（表格列出差异）**
5. **总结：这个框架解决了什么问题？为何更现代化？**

------

## ✅ **第二篇：通知权限请求与用户引导策略**

### ✅ 建议标题：

> 【通知开发全解 | 02】请求通知权限：最佳时机与用户引导策略

### ✅ 推荐结构：

1. **通知权限申请基础**
   - `UNUserNotificationCenter.current().requestAuthorization` 用法
   - 常见选项：alert、sound、badge
2. **权限状态获取**
   - `getNotificationSettings()` 区分状态（未请求 / 拒绝 / 同意）
3. **用户常见行为场景**
   - 第一次拒绝
   - 设置中关闭
   - 主动开启
4. **最佳实践：**
   - 什么时候申请最合适？（首次打开 App vs 某功能触发时）
   - 如何让用户知道通知是“对他们有用的”？
   - 合法合规展示申请理由（info.plist 的用途）
5. **引导用户开启通知的方式**
   - 弹窗提示：点去系统设置
   - 打开 UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
6. **总结：获取权限不是运气，是设计**

------

## ✅ **第三篇：通知的调度与管理（本地通知）**

### ✅ 建议标题：

> 【通知开发全解 | 03】本地通知调度与管理：Request 与 Trigger 的实战指南

### ✅ 推荐结构：

1. **发送一个本地通知的流程**
   - 构造 Content、Trigger、Request
   - 添加到 NotificationCenter
2. **各种 Trigger 类型说明**
   - `UNTimeIntervalTrigger`（倒计时）
   - `UNCalendarTrigger`（定时）
   - `UNLocationTrigger`（位置）
3. **如何取消通知**
   - `removePendingNotificationRequests(withIdentifiers:)`
   - `removeDeliveredNotifications`
4. **重复通知的使用技巧与陷阱**
5. **如何在 App 启动时重新同步计划通知？**
6. **总结：通知的生命周期从请求开始，到被点击/忽略结束**

------

## ✅ **第四篇：通知的展示与交互效果（富媒体、前台处理等）**

### ✅ 建议标题：

> 【通知开发全解 | 04】让通知更有吸引力：展示样式与富媒体交互

### ✅ 推荐结构：

1. **前台展示策略**
   - 默认前台不会展示通知
   - 实现 delegate 中的 `willPresent notification`
2. **控制展示样式**
   - 横幅、声音、徽章配置
   - 使用 `UNNotificationPresentationOptions`
3. **添加富媒体**
   - 图片、音频、视频 Attachment 添加
   - 限制大小、格式支持说明
4. **通知内容扩展（Content Extension）**
   - 创建新的 Notification Content Extension
   - 配置 Info.plist
   - 自定义 UI，使用 NotificationViewController
5. **总结：不是每个通知都值得点开，但每个通知都值得被设计**

------

## ✅ **第五篇：通知响应处理（UNNotificationResponse、delegate）**

### ✅ 建议标题：

> 【通知开发全解 | 05】通知响应处理：点击、动作、跳转全掌控

### ✅ 推荐结构：

1. **UNNotificationResponse 基本结构**
   - `identifier`、`userText`、`notification`
2. **用户响应通知的几种方式**
   - 默认点击
   - 自定义 Action（按钮）
   - Text Input
3. **注册 Category 与 Action**
   - 使用 `UNNotificationAction` 和 `UNNotificationCategory`
   - 注册到 `UNUserNotificationCenter`
4. **接收响应：实现 delegate 的 `didReceive response` 方法**
5. **跳转逻辑设计建议**
   - 根据 payload 跳转到 App 内部页面
   - 数据预加载 / 页面初始化

------

## ✅ **第六篇：通知内容拓展（Attachment、Extension）**

### ✅ 建议标题：

> 【通知开发全解 | 06】通知内容拓展：Attachment 与自定义视图全解

### ✅ 推荐结构：

1. **UNNotificationAttachment**
   - 如何添加本地资源
   - 下载远程资源并转为 Attachment（使用 Service Extension）
2. **NotificationServiceExtension**
   - 目的：在推送送达前修改内容（加图、重写文字）
   - 生命周期 & 限时（30s 内完成）
3. **NotificationContentExtension**
   - 自定义通知展示 UI（横滑卡片式界面）
4. **注意事项与调试技巧**

------

## ✅ **第七篇：推送通知（远程 APNs）详解**

### ✅ 建议标题：

> 【通知开发全解 | 07】远程推送全攻略：从 APNs 到通知展示

### ✅ 推荐结构：

1. **推送架构简图**
   - App Server -> APNs -> 用户设备
2. **推送证书类型介绍**
   - Development vs Production
   - Token Based Auth
3. **注册 deviceToken**
   - `didRegisterForRemoteNotificationsWithDeviceToken`
4. **推送 payload 结构讲解（APS 字段）**
5. **结合 ServiceExtension/ContentExtension 的高级使用**
6. **常见错误处理**

------

## ✅ **第八篇：数据反馈与统计策略**

### ✅ 建议标题：

> 【通知开发全解 | 08】通知的数据闭环：用户行为反馈与统计策略

### ✅ 推荐结构：

1. **用户点击通知后的数据上报**
   - `didReceive response` 中打点
   - 推送中携带 ID 或 scene 信息
2. **用户未点击的行为怎么追踪？**
   - 结合服务端记录投送后未回调者
   - 搭配用户行为时间线分析
3. **使用 Analytics 工具进行通知转化率分析**
4. **本地通知统计如何实现**

------

## ✅ **第九篇：通知设计策略与实际应用场景**

### ✅ 建议标题：

> 【通知开发全解 | 09】通知的设计哲学：策略、频次与用户价值

### ✅ 推荐结构：

1. **不同类型通知设计原则**
   - 功能类、提醒类、营销类、互动类
2. **推送频次控制**
   - 过多 => 拉黑；过少 => 流失
   - 节奏与节日、用户行为挂钩
3. **如何分群推送更有效？**
   - 活跃/沉默用户区分
   - 用户兴趣匹配
4. **A/B 测试机制**
5. **用户可配置通知偏好设计建议**

------

## ✅ **第十篇：调试与测试技巧**

### ✅ 建议标题：

> 【通知开发全解 | 10】通知调试指南：真机、模拟器、Xcode 调试技巧全掌握

### ✅ 推荐结构：

1. **本地通知调试**
   - 手动发通知代码片段
   - 使用 macOS 推送助手工具
2. **推送通知调试**
   - 如何抓包查看 payload
   - 用 `terminal` 工具测试 APNs 推送
3. **模拟器支持情况**
   - iOS 14+ 模拟器支持通知调试
4. **Notification Extension 调试技巧**



### 第一篇

UserNotifications的介绍，

能做什么，

框架核心类结构



### 第二篇

通知权限管理，

如何引导用户尽可能的同意通知权限

用户关闭通知之后，如何引导用户开启



### 第三篇

UNUserNotificationCenter





### 第四篇

UNNotificationRequest

包含UNNotificationContent和UNNotificationTrigger



### 第五篇

UNNotificationCategory



### 第六篇

UNNotificationResponse



### 第七篇

UNNotificationAttachment



#### 第八篇：通知的展示样式与交互技巧

- 通知在不同状态（前台/后台/锁屏）下的展示行为
- 如何使用 `UNNotificationPresentationOptions` 控制前台展示（如声音、横幅、徽章）
- 如何处理富媒体通知（包括文本、图片、音频、视频）
- 使用 `UNNotificationContentExtension` 自定义通知样式（添加按钮、输入框等）



### **📆 通知调度与取消**

#### 第九篇：通知调度管理

- 如何使用 `UNUserNotificationCenter` 调度通知
- 本地通知的时间、日历、位置触发器详细使用（`UNTimeIntervalTrigger`、`UNCalendarTrigger`、`UNLocationTrigger`）
- 如何取消通知（`removePendingNotificationRequests`、`removeDeliveredNotifications`）
- 如何更新已发送的通知



### **📊 通知数据追踪与分析**

#### 第十篇：通知数据反馈机制

- 用户点击/忽略通知后的反馈（UNUserNotificationCenterDelegate 中的处理）
- App 中如何统计通知的打开率、响应行为
- 利用推送通知的 `customData` 实现统计埋点



### **📱 推送通知（Remote Push）集成**

#### 第十一篇：远程推送（APNs）简介与集成流程

- 与本地通知的差异与融合点
- APNs 的整体工作原理、deviceToken 获取与上报
- NotificationServiceExtension 的作用（下发前的通知内容修改）
- NotificationContentExtension 与 NotificationServiceExtension 配合使用技巧



### **📤 通知推送服务实践**

#### 第十二篇：通知在实际产品中的设计与策略

- 如何合理使用通知频次，避免用户反感
- 分场景发送通知的内容策略（如营销类、功能提醒类、互动类）
- 多语言、多时区通知策略
- A/B测试和通知策略调优实践



### **🧪 调试与测试**

#### 第十三篇：通知调试技巧

- 如何在 Xcode 模拟本地通知
- 如何在设备上调试 UNNotificationContentExtension
- 推送失败的常见原因排查（如证书、token、权限等）





`UserNotifications` 是 Apple 官方在 **iOS 10+ 引入的框架（Framework）**，用于统一处理 **本地通知（Local Notification）** 和 **远程推送通知（Push Notification）** 的功能。

它是对旧的 `UILocalNotification` 和 `UIApplication` 推送处理的现代化替代，更强大也更清晰。

## 🔍 能做什么？

| 功能               | 描述                                        |
| ------------------ | ------------------------------------------- |
| 📤 发送本地通知     | 在指定时间或地点提醒用户                    |
| 📥 接收远程通知     | 通过 Apple Push Notification Service (APNs) |
| 🧭 设置通知触发条件 | 时间、日历、地理位置                        |
| 🔔 自定义通知内容   | 标题、副标题、声音、图像等                  |
| 🔁 设置重复通知     | 每天/每周等循环提醒                         |
| 🪄 添加交互按钮     | 支持“稍后提醒”、“完成任务”等操作            |
| 📡 监听通知响应     | 处理用户点击、操作行为                      |
| 🔐 权限管理         | 请求、检查通知授权状态                      |
| 🧠 前台展示控制     | 控制 App 在前台时是否弹通知横幅等           |



| 模块                   | 用途                         | 是否常用            | 权限/限制        |
| ---------------------- | ---------------------------- | ------------------- | ---------------- |
| `UserNotifications`    | 发通知 / 响应通知            | ✅ 常用              | 无限制           |
| `UserNotificationsUI`  | 自定义通知界面               | ⚠️ 特定场景          | 需额外扩展       |
| `NotificationCenter`   | 旧版 Today Widget / 扩展通信 | ⚠️ iOS 14 以前用得多 | 新项目少用       |
| `ExposureNotification` | 疫情暴露通知 API             | ❌ 极少数政府 App    | 受限，不能随便用 |



## 📦 框架核心类结构

```
UserNotifications
├── UNUserNotificationCenter    // 通知中心（入口）
├── UNNotificationRequest       // 通知请求
│   ├── UNNotificationContent   // 内容：标题、声音、附件等
│   └── UNNotificationTrigger   // 触发器（时间/日历/位置）
├── UNNotificationCategory      // 分类 + 动作
├── UNNotificationResponse      // 用户响应
└── UNNotificationAttachment    // 附件（图像/音频/视频）
```



### 核心答案：

> **无论是远程推送通知，还是本地通知，iOS 在客户端接收和处理它们时，都是通过 `UserNotifications` 框架的一套统一机制来管理和响应的。**

换句话说：

- **展示给用户的通知内容**，无论是本地生成还是远程推送，都会由 `UNUserNotificationCenter` 统一调度。
- **用户点击通知后的响应回调**也由同一个代理方法处理。

## 详细说明

| 方面             | 本地通知                                                     | 远程通知（APNs）         |
| ---------------- | ------------------------------------------------------------ | ------------------------ |
| 通知触发来源     | App 本地定时、地理位置触发                                   | 远程服务器通过 APNs 发送 |
| 通知展示         | 由系统调度展示                                               | 由系统调度展示           |
| 接收与响应处理   | 通过 `UNUserNotificationCenter` 代理处理                     | 通过同一个代理处理       |
| 用户点击通知回调 | `userNotificationCenter(_:didReceive:withCompletionHandler:)` | 同上                     |
| 权限请求         | 需要请求通知权限                                             | 同样需要请求权限         |

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 前台收到通知，决定是否展示
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // 用户点击通知后的回调
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // 处理业务逻辑，比如打开特定页面
        completionHandler()
    }
}

## 额外补充

- 远程通知的 payload（推送内容）通常由服务器下发，可以带自定义字段 `userInfo`，你可以在回调里解析。
- 本地通知的 `userInfo` 也是你创建通知时自定义的，处理方式一致。
- 你可以用同一套逻辑区分本地和远程通知，比如根据 `userInfo` 中某个标识字段。

## todo

1. 如何发送本地通知

2. 接收远程通知

3. 触发器是什么。 

   ### 1. **时间触发器 — `UNTimeIntervalNotificationTrigger`**

   ### 2. **日历触发器 — `UNCalendarNotificationTrigger`**

   ### 3. **地理位置触发器 — `UNLocationNotificationTrigger`**

   ### 4. **推送通知触发器 — `UNPushNotificationTrigger`**

   ## 触发器是如何工作的？

   1. 你创建通知内容 `UNMutableNotificationContent`。
   2. 你创建一个触发器 `UNNotificationTrigger`。
   3. 你用内容 + 触发器 创建一个通知请求 `UNNotificationRequest`。
   4. 将请求添加到通知中心，系统会在满足触发器条件时发出通知。



## 小结

| 触发器类型                          | 触发条件示例         | 备注                       |
| ----------------------------------- | -------------------- | -------------------------- |
| `UNTimeIntervalNotificationTrigger` | 5秒后，10分钟后      | 时间间隔，支持重复         |
| `UNCalendarNotificationTrigger`     | 每天7点，指定日期    | 日期时间触发，支持重复     |
| `UNLocationNotificationTrigger`     | 进入某地，离开某地   | 位置触发，需要定位权限     |
| `UNPushNotificationTrigger`         | 远程推送，服务器下发 | 系统自动处理，开发者不创建 |





