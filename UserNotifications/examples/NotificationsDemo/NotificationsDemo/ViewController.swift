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
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
        }
        
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            // granted = 用户是否授权
        }
    }


}

