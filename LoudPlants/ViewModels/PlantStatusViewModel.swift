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
    let plantNmae: String
    let statusText: String
    let statusColor: UIColor
    let avatarImage: UIImage?
    let overlaySize: SIMD2<Float>

    init(plant: Plant) {
        self.id = plant.id
        self.plantNmae = plant.name
        // 以 rawValue 產生顯示文字，可依需求格式化
        self.statusText = plant.status.rawValue.capitalized
        
        /// Set image and statusColor
        let defaultImage = UIImage(named: plant.imageName)
        switch plant.status {
        case .happy:
            self.statusColor = .green
            self.avatarImage = UIImage(named: plant.imageName+"_good") ?? defaultImage
        case .normal:
            self.statusColor = .green
            self.avatarImage = UIImage(named: plant.imageName)
        case .sad:
            self.statusColor = .orange
            self.avatarImage = UIImage(named: plant.imageName+"_sad") ?? defaultImage
        case .crying:
            self.statusColor = .red
            self.avatarImage = UIImage(named: plant.imageName+"_crying") ?? defaultImage
        }

        self.overlaySize = SIMD2<Float>(Float(plant.overlaySize.x),
                                        Float(plant.overlaySize.y))
    }
}
