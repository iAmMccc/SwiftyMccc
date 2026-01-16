//
//  McccAlarmActivity.swift
//  McccAlarmActivity
//
//  Created by qixin on 2025/10/17.
//

import ActivityKit
import AlarmKit
import SwiftUI
import WidgetKit
import AppIntents

struct McccAlarmActivity: Widget {
    
    
    /// body属性 - Widget的核心配置
    var body: some WidgetConfiguration {
        /// 配置 Live Activity
        ///  - 配置锁屏页面的UI
        ///  - 配置灵动岛界面的UI
        ActivityConfiguration(for: AlarmAttributes<SimpleMetadata>.self) { context in
            /// 设置锁屏界面的UI
            ///  - context.attributes：闹钟的静态属性（标题、颜色、元数据等）
            ///  - context.state：闹钟的动态状态（倒计时进度、是否暂停等）
            lockScreenView(attributes: context.attributes, state: context.state)
        } dynamicIsland: { context in
            /// 设置灵动岛界面的UI
            /// 显示模式 3种
            /// 1. 展开模式：用户长按灵动岛时显示的完整页面。
            /// 2. 紧凑模式：灵动岛正常显示时的样子。
            /// 3. 最小模式：当有多个Lvie Activity 时，灵动岛显示最小化。
            ///
            DynamicIsland {
                // 展开时的布局：左侧区域。 标题
                DynamicIslandExpandedRegion(.leading) {
                    alarmTitle(attributes: context.attributes, state: context.state)
                }
                
                // 展开时的布局：右侧区域。 图标
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: "timer")
                        .font(.title2)
                        .foregroundStyle(context.attributes.tintColor)
                }
                
                // 展开时的布局：底部区域。
                DynamicIslandExpandedRegion(.bottom) {
                    bottomView(attributes: context.attributes, state: context.state)
                }
            } compactLeading: {
                // 紧凑状态左侧 - 显示倒计时
                countdown(state: context.state, maxWidth: 44)
                    .foregroundStyle(context.attributes.tintColor)
            } compactTrailing: {
                // 紧凑状态右侧 - 显示进度环
                ProgressView(
                    timerInterval: getCurrentFireDate(state: context.state),
                    countsDown: true,
                    label: { EmptyView() },
                    currentValueLabel: {
                        Image(systemName: "timer")
                            .scaleEffect(0.8)
                    })
                .progressViewStyle(.circular)
                .foregroundStyle(context.attributes.tintColor)
            } minimal: {
                // 最小状态 - 只显示图标
//                Image(systemName: "timer")
//                    .foregroundStyle(context.attributes.tintColor)
                // 紧凑状态右侧 - 显示进度环
                ProgressView(
                    timerInterval: getCurrentFireDate(state: context.state),
                    countsDown: true,
                    label: { EmptyView() },
                    currentValueLabel: {
                        Image(systemName: "timer")
                            .scaleEffect(0.8)
                    })
                .progressViewStyle(.circular)
                .foregroundStyle(context.attributes.tintColor)
            }
            .keylineTint(context.attributes.tintColor)
        }
    }
    
    // MARK: - 锁屏界面
    func lockScreenView(attributes: AlarmAttributes<SimpleMetadata>, state: AlarmPresentationState) -> some View {
        VStack(spacing: 16) {
            // 标题
            alarmTitle(attributes: attributes, state: state)
            
            // 倒计时和按钮
            bottomView(attributes: attributes, state: state)
        }
        .padding(.all, 16)
    }
    
    // MARK: - 底部视图
    func bottomView(attributes: AlarmAttributes<SimpleMetadata>, state: AlarmPresentationState) -> some View {
        HStack {
            // 倒计时
            countdown(state: state, maxWidth: 150)
                .font(.system(size: 40, design: .rounded))
            
            Spacer()
            
            // 控制按钮
            alarmControls(presentation: attributes.presentation, state: state)
        }
    }
    
    // MARK: - 倒计时显示
    func countdown(state: AlarmPresentationState, maxWidth: CGFloat = .infinity) -> some View {
        Group {
            switch state.mode {
            case .countdown(let countdown):
                Text(timerInterval: Date.now...countdown.fireDate, countsDown: true)
            case .paused(let pausedState):
                let remaining = Duration.seconds(
                    pausedState.totalCountdownDuration - pausedState.previouslyElapsedDuration)
                let pattern: Duration.TimeFormatStyle.Pattern =
                    remaining > .seconds(60 * 60) ? .hourMinuteSecond : .minuteSecond
                Text(remaining.formatted(.time(pattern: pattern)))
            default:
                EmptyView()
            }
        }
        .monospacedDigit()
        .lineLimit(1)
        .minimumScaleFactor(0.6)
        .frame(maxWidth: maxWidth, alignment: .leading)
    }
    
    // MARK: - 标题
    @ViewBuilder func alarmTitle(
        attributes: AlarmAttributes<SimpleMetadata>,
        state: AlarmPresentationState
    ) -> some View {
        let title: LocalizedStringResource? =
            switch state.mode {
            case .countdown:
                attributes.presentation.countdown?.title
            case .paused:
                attributes.presentation.paused?.title
            default:
                nil
            }
        
        Text(title ?? "")
            .font(.title2)
            .fontWeight(.semibold)
            .lineLimit(1)
    }
    
    // MARK: - 控制按钮
    @ViewBuilder func alarmControls(
        presentation: AlarmPresentation,
        state: AlarmPresentationState
    ) -> some View {
        HStack(spacing: 8) {
            switch state.mode {
            case .countdown:
                // 暂停按钮 - 使用 PauseIntent
                ButtonView(
                    config: presentation.countdown?.pauseButton,
                    intent: PauseIntent(alarmID: state.alarmID.uuidString),
                    tint: .orange
                )
            case .paused:
                // 恢复按钮 - 使用 ResumeIntent
                ButtonView(
                    config: presentation.paused?.resumeButton,
                    intent: ResumeIntent(alarmID: state.alarmID.uuidString),
                    tint: .green,
                )
            default:
                EmptyView()
            }
            
            // 停止按钮 - 始终显示
            ButtonView(
                config: presentation.alert.stopButton,
                intent: StopIntent(alarmID: state.alarmID.uuidString),
                tint: .red
            )
        }
    }
    
    // MARK: - 辅助方法
    private func getCurrentFireDate(state: AlarmPresentationState) -> ClosedRange<Date> {
        switch state.mode {
        case .countdown(let countdown):
            return Date.now...countdown.fireDate
        default:
            return Date.now...Date.now
        }
    }
}

// MARK: - LocalizedStringResource 扩展
extension LocalizedStringResource {
    func toString() -> String {
        String(localized: self)
    }
}

// MARK: - ButtonView 组件（支持 AppIntent）
struct ButtonView<I>: View where I: AppIntent {
    var config: AlarmButton
    var intent: I
    var tint: Color
    
    init?(config: AlarmButton?, intent: I, tint: Color) {
        guard let config else { return nil }
        self.config = config
        self.intent = intent
        self.tint = tint
    }
    
    var body: some View {
        Button(intent: intent) {
            Label(config.text, systemImage: config.systemImageName)
                .lineLimit(1)
                .font(.subheadline)  // 稍微缩小字体
        }
        .tint(tint)
        .buttonStyle(.borderedProminent)
        .frame(minWidth: 80, idealWidth: 80, maxWidth: 120, minHeight: 30, maxHeight: 36)  // 允许宽度自适应
    }
}
