//
//  AppearanceSymbolViewController.swift
//  McccSymbols_Example
//
//  Created by qixin on 2025/8/21.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

// MARK: - 单个符号项
struct AppearanceSymbolItem {
    let name: String
    let title: String
    let configuration: UIImage.SymbolConfiguration?
}

// 分组
struct AppearanceSymbolSection {
    let title: String
    let items: [AppearanceSymbolItem]
}

class AppearanceSymbolViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // 数据源：展示不同的 pointSize / weight / scale / font / textStyle
    private let data: [AppearanceSymbolSection] = [
        AppearanceSymbolSection(title: "PointSize 对比", items: [
            AppearanceSymbolItem(name: "star", title: "20pt", configuration: UIImage.SymbolConfiguration(pointSize: 20)),
            AppearanceSymbolItem(name: "star", title: "40pt", configuration: UIImage.SymbolConfiguration(pointSize: 40)),
            AppearanceSymbolItem(name: "star", title: "80pt", configuration: UIImage.SymbolConfiguration(pointSize: 80)),
        ]),
        AppearanceSymbolSection(title: "Weight 对比", items: [
            AppearanceSymbolItem(name: "star", title: "UltraLight", configuration: UIImage.SymbolConfiguration(pointSize: 60, weight: .ultraLight)),
            AppearanceSymbolItem(name: "star", title: "Regular", configuration: UIImage.SymbolConfiguration(pointSize: 60, weight: .regular)),
            AppearanceSymbolItem(name: "star", title: "Bold", configuration: UIImage.SymbolConfiguration(pointSize: 60, weight: .bold)),
        ]),
        AppearanceSymbolSection(title: "Scale 对比", items: [
            AppearanceSymbolItem(name: "star", title: "Small", configuration: UIImage.SymbolConfiguration(pointSize: 60, weight: .regular, scale: .small)),
            AppearanceSymbolItem(name: "star", title: "Medium", configuration: UIImage.SymbolConfiguration(pointSize: 60, weight: .regular, scale: .medium)),
            AppearanceSymbolItem(name: "star", title: "Large", configuration: UIImage.SymbolConfiguration(pointSize: 60, weight: .regular, scale: .large)),
        ]),
        AppearanceSymbolSection(title: "Font 对比", items: [
            AppearanceSymbolItem(
                name: "star.fill",
                title: "System 20 Bold",
                configuration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20, weight: .bold))
            ),
            AppearanceSymbolItem(
                name: "star.fill",
                title: "System 40 Regular",
                configuration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 40, weight: .regular))
            ),
        ]),
        AppearanceSymbolSection(title: "TextStyle 对比", items: [
            AppearanceSymbolItem(
                name: "star",
                title: "Headline",
                configuration: UIImage.SymbolConfiguration(textStyle: .headline)
            ),
            AppearanceSymbolItem(
                name: "star",
                title: "Body",
                configuration: UIImage.SymbolConfiguration(textStyle: .body)
            ),
        ]),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SF Symbols 外观调整"
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].items.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = data[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let config = item.configuration {
            cell.imageView?.image = UIImage(systemName: item.name, withConfiguration: config)
        } else {
            cell.imageView?.image = UIImage(systemName: item.name)
        }
        cell.imageView?.tintColor = .systemBlue
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].title
    }
}
