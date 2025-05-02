//
//  PlantStatusViewModel.swift
//  LoudPlants
//
//  Created by 歐東 on 5/2/25.
//

import UIKit

/// Raw status coming from backend or mock service
public struct PlantStatus {
    public let text: String
    public let color: UIColor
}

/// View‑friendly projection for overlay text & color
public struct PlantStatusViewModel {
    public let displayName: String
    public let statusText: String
    public let statusColor: UIColor

    init(model: PlantModel, status: PlantStatus) {
        self.displayName = model.displayName
        self.statusText  = status.text
        self.statusColor = status.color
    }
}
