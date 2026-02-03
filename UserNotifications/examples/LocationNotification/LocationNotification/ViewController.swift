//
//  ViewController.swift
//  LocationNotification
//
//  Created by Mccc on 2026/1/30.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
            
    /// 信息结果
    var searchResult: LocationSearchResult = LocationSearchResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        baseSetting()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestLocationQuick()
    }
    
    
    ///
    lazy var mapView: RegionMapView = {
        let view = RegionMapView()
        view.delegate = self
        return view
    }()
    
    private lazy var resultVC: LocationSearchResultViewController = {
        let vc = LocationSearchResultViewController()
        vc.delegate = self
        return vc
    }()
        
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: resultVC)
        controller.searchBar.searchBarStyle = .prominent
        controller.searchBar.placeholder = "搜索或输入地址"
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchResultsUpdater = self
        return controller
    }()

    lazy var locationManager: CLLocationManager = {
        let mgr = CLLocationManager()
        mgr.desiredAccuracy = kCLLocationAccuracyHundredMeters
        mgr.distanceFilter = 50
        mgr.delegate = self
        return mgr
    }()
    
    lazy var locationBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black.withAlphaComponent(0.7)

        let image = UIImage(systemName: "dot.scope")
        btn.setImage(image, for: .normal)
        btn.configuration = .glass()
        btn.addTarget(self, action: #selector(locateToUserEvent), for: .touchUpInside)
        return btn
    }()
}

extension ViewController: LocationSearchResultViewControllerDelegate {
    
    func locationSearchResultViewController(_ vc: LocationSearchResultViewController, didSelect result: LocationSearchResult) {
        updateResult(result: result)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let keyword = searchController.searchBar.text ?? ""
        resultVC.updateSearchKey(keyword, region: mapView.mapRegion)
    }
}

extension ViewController: RegionMapViewDelegate {
    func regionMapViewRegionWillChanged(view: RegionMapView) {
        navigationItem.searchController?.isActive = false
    }
}


extension ViewController {
    
    /// 定位到当前位置
    @objc func locateToUserEvent() {
        requestLocationQuick()
    }
    
    /// 清空所有的区域通知
    @objc func trashRegionNotificationEvent() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// 查询所有的区域通知
    @objc func serachRegionNotificationEvent() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("----------------------------")
            print("当前活跃的区域闹钟信息:")
            
            for request in requests {
                print(" 区域闹钟信息：\(request) \n")
            }
            print("----------------------------")
        }
    }
    
    /// 添加区域通知
    @objc private func addRegionNorificationEvent() {
        
        guard let coordinate = mapView.centerAnnotation?.coordinate else {
            print("error info: centerAnnotation.coordinate 异常")
            return
        }
        
        addRegionNotification(lat: coordinate.latitude, lon: coordinate.longitude)
    }
}

extension ViewController {
    
    private func baseSetting() {
        navigationItem.searchController = searchController
        navigationController?.setToolbarHidden(false, animated: false)
        navigationItem.searchBarPlacementAllowsToolbarIntegration = true
        toolbarItems = [navigationItem.searchBarPlacementBarButtonItem]
        
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(trashRegionNotificationEvent)),
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(serachRegionNotificationEvent))
        ]

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .prominent, target: self, action: #selector(addRegionNorificationEvent))

    }
    
    private func setupUI() {
        
        edgesForExtendedLayout = .all

        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(locationBtn)
        locationBtn.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.width.height.equalTo(36)
            make.bottom.equalTo(-120)
        }

    }
    
    func updateResult(result: LocationSearchResult) {
        searchResult = result

        let coordinate = result.coordinate
        mapView.updateSelectCenter(coordinate: coordinate, name: result.name)
    }
}






/**
 方法一：Xcode 模拟位置（最快）
 在模拟器里
 运行 App（选模拟器，Run）。
 设一个“当前”位置
 模拟器菜单：Features → Location → Custom Location...
 或 Xcode 调试栏里的 定位图标 → Custom Location
 输入经纬度，例如：39.9042（纬度）、116.4074（经度）→ Done。
 在 App 里点 “add region”
 此时“当前位置”就是上面设的经纬度，区域会以该点为圆心、半径 100 米。
 模拟“先离开再进入”
 再打开 Features → Location → Custom Location，改成一个离刚才位置远一点的点，例如：40.0、116.5（相当于在区域外）。
 等几秒。
 再改回 Custom Location 为 39.9042、116.4074（或非常接近，如 39.9045、116.4074），表示“回到区域里”。
 看通知
 系统会认为你“进入”了该区域，应弹出「到达区域」通知（可能稍有延迟，几秒到几十秒）。
 
 */


/**
 二、真机测试流程（按顺序）
 步骤    操作    说明
 1    用数据线连接 iPhone，Xcode 顶部选真机，点击 Run    把 App 装到手机并启动
 2    在手机上允许定位（选「始终」）和通知权限    区域通知需要这两项
 3    在 Xcode 选 Debug → Simulate Location → Beijing（或你的 TestLocation）    真机当前“位置”被设为北京
 4    在手机 App 里点击 「add region」    以当前模拟位置为圆心、半径 100 米添加区域，看到“已添加”即可
 5    在 Xcode 选 Debug → Simulate Location，选其他（如 Apple、City Run 等）    模拟“离开”该区域，等几秒
 6    再选 Debug → Simulate Location → Beijing    模拟“回到”圆心附近，“进入”区域
 7    看手机锁屏 / 通知中心 / 前台是否出现「到达区域」通知    可能有几秒到几十秒延迟

 */
