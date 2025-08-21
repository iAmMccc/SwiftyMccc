//
//  RotateEffectViewController.swift
//  McccSymbols_Example
//
//  Created by qixin on 2025/8/21.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class RotateEffectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let config = UIImage.SymbolConfiguration(pointSize: 80)
        let image = UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: config)
        
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
        
        // 1. 顺时针整体旋转，慢速循环
        imageView1.addSymbolEffect(.rotate.wholeSymbol.clockwise, options: .repeating.speed(0.5))
        
        // 2. 逆时针旋转，一次性动画
        imageView2.addSymbolEffect(.rotate.counterClockwise)
        
        // 3. 分层旋转，顺时针，循环
        imageView3.addSymbolEffect(.rotate.byLayer.clockwise, options: .repeating)
    }
    
    // MARK: - 布局
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
    
    // MARK: - ImageViews
    lazy var imageView1: UIImageView = makeImageView()
    lazy var imageView2: UIImageView = makeImageView()
    lazy var imageView3: UIImageView = makeImageView()
    
    func makeImageView() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.gray.cgColor
        return iv
    }
    
    // MARK: - Labels
    lazy var label1: UILabel = makeLabel(text: "整体顺时针旋转 / 慢速 / 循环")
    lazy var label2: UILabel = makeLabel(text: "整体逆时针旋转 / 一次性")
    lazy var label3: UILabel = makeLabel(text: "分层顺时针旋转 / 正常速度 / 循环")
    
    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }
}
