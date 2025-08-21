//
//  PluseEffectViewController.swift
//  McccSymbols_Example
//
//  Created by qixin on 2025/8/20.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class PulseEffectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // 设置每个 imageView 的符号
        let config = UIImage.SymbolConfiguration(pointSize: 60)
        let image = UIImage(systemName: "person.3.sequence.fill", withConfiguration: config)
        
        imageView1.image = image
        imageView2.image = image
        imageView3.image = image
        
        // 添加三个 imageView 和 label
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
        
        // 第1个：整体脉冲，循环
        imageView1.addSymbolEffect(.pulse.wholeSymbol, options: .repeating.speed(0.2))
        
        // 第2个：按每个层脉冲，循环
        imageView2.addSymbolEffect(.pulse.byLayer, options: .repeating.speed(0.2))
        
        // 第3个：整体脉冲，一次性动画
        imageView3.addSymbolEffect(.pulse.wholeSymbol, options: .nonRepeating.speed(0.2))
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
        label.text = "整体脉冲 / 慢速 / 循环"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.text = "按每层脉冲 / 慢速 / 循环"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var label3: UILabel = {
        let label = UILabel()
        label.text = "整体脉冲 / 一次性"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}
