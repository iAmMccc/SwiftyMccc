//
//  RenderingModeViewController.swift
//  McccSymbols_Example
//
//  Created by qixin on 2025/8/21.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

// 渲染模式示例
struct RenderingModeItem {
    let name: String   // SF Symbol 名称
    let title: String  // 显示文字
    let configuration: UIImage.SymbolConfiguration?
}

struct RenderingModeSection {
    let title: String
    let items: [RenderingModeItem]
}

class RenderingModeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let data: [RenderingModeSection] = [
        RenderingModeSection(title: "单色 Monochrome", items: [
            RenderingModeItem(name: "person", title: "系统蓝色", configuration: nil),
            RenderingModeItem(name: "person", title: "自定义红色", configuration: UIImage.SymbolConfiguration(hierarchicalColor: .red)),
        ]),
        RenderingModeSection(title: "分层 Hierarchical", items: [
            RenderingModeItem(
                name: "externaldrive.badge.plus",
                title: "分层蓝",
                configuration: UIImage.SymbolConfiguration(hierarchicalColor: .systemBlue)
            )
        ]),
        RenderingModeSection(title: "多色 Multicolor", items: [
            RenderingModeItem(
                name: "calendar.badge.checkmark",
                title: "多色",
                configuration: UIImage.SymbolConfiguration.preferringMulticolor()
            )
        ]),
        RenderingModeSection(title: "调色盘 Palette", items: [
            RenderingModeItem(
                name: "person.3.sequence.fill",
                title: "红绿蓝",
                configuration: UIImage.SymbolConfiguration(paletteColors: [.systemRed, .systemGreen, .systemBlue])
            )
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SF Symbols 渲染模式"
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
            // 普通单色符号，默认使用tintColor
            cell.imageView?.image = UIImage(systemName: item.name)
        }
        
        // 修改颜色演示
        cell.imageView?.tintColor = .systemBlue
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].title
    }
}
