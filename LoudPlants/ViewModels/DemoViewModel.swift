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
        // Define all PlantModels
        let plantModels: [PlantModel] = [
            PlantModel(
                id: "1",
                modelName: "Flytrap with Green Dot",
                thumbnailName: "flytrap"
            ),
            PlantModel(
                id: "2",
                modelName: "Flytrap",
                thumbnailName: "flytrap",
                greenDot: GreenDot(offset: SIMD3<Float>(0.048, 0.296, -0.028), size: 0.1)
            ),
            PlantModel(
                id: "3",
                modelName: "Succulent",
                thumbnailName: "succulent",
                greenDot: GreenDot(offset: SIMD3<Float>(0.048, 0.296, -0.028), size: 0.1)
            )
        ]
        self.plantModels = plantModels

        // Define all Plants referencing PlantModels by ID
        let plants: [Plant] = [
            Plant(
                id: "1",
                name: "Flytrap (Fixed Green Dot)",
                status: .sad,
                model: plantModels.first(where: { $0.id == "1" })!,
                imageName: "flytrap",
                overlaySize: (x: 1.8, y: 0.8)
            ),
            Plant(
                id: "2",
                name: "Flytrap (Real Green Dot)",
                status: .crying,
                model: plantModels.first(where: { $0.id == "2" })!,
                imageName: "flytrap",
                overlaySize: (x: 1.8, y: 0.8)
            ),
            Plant(
                id: "3",
                name: "tbd",
                status: .normal,
                model: plantModels.first(where: { $0.id == "3" })!,
                imageName: "succulent",
                overlaySize: (x: 1.8, y: 0.8)
            )
        ]

        self.plantStore = PlantStore(initialPlants: plants)

        self.overlayPresenter = OverlayPresenter(arSession: ARSessionManager.shared,
                                                 plantStore: plantStore)

    }
}
