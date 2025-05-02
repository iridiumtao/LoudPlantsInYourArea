//
//  DemoViewModel.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//

// DemoViewModel.swift

import Foundation
import Combine

class DemoViewModel: ObservableObject {
    @Published var plantModels: [PlantModel]
    let plantStore: PlantStore
    let overlayPresenter: OverlayPresenter
    let arSession = ARSessionManager.shared

    init() {
        // define models
        let plantModels = [
            PlantModel(id: "1", displayName: "Flytrap (Fixed Greeen Dot)",
                       modelName: "Flytrap with Green Dot",
                       thumbnailName: "flytrap_thumb"),
            PlantModel(id: "2", displayName: "Flytrap (Real Green Dot)",
                       modelName: "Flytrap",
                       thumbnailName: "flytrap_thumb",
                       greenDot: GreenDot(offset: SIMD3<Float>(0.048, 0.296, -0.028),
                                          size: 0.1))
        ]
        self.plantModels = plantModels

        self.plantStore = PlantStore(initialPlants: plantModels)

        self.overlayPresenter = OverlayPresenter(arSession: ARSessionManager.shared,
                                                 plantStore: plantStore)
    }
}
