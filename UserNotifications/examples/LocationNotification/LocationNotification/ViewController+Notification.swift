//
//  ViewController+Notification.swift
//  LocationNotification
//
//  Created by Mccc on 2026/1/30.
//

import CoreLocation
import UIKit
import UserNotifications

extension ViewController {


    func addRegionNotification(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let regionId = "region.\(UUID().uuidString)"
        let region = CLCircularRegion(center: center, radius: 100, identifier: regionId)
        region.notifyOnEntry = true
        region.notifyOnExit = false

        let content = UNMutableNotificationContent()
        content.title = "到达区域"
        content.body = "您已进入监控区域"
        content.sound = .default

        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        let request = UNNotificationRequest(identifier: regionId, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    let alert = UIAlertController(title: "添加失败", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .default))
                    self?.present(alert, animated: true)
                } else {
                    
                print("区域通知的loacation.lat = \(lat), lon = \(lon)")
                    
                    let alert = UIAlertController(title: "已添加", message: "区域通知已添加，进入该区域时将收到提醒。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
