
import Foundation
import MapKit

final class RegionCenterAnnotation: NSObject, MKAnnotation {

    dynamic var coordinate: CLLocationCoordinate2D

    /// POI 名称（如 永旺梦乐城）
    dynamic var title: String?

    /// 原始 MapItem（搜索 / 定位来源）
    let mapItem: MKMapItem?

    init(mapItem: MKMapItem) {
        self.coordinate = mapItem.placemark.coordinate
        self.title = mapItem.name
        self.mapItem = mapItem
        super.init()
    }

    init(coordinate: CLLocationCoordinate2D,
         title: String?) {

        self.coordinate = coordinate
        self.title = title
        self.mapItem = nil
        super.init()
    }
}
