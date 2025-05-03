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

        // Convert PlantModel array into Plant instances for the store
        let plants = plantModels.map { model in
            Plant(
                id: model.id,
                name: model.displayName,
                status: .normal,
                model: model,             // default initial status
                imageName: model.thumbnailName,
                overlaySize: (x: 1.0, y: 0.8) // default overlay size
            )
        }

        self.plantStore = PlantStore(initialPlants: plants)

        self.overlayPresenter = OverlayPresenter(arSession: ARSessionManager.shared,
                                                 plantStore: plantStore)
    }
}
