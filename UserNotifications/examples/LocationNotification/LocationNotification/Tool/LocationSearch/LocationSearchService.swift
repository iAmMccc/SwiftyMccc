
import Foundation
import MapKit

final class LocationSearchService: NSObject {

    private let completer = MKLocalSearchCompleter()
    var onResults: (([MKLocalSearchCompletion]) -> Void)?

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
    }

    func update(query: String, region: MKCoordinateRegion?) {
        if let region = region {
            completer.region = region
        }
        completer.queryFragment = query
    }
}

extension LocationSearchService: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        onResults?(completer.results)
    }

    func completer(_ completer: MKLocalSearchCompleter,
                   didFailWithError error: Error) {
        print("Search error:", error)
    }
}
