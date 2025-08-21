//
//  ViewController.swift
//  McccSymbols
//
//  Created by iAmMccc on 08/19/2025.
//  Copyright (c) 2025 iAmMccc. All rights reserved.
//

import UIKit

/**
  如何让UIButton支持
 
 */


class ViewController: UIViewController {
    
    
    var dataArray: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SF Symbols"
        
        dataArray = [
            symbol_variant,
            symbol_appearance,
            symbol_rendering,
            symbol_effect,
        ]
        
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.reloadData()
    }
    
    lazy var tableView = UITableView.make(registerCells: [UITableViewCell.self], delegate: self, style: .grouped)
}


extension ViewController {
    
    var symbol_variant: [String: Any] {
        [
            "title": "符号变体",
            "list": [
                ["name": "variant", "vc": "VariantSymbolViewController"],
            ]

        ]
    }
    
    var symbol_appearance: [String: Any] {
        [
            "title": "符号外观",
            "list": [
                ["name": "appearance", "vc": "AppearanceSymbolViewController"],
            ]

        ]
    }
    
    
    var symbol_rendering: [String: Any] {
        [
            "title": "渲染方式",
            "list": [
                ["name": "rendering", "vc": "RenderingModeViewController"],
            ]

        ]
    }
    
    
    
    var symbol_effect: [String: Any] {
        [
            "title": "动画效果",
            "list": [
                ["name": "Bounce", "vc": "BounceEffectViewController"],
                ["name": "Pluse", "vc": "PulseEffectViewController"],
                ["name": "Scale", "vc": "ScaleEffectViewController"],
                ["name": "VariableColor", "vc": "VariableColorEffectViewController"],
                ["name": "Wiggle", "vc": "WiggleEffectViewController"],
                ["name": "Appear", "vc": "AppearEffectViewController"],
                ["name": "Disappear", "vc": "DisappearEffectViewController"],
                ["name": "Replace", "vc": "ReplaceEffectViewController"],
                ["name": "Rotate", "vc": "RotateEffectViewController"],
                ["name": "Breathe", "vc": "BreatheEffectViewController"],

                
                ["name": "混合动画", "vc": "FixEffectViewController"],


            ]

        ]
    }
    
}




extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dict = dataArray[section~] {
            let list = dict["list"] as? [[String: String]] ?? []
            return list.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        if let dict = dataArray[section~] {
            let title = dict["title"] as? String ?? ""
            label.text = "    " + title
        }
        
        return label
    }

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.makeCell(indexPath: indexPath)
        
        if let dict = dataArray[indexPath.section~] {

            let list = dict["list"] as? [[String: String]] ?? []
            
            let inDict = list[indexPath.row~] ?? [:]
            cell.textLabel?.text = inDict["name"] ?? ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        guard let dict = dataArray[indexPath.section~] else { return }
        guard let list = dict["list"] as? [[String: String]] else { return }
        guard let inDict = list[indexPath.row~] else { return }

        let vcStr = inDict["vc"] ?? ""
        let name = inDict["name"] ?? ""
        guard let vc = createViewControllerObject(form: vcStr) else { return }
        vc.title = name
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}



extension ViewController {
    
    func createViewControllerObject(form className: String) -> UIViewController? {
        let projectName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        let classStringName = projectName + "." + className
        if let viewControllerClass = NSClassFromString(classStringName) as? UIViewController.Type {
            let viewController = viewControllerClass.init()
            return viewController
        } else {
            return nil
        }
    }
}
