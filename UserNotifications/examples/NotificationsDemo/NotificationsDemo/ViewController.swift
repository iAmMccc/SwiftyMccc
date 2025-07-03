//
//  ViewController.swift
//  NotificationsDemo
//
//  Created by qixin on 2025/6/26.
//

import UIKit
import UserNotifications


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print(settings.authorizationStatus)
        }
        
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            // granted = 用户是否授权
        }
        
        let center = UNUserNotificationCenter.current()

        // 1. 通知内容
        let content = UNMutableNotificationContent()
        content.title = "📌 每日一句"
        content.body = "每一个不曾起舞的日子，都是对生命的辜负"
        content.sound = .default
        content.categoryIdentifier = "DAILY_QUOTES"

        // 2. 通知触发器（比如10秒后）
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        // 3. 通知请求
        let request = UNNotificationRequest(identifier: "quote_001", content: content, trigger: trigger)

        // 4. 添加通知
        center.add(request)
    }


}

// MARK: - UNUserNotificationCenterDelegate
extension ViewController: UNUserNotificationCenterDelegate {
    // App 在前台时，收到通知后走这个回调
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 告诉系统：即使在前台，也要展示通知（横幅、声音、角标）
        completionHandler([.banner, .sound])
    }
}
