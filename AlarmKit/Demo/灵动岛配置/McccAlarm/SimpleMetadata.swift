//
//  SimpleMetadata.swift
//  McccAlarm_Example
//
//  Created by qixin on 2025/10/17.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import AlarmKit
// MARK: - SimpleMetadata 定义
// ⚠️ 重要：这个定义需要与主 App 中的 SimpleMetadata 完全一致
struct SimpleMetadata: AlarmMetadata {
    let createdAt: Date
    
    init() {
        self.createdAt = Date.now
    }
}
