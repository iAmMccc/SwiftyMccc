//
//  ViewController.swift
//  McccAlarm
//
//  Created by qixin on 2025/10/17.
//

import UIKit
import AlarmKit
import SwiftUI

class ViewController: UIViewController {
    private let alarmManager = AlarmManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        
        Task {
            let state = try await alarmManager.requestAuthorization()
            print("state = \(state)")
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        
        print("点击了")
        // MARK: - 1. 配置闹钟的展示内容（三种状态）
        
        // 状态一：闹钟响起时的展示（Alert）
        // 创建停止按钮，当闹钟响起时显示，点击后停止闹钟
        let stopButton = AlarmButton(text: "结束", textColor: .white, systemImageName: "stop.circle")
        let alert = AlarmPresentation.Alert(title: "你好闹钟", stopButton: stopButton)
        
        // 状态二：倒计时过程中的展示（Countdown）
        // 创建暂停按钮，在倒计时过程中显示，点击后暂停倒计时
        let pauseButton = AlarmButton(text: "暂停", textColor: .black, systemImageName: "pause.circle")
        let countdownContent = AlarmPresentation.Countdown(title: "起床中...", pauseButton: pauseButton)
        
        // 状态三：暂停状态下的展示（Paused）
        // 创建恢复按钮，在暂停状态下显示，点击后恢复倒计时
        let resumeButton = AlarmButton(text: "恢复", textColor: .black, systemImageName: "play.fill")
        let pausedContent = AlarmPresentation.Paused(title: "暂停", resumeButton: resumeButton)
        
        // 组合三种展示状态
        // AlarmPresentation 定义闹钟在不同阶段的展示方式：
        // - alert: 闹钟响起时的界面（显示"你好闹钟"标题和结束按钮）
        // - countdown: 倒计时过程中的界面（显示"起床中..."和暂停按钮）
        // - paused: 暂停状态下的界面（显示"暂停"和恢复按钮）
        let presentation = AlarmPresentation(
            alert: alert,
            countdown: countdownContent,
            paused: pausedContent
        )
        
        // MARK: - 2. 配置闹钟的属性和外观
        
        // AlarmAttributes 包含：
        // - presentation: 上面定义的三种展示状态
        // - metadata: 自定义元数据，包含创建时间等信息
        // - tintColor: 主题色（绿色），用于按钮、进度条等 UI 元素的颜色
        let attributes = AlarmAttributes(
            presentation: presentation,
            metadata: SimpleMetadata(),
            tintColor: Color.green
        )
        
        // MARK: - 3. 设置倒计时时长
        
        // CountdownDuration 参数说明：
        // - preAlert: 5 秒，首次倒计时时长，从开始到第一次闹钟响起的时间
        // - postAlert: 5 秒，贪睡/重复倒计时时长，点击"重复"按钮后再次倒计时的时间间隔
        //   如果设置为 nil，则使用 preAlert 的值
        let countDown = Alarm.CountdownDuration(preAlert: 10, postAlert: 5)
        
        // MARK: - 4. 创建闹钟配置对象
        
        // 将倒计时时长和属性组合成完整的闹钟配置
        let config = AlarmManager.AlarmConfiguration.init(
            countdownDuration: countDown,
            attributes: attributes
        )
        
        // MARK: - 5. 调度并创建闹钟
        
        // 生成唯一的闹钟 ID，用于标识和管理这个闹钟
        let id = UUID()
        
        // 使用异步任务来调度闹钟
        Task {
            // 调用 AlarmManager 调度闹钟，返回创建的 Alarm 对象
            
            do {
                let alarm = try await AlarmManager.shared.schedule(id: id, configuration: config)
                print("✅ 闹钟已创建: \(alarm)")
            } catch {
                print("error = \(error)")
            }
            

            
            // 获取当前所有活跃的闹钟列表
            let alarms = try AlarmManager.shared.alarms
            
            print("📋 当前活跃闹钟数量: \(alarms.count)")
            print("📋 所有闹钟: \(alarms)")
        }
    }


}

