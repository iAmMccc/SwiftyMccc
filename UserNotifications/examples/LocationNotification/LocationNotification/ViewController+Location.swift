//
//  RegionAlarmEidtViewController+Location.swift
//  TimeMaster
//
//  Created by Mccc on 2025/8/26.
//

import Foundation
import CoreLocation
import MapKit


extension ViewController {
    
    func requestLocationQuick() {
        
        let status = locationManager.authorizationStatus
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // 用户还没选择，直接请求授权
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            // 已经授权，开始更新位置
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // 拒绝或受限，可以提示用户去设置
            showLocationDeniedAlert()
        @unknown default:
            break
        }
    }
    
    private func showLocationDeniedAlert() {
        let alert = UIAlertController(
            title: "无法获取位置",
            message: "请在设置中允许访问位置信息",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        present(alert, animated: true)
    }
}

extension ViewController: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else { return }
        manager.stopUpdatingLocation()

        /// 经纬度转化
        let transLocation = location.toMars()
        // ✅ 核心修复
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        let name = "定位的地点"
        let result = LocationSearchResult(name: name, coordinate: transLocation.coordinate)
        self.updateResult(result: result)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.startUpdatingLocation()
        handleAuthorization(manager.authorizationStatus)
    }
    
    private func handleAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("用户允许始终访问")
        case .authorizedWhenInUse:
            print("用户仅允许使用期间访问")
        case .denied:
            print("用户拒绝访问")
        case .restricted:
            print("系统限制访问")
        case .notDetermined:
            print("用户尚未选择")
        @unknown default:
            break
        }
    }
}

// MARK: - CLLocation Extensions
public extension CLLocation {
    
    /// WGS-84 -> GCJ-02（火星坐标）
    func toMars() -> CLLocation {
        let coord = coordinate.toMars()
        return CLLocation(
            coordinate: coord,
            altitude: altitude,
            horizontalAccuracy: horizontalAccuracy,
            verticalAccuracy: verticalAccuracy,
            course: course,
            speed: speed,
            timestamp: timestamp
        )
    }
}
// MARK: - CLLocationCoordinate2D Extensions
public extension CLLocationCoordinate2D {
    
    /// WGS-84 -> GCJ-02（火星坐标）
    func toMars() -> CLLocationCoordinate2D {
        if CLLocationCoordinate2D.outOfChina(latitude: latitude, longitude: longitude) {
            return self
        }
        let a = 6378245.0
        let ee = 0.00669342162296594323
        
        let dLat = CLLocationCoordinate2D.transformLat(x: longitude - 105.0, y: latitude - 35.0)
        let dLon = CLLocationCoordinate2D.transformLon(x: longitude - 105.0, y: latitude - 35.0)
        
        let radLat = latitude / 180.0 * Double.pi
        let magic = 1 - ee * pow(sin(radLat), 2)
        let sqrtMagic = sqrt(magic)
        
        let mgLat = latitude + (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * Double.pi)
        let mgLon = longitude + (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * Double.pi)
        return CLLocationCoordinate2D(latitude: mgLat, longitude: mgLon)
    }

    /// GCJ-02（火星坐标）-> WGS-84
    /// CLCircularRegion / UNLocationNotificationTrigger 使用 WGS-84，设备 GPS 也返回 WGS-84
    /// 在中国区，地图和 MKLocalSearch 使用 GCJ-02，需转回 WGS-84 才能正确触发区域通知
    func toWGS84() -> CLLocationCoordinate2D {
        if CLLocationCoordinate2D.outOfChina(latitude: latitude, longitude: longitude) {
            return self
        }
        var wgs = self
        for _ in 0..<10 {
            let mars = wgs.toMars()
            wgs = CLLocationCoordinate2D(
                latitude: wgs.latitude - (mars.latitude - latitude),
                longitude: wgs.longitude - (mars.longitude - longitude)
            )
        }
        return wgs
    }
}

// MARK: - Helpers
private extension CLLocationCoordinate2D {
    static func outOfChina(latitude: Double, longitude: Double) -> Bool {
        return longitude < 72.004 || longitude > 137.8347 || latitude < 0.8293 || latitude > 55.8271
    }
    
    static func transformLat(x: Double, y: Double) -> Double {
        var ret = -100.0 + 2*x + 3*y
        ret += 0.2*y*y + 0.1*x*y + 0.2*sqrt(abs(x))
        ret += (20*sin(6*x*Double.pi) + 20*sin(2*x*Double.pi)) * 2 / 3
        ret += (20*sin(y*Double.pi) + 40*sin(y/3*Double.pi)) * 2 / 3
        ret += (160*sin(y/12*Double.pi) + 320*sin(y*Double.pi/30)) * 2 / 3
        return ret
    }
    
    static func transformLon(x: Double, y: Double) -> Double {
        var ret = 300.0 + x + 2*y
        ret += 0.1*x*x + 0.1*x*y + 0.1*sqrt(abs(x))
        ret += (20*sin(6*x*Double.pi) + 20*sin(2*x*Double.pi)) * 2 / 3
        ret += (20*sin(x*Double.pi) + 40*sin(x/3*Double.pi)) * 2 / 3
        ret += (150*sin(x/12*Double.pi) + 300*sin(x/30*Double.pi)) * 2 / 3
        return ret
    }
}
