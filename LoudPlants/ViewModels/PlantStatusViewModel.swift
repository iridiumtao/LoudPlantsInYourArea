//
//  PlantStatusViewModel.swift
//  LoudPlants
//
//  Created by 歐東 on 5/2/25.
//

import UIKit

/// ViewModel 用於 OverlayFactory 排版
struct PlantStatusViewModel {
    let id: String
    let displayName: String
    let statusText: String
    let statusColor: UIColor
    let avatarImage: UIImage?
    let overlaySize: SIMD2<Float>

    init(plant: Plant) {
        self.id = plant.id
        self.displayName = plant.name
        // 以 rawValue 產生顯示文字，可依需求格式化
        self.statusText = plant.status.rawValue.capitalized
        // 根據狀態設定顏色
        switch plant.status {
        case .happy:
            self.statusColor = .green
        case .normal:
            self.statusColor = .gray
        case .sad:
            self.statusColor = .orange
        case .crying:
            self.statusColor = .blue
        }
        // 從 imageName 載入頭像
        self.avatarImage = UIImage(named: plant.imageName)
        // 轉成 SIMD2<Float>
        self.overlaySize = SIMD2<Float>(Float(plant.overlaySize.x),
                                        Float(plant.overlaySize.y))
    }
}
