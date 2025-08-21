//
//  AppearEffectViewController.swift
//  McccSymbols_Example
//
//  Created by qixin on 2025/8/20.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit


class AppearEffectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let config = UIImage.SymbolConfiguration(pointSize: 60)
        let image = UIImage(systemName: "wifi", withConfiguration: config)
        
        imageView1.image = image
        imageView2.image = image
        imageView3.image = image
        
        view.addSubview(label1)
        view.addSubview(imageView1)
        view.addSubview(label2)
        view.addSubview(imageView2)
        view.addSubview(label3)
        view.addSubview(imageView3)
        
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        imageView1.addSymbolEffect(.disappear.up.wholeSymbol, options: .speed(0.5))
        imageView2.addSymbolEffect(.disappear.down.byLayer, options: .speed(0.8))
        imageView3.addSymbolEffect(.disappear.up.byLayer, options: .speed(1.0))
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.imageView1.addSymbolEffect(.appear.up.wholeSymbol, options: .speed(0.1))
            self.imageView2.addSymbolEffect(.appear.down.byLayer, options: .speed(0.5))
            self.imageView3.addSymbolEffect(.appear.up.byLayer, options: .speed(1.0))
        }
        
    }

    func setupLayout() {
        let spacing: CGFloat = 40
        let imageSize: CGFloat = 150
        let labelHeight: CGFloat = 20
        let totalHeight = 3 * (labelHeight + imageSize + spacing) - spacing
        let startY = (view.bounds.height - totalHeight) / 2
        
        label1.frame = CGRect(x: 0, y: startY, width: view.bounds.width, height: labelHeight)
        imageView1.frame = CGRect(x: (view.bounds.width - imageSize)/2, y: startY + labelHeight, width: imageSize, height: imageSize)
        
        label2.frame = CGRect(x: 0, y: startY + labelHeight + imageSize + spacing, width: view.bounds.width, height: labelHeight)
        imageView2.frame = CGRect(x: (view.bounds.width - imageSize)/2, y: startY + 2*labelHeight + imageSize + spacing, width: imageSize, height: imageSize)
        
        label3.frame = CGRect(x: 0, y: startY + 2*(labelHeight + imageSize + spacing), width: view.bounds.width, height: labelHeight)
        imageView3.frame = CGRect(x: (view.bounds.width - imageSize)/2, y: startY + 3*labelHeight + 2*imageSize + 2*spacing, width: imageSize, height: imageSize)
    }

    lazy var imageView1 = UIImageView()
    lazy var imageView2 = UIImageView()
    lazy var imageView3 = UIImageView()

    lazy var label1: UILabel = {
        let label = UILabel()
        label.text = "从下出现 / 整体 / 慢速"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.text = "从上出现 / 每层 / 中速"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var label3: UILabel = {
        let label = UILabel()
        label.text = "从下出现 / 每层 / 快速"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}
