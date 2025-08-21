//
//  ScaleEffectViewController.swift
//  McccSymbols_Example
//
//  Created by qixin on 2025/8/20.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ScaleEffectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let config = UIImage.SymbolConfiguration(pointSize: 80)
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
        
        // 第1个：整体缩放，慢速
        imageView1.addSymbolEffect(.scale.wholeSymbol, options: .speed(0.5))
        
        // 第2个：每层缩放，慢速度，向上
        imageView2.addSymbolEffect(.scale.byLayer.up, options: .speed(0.5))
        
        // 第3个：每层缩放，慢速度，向下
        imageView3.addSymbolEffect(.scale.byLayer.down, options: .speed(0.5))
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            self.imageView1.removeSymbolEffect(ofType: .scale)
            self.imageView2.removeSymbolEffect(ofType: .scale)
//            self.imageView3.removeSymbolEffect(ofType: .scale)
        }
    }
    
    // MARK: - 布局
    func setupLayout() {
        let spacing: CGFloat = 40
        let imageSize: CGFloat = 150
        let labelHeight: CGFloat = 20
        let totalHeight = 3 * (labelHeight + imageSize + spacing) - spacing
        let startY = (view.bounds.height - totalHeight) / 2
        
        label1.frame = CGRect(x: 0, y: startY, width: view.bounds.width, height: labelHeight)
        imageView1.frame = CGRect(x: (view.bounds.width - imageSize)/2,
                                  y: startY + labelHeight,
                                  width: imageSize, height: imageSize)
        
        label2.frame = CGRect(x: 0,
                              y: startY + labelHeight + imageSize + spacing,
                              width: view.bounds.width,
                              height: labelHeight)
        imageView2.frame = CGRect(x: (view.bounds.width - imageSize)/2,
                                  y: startY + 2*labelHeight + imageSize + spacing,
                                  width: imageSize, height: imageSize)
        
        label3.frame = CGRect(x: 0,
                              y: startY + 2*(labelHeight + imageSize + spacing),
                              width: view.bounds.width,
                              height: labelHeight)
        imageView3.frame = CGRect(x: (view.bounds.width - imageSize)/2,
                                  y: startY + 3*labelHeight + 2*imageSize + 2*spacing,
                                  width: imageSize, height: imageSize)
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
        label.text = "整体缩放 / 慢速 / 循环"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    lazy var label2: UILabel = {
        let label = UILabel()
        label.text = "每层缩放 / 正常速度 / 循环"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    lazy var label3: UILabel = {
        let label = UILabel()
        label.text = "整体缩放 / 快速 / 循环"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}
