//
//  VariableColorEffectViewController.swift
//  McccSymbols_Example
//
//  Created by qixin on 2025/8/20.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class VariableColorEffectViewController: UIViewController {
    let config = UIImage.SymbolConfiguration(pointSize: 60)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupImageViews()
        setupLabels()
        layoutViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 第1个：迭代模式 + 渐暗未激活层
        imageView1.addSymbolEffect(.variableColor.iterative.dimInactiveLayers, options: .speed(0.5))
        
        // 第2个：累积模式 + 反向重复
        imageView2.addSymbolEffect(.variableColor.cumulative.reversing, options: .repeating.speed(0.3))
        
        // 第3个：迭代模式 + 隐藏未激活层
        imageView3.addSymbolEffect(.variableColor.iterative.hideInactiveLayers, options: .repeating.speed(0.6))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let image1 = UIImage(systemName: "wifi", variableValue: 0.5, configuration: self.config)!
            self.imageView4.setSymbolImage(image1, contentTransition: .automatic)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let image2 = UIImage(systemName: "wifi", variableValue: 1, configuration: self.config)!
                self.imageView4.setSymbolImage(image2, contentTransition: .automatic)
            }
        }
        
    }
    
    // MARK: - Setup Views
    lazy var imageView1: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.gray.cgColor
        iv.image = UIImage(systemName: "antenna.radiowaves.left.and.right", withConfiguration: config)
        return iv
    }()
    
    lazy var imageView2: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.gray.cgColor
        iv.image = UIImage(systemName: "antenna.radiowaves.left.and.right", withConfiguration: config)
        return iv
    }()
    
    lazy var imageView3: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.gray.cgColor
        iv.image = UIImage(systemName: "antenna.radiowaves.left.and.right", withConfiguration: config)
        return iv
    }()
    
    lazy var imageView4: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.gray.cgColor
        iv.image = UIImage(systemName: "wifi", variableValue: 0, configuration: config)
        return iv
    }()
    
    lazy var label1: UILabel = createLabel(text: "迭代模式 / 渐暗未激活层")
    lazy var label2: UILabel = createLabel(text: "累积模式 / 反向重复")
    lazy var label3: UILabel = createLabel(text: "迭代模式 / 隐藏未激活层")
    
    lazy var label4: UILabel = createLabel(text: "控制可见度")
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }
    
    func setupImageViews() {
        view.addSubview(imageView1)
        view.addSubview(imageView2)
        view.addSubview(imageView3)
        view.addSubview(imageView4)

    }
    
    func setupLabels() {
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
    }
    
    func layoutViews() {
        let spacing: CGFloat = 20
        let imageSize: CGFloat = 100
        let labelHeight: CGFloat = 20
        let totalHeight = 3 * (labelHeight + imageSize + spacing) - spacing
        let startY = (view.bounds.height - totalHeight) / 2
        
        // 布局每组 Label + ImageView
        let views = [(label1, imageView1), (label2, imageView2), (label3, imageView3), (label4, imageView4)]
        for (i, (label, imageView)) in views.enumerated() {
            let yOffset = startY + CGFloat(i) * (labelHeight + imageSize + spacing)
            label.frame = CGRect(x: 0, y: yOffset, width: view.bounds.width, height: labelHeight)
            imageView.frame = CGRect(x: (view.bounds.width - imageSize)/2, y: yOffset + labelHeight, width: imageSize, height: imageSize)
        }
    }
}
