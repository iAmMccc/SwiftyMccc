

import Foundation
import UIKit
import MapKit

protocol LocationSearchResultViewControllerDelegate: NSObjectProtocol {
    func locationSearchResultViewController(_ vc: LocationSearchResultViewController,
                                      didSelect result: LocationSearchResult)
}

final class LocationSearchResultViewController: UIViewController {

    weak var delegate: LocationSearchResultViewControllerDelegate?
    
    
    func updateSearchKey(_ key: String?, region: MKCoordinateRegion?) {
        service.update(
            query: key ?? "",
            region: region
        )
    }

    var searchRegion: MKCoordinateRegion?

    private let service = LocationSearchService()
    private var results: [MKLocalSearchCompletion] = []


    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "    搜索结果"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .label
        label.textAlignment = .left
        label.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 40)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        tableView.tableHeaderView = headerLabel


        tableView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.left.right.bottom.equalToSuperview()
        }

        service.onResults = { [weak self] list in
            guard let self = self else { return }

            self.results = list
            self.headerLabel.isHidden = list.isEmpty
            self.tableView.reloadData()
        }
    }
}

extension LocationSearchResultViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let item = results[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        cell.accessoryType = .none
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        let completion = results[indexPath.row]
        let request = MKLocalSearch.Request(completion: completion)

        MKLocalSearch(request: request).start { [weak self] response, _ in
            guard
                let self = self,
                let item = response?.mapItems.first
            else { return }
            
            
            /// 经纬度转化
            let coordinate = item.placemark.coordinate

            let result = LocationSearchResult(
                name: item.name ?? completion.title,
                coordinate: coordinate
            )

            self.delegate?.locationSearchResultViewController(self, didSelect: result)
        }
    }
}
