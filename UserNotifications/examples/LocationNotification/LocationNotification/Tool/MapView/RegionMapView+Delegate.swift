

import Foundation
import MapKit

extension RegionMapView: MKMapViewDelegate {
    
    /** 显示区域改变会调用 (移动地图（手指停止移动时调用）) 挪动地图时候，center没有变，变的是span
     */
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let coordinate = mapView.centerCoordinate
//        BTPrivacy.Geocoder.reverseGeocode(longitude: coordinate.longitude, latitude: coordinate.latitude) { address in
////            self.updateSelectCenter(coordinate: coordinate, name: address.street + address.name)
//            
//        }
//    }

    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        delegate?.regionMapViewRegionWillChanged(view: self)
    }
    
    // 渲染遮罩可见。只有设置 MapKit 才会去显示这些遮罩
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
        // 描边颜色
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 1
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard annotation is RegionCenterAnnotation else { return nil }

        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: RegionCenterAnnotationView.reuseID
        ) as? RegionCenterAnnotationView
        ?? RegionCenterAnnotationView(
            annotation: annotation,
            reuseIdentifier: RegionCenterAnnotationView.reuseID
        )

        view.annotation = annotation
        return view
    }

}

// MARK: - 展示图层渲染
extension RegionMapView {

    func updateSelectCenter(coordinate: CLLocationCoordinate2D, name: String) {
        
        let radius: CGFloat = 200
        // 设置到中心点
        updateMapCenter(on: coordinate, withRadius: radius)
        updateAnnotation(coordinate: coordinate, overlayLayerRadius: radius, name: name)
        updateOverlay(coordinate2d: coordinate, overlayLayerRadius: radius)
    }

    
    private func updateAnnotation(coordinate: CLLocationCoordinate2D, overlayLayerRadius: CGFloat, name: String) {

        if let annotation = centerAnnotation {
            annotation.coordinate = coordinate
            annotation.title = name
        } else {
            let annotation = RegionCenterAnnotation(coordinate: coordinate, title: name)
            centerAnnotation = annotation
            mapView.addAnnotation(annotation)
        }
    }


    
    // 1. 添加overlay遮罩
    private func updateOverlay(coordinate2d: CLLocationCoordinate2D, overlayLayerRadius: Double?) {
        removeOverlay()
        guard let radius = overlayLayerRadius else { return }

        let overlay = MKCircle(center: coordinate2d, radius: radius)
        mapView.addOverlay(overlay)
    }

    private func removeOverlay() {
        for overlay in mapView.overlays {
            if overlay.isKind(of: MKCircle.self) {
                mapView.removeOverlay(overlay)
            }
        }
    }
    
    /// 将地图中心移动到指定位置，并以指定米数缩放
    private func updateMapCenter(on coordinate: CLLocationCoordinate2D, withRadius overlayLayerRadius: Double) {
                
        let mapMeters = overlayLayerRadius * 2 / 0.8 // 保证圆直径占屏幕宽度 80%
        
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: mapMeters,
                                        longitudinalMeters: mapMeters)
        
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
    }
}

