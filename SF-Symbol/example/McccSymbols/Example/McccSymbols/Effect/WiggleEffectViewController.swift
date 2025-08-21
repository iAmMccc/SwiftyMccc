//
//  WiggleEffectViewController.swift
//  McccSymbols_Example
//
//  Created by qixin on 2025/8/20.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class WiggleEffectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 配置 SF Symbol
        let config = UIImage.SymbolConfiguration(pointSize: 80)
        let image = UIImage(systemName: "wifi", withConfiguration: config)
        
        imageView1.image = image
        imageView2.image = image
        imageView3.image = image
        
        // 添加 label 和 imageView
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
        
        // 第1个：整个符号向左摇摆，慢速
        imageView1.addSymbolEffect(.wiggle.wholeSymbol.left, options: .repeating.speed(0.5))
        
        // 第2个：每层顺时针旋转，快速
        imageView2.addSymbolEffect(.wiggle.byLayer.clockwise, options: .repeating.speed(1.0))
        
        // 第3个：自定义角度摇摆 30°
        imageView3.addSymbolEffect(.wiggle.custom(angle: 30).wholeSymbol, options: .repeating.speed(0.8))
    }

    // MARK: - 布局
    func setupLayout() {
        let spacing: CGFloat = 40
        let imageSize: CGFloat = 150
        let labelHeight: CGFloat = 20
        let totalHeight = 3 * (labelHeight + imageSize + spacing) - spacing
        let startY = (view.bounds.height - totalHeight) / 2
        
        // Label 1 + ImageView 1
        label1.frame = CGRect(x: 0,
                              y: startY,
                              width: view.bounds.width,
                              height: labelHeight)
        imageView1.frame = CGRect(x: (view.bounds.width - imageSize)/2,
                                  y: startY + labelHeight,
                                  width: imageSize,
                                  height: imageSize)
        
        // Label 2 + ImageView 2
        label2.frame = CGRect(x: 0,
                              y: startY + labelHeight + imageSize + spacing,
                              width: view.bounds.width,
                              height: labelHeight)
        imageView2.frame = CGRect(x: (view.bounds.width - imageSize)/2,
                                  y: startY + 2*labelHeight + imageSize + spacing,
                                  width: imageSize,
                                  height: imageSize)
        
        // Label 3 + ImageView 3
        label3.frame = CGRect(x: 0,
                              y: startY + 2*(labelHeight + imageSize + spacing),
                              width: view.bounds.width,
                              height: labelHeight)
        imageView3.frame = CGRect(x: (view.bounds.width - imageSize)/2,
                                  y: startY + 3*labelHeight + 2*imageSize + 2*spacing,
                                  width: imageSize,
                                  height: imageSize)
    }

    // MARK: - ImageViews
    lazy var imageView1: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.gray.cgColor
        return iv
    }()
    
    lazy var imageView2: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.gray.cgColor
        return iv
    }()
    
    lazy var imageView3: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.gray.cgColor
        return iv
    }()
    
    // MARK: - Labels
    lazy var label1: UILabel = {
        let label = UILabel()
        label.text = "整个符号向左摇摆 / 慢速"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.text = "每层顺时针旋转 / 快速"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var label3: UILabel = {
        let label = UILabel()
        label.text = "自定义角度 30° / 整个符号"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}
