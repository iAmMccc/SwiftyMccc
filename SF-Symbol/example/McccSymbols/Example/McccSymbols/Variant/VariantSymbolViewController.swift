//
//  VariantSymbolViewController.swift
//  McccSymbols_Example
//
//  Created by qixin on 2025/8/21.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

// 单个符号项
struct SymbolItem {
    let name: String   // SF Symbol 名称
    let title: String  // 显示的文字
}

// 分组
struct SymbolSection {
    let title: String
    let items: [SymbolItem]
}

class VariantSymbolViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // 数据源：分组 -> [SymbolItem]
    private let data: [SymbolSection] = [
        SymbolSection(title: "填充", items: [
            SymbolItem(name: "house", title: "首页"),
            SymbolItem(name: "house.fill", title: "首页(填充)")
        ]),
        
        
        SymbolSection(title: "形状", items: [
            SymbolItem(name: "heart", title: "喜欢"),
            SymbolItem(name: "heart.circle", title: "喜欢(圆形)"),
            SymbolItem(name: "heart.square", title: "喜欢(方形)"),
        ]),
        
        SymbolSection(title: "徽章", items: [
            SymbolItem(name: "person", title: "好有"),
            SymbolItem(name: "person.badge.plus", title: "好友(添加)"),
            SymbolItem(name: "person.badge.minus", title: "好友(删减)"),
            SymbolItem(name: "person.badge.key", title: "好友(隐秘)"),
        ]),
        
        SymbolSection(title: "方向", items: [
            SymbolItem(name: "arrow", title: "箭头"),
            SymbolItem(name: "arrow.left", title: "箭头(左)"),
            SymbolItem(name: "arrow.right", title: "箭头(右)"),
            SymbolItem(name: "arrow.up", title: "箭头(上)"),
            SymbolItem(name: "arrow.down", title: "箭头(下)"),
            SymbolItem(name: "icloud.and.arrow.down", title: "箭头(下)"),
        ]),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SF Symbols 演示"
        view.backgroundColor = .systemBackground
        
        // 配置 tableView
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
        
        cell.imageView?.image = UIImage(systemName: item.name)
        cell.imageView?.tintColor = .systemBlue   // 改变 SF Symbol 颜色
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    // Section 标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].title
    }
}
