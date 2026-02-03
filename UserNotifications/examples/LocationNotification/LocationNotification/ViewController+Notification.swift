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
        // 区域通知在应用关闭/后台时需「始终」定位权限才能触发
        guard locationManager.authorizationStatus == .authorizedAlways else {
            let alert = UIAlertController(
                title: "需要定位权限",
                message: "区域通知在您离开应用后仍需监控位置。请在设置中允许「始终」访问位置信息。",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            present(alert, animated: true)
            return
        }

        // 地图/搜索在中国使用 GCJ-02，但 CLCircularRegion 和设备 GPS 使用 WGS-84
        // 必须转为 WGS-84，否则在中国区会出现几百米偏移，导致通知不触发
        let displayCoord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let wgs84Coord = displayCoord.toWGS84()

        let center = wgs84Coord
        let regionId = "region.\(UUID().uuidString)"
        let radius: CLLocationDistance = 200  // 200m，略大于最小 100m，提高触发可靠性；与地图 overlay 显示一致
        let region = CLCircularRegion(center: center, radius: radius, identifier: regionId)
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
                    print("区域通知已添加 WGS-84: lat=\(center.latitude), lon=\(center.longitude), 半径=\(radius)m")
                    let alert = UIAlertController(title: "已添加", message: "区域通知已添加，进入该区域时将收到提醒。请确保定位权限为「始终」。", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}
