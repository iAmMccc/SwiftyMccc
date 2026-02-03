

import UIKit
import MapKit


protocol RegionMapViewDelegate: NSObjectProtocol {
    func regionMapViewRegionWillChanged(view: RegionMapView)
}


class RegionMapView: UIView {
    
    
    weak var delegate: RegionMapViewDelegate?
    
    /// 地图中心
    var centerAnnotation: RegionCenterAnnotation?

    /// 地图当前的可视区域
    var mapRegion: MKCoordinateRegion {
        mapView.region
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        creatUI()
    }
    
    /// 地图
    lazy var mapView: MKMapView = {

        // y轴向上移动，实现地图中心点上移
        let view = MKMapView()
        /// 是否在地图上标注用户位置
        view.showsUserLocation = true
        /// 用户追踪类型
        view.userTrackingMode = .none // none 不追踪， follow 跟踪， followWithHeading 导航跟踪
        
        /* 设置地图配置项 */
        /// 地图类型
        view.mapType = .standard // 标准地图
        /* 地图控制项 */
        view.isScrollEnabled = true
        view.isZoomEnabled = true
        view.isRotateEnabled = false // 是否可以滚动
        view.isPitchEnabled = false // 是否显示3d视角
        /* 设置地图显示项 */
        view.showsBuildings = true // 是否显示建筑物，只影响标准地图
        view.showsTraffic = true // 是否显示交通
        view.showsCompass = true // 是否显示指南针
        view.showsScale = true // 比例尺
        view.delegate = self
        return view
    }()
}



extension RegionMapView {
    
    private func creatUI() {
        addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


