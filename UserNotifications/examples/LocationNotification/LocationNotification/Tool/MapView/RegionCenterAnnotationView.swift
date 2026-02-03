
import Foundation
import MapKit

final class RegionCenterAnnotationView: MKMarkerAnnotationView {

    static let reuseID = "RegionCenterAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        markerTintColor = .systemRed
        glyphImage = UIImage(systemName: "mappin")
        canShowCallout = true
        titleVisibility = .visible
    }
}
