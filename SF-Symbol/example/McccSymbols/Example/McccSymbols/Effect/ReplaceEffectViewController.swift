//
//  ReplaceEffectViewController.swift
//  McccSymbols_Example
//
//  Created by qixin on 2025/8/20.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
class ReplaceEffectViewController: UIViewController {
    let config = UIImage.SymbolConfiguration(pointSize: 80)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        imageView.image = UIImage(systemName: "pause.fill", withConfiguration: config)
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        setupLayout()
        
        label.text = "Replace 动画示例"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 模拟 1 秒后替换符号并播放 Replace 动画
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let palyImage = UIImage(systemName: "play.fill", withConfiguration: self.config)!
            self.imageView.setSymbolImage(palyImage, contentTransition: .replace.offUp)
        }
    }

    // MARK: - 布局
    func setupLayout() {
        let imageSize: CGFloat = 150
        let labelHeight: CGFloat = 20
        let spacing: CGFloat = 40
        let totalHeight = imageSize + labelHeight + spacing
        let startY = (view.bounds.height - totalHeight) / 2
        
        label.frame = CGRect(x: 0, y: startY, width: view.bounds.width, height: labelHeight)
        imageView.frame = CGRect(x: (view.bounds.width - imageSize)/2, y: startY + labelHeight + spacing, width: imageSize, height: imageSize)
    }

    // MARK: - 控件
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.gray.cgColor
        return iv
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()
}
