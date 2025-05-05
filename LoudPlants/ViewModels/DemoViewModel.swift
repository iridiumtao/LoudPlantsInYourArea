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
    @Published var plantEntities: [PlantEntity]
    let plantStore: PlantStore
    let overlayPresenter: OverlayPresenter
    let arSession = ARSessionManager.shared

    init() {
        // define models
        // Define all PlantEntitys
        let plantEntities: [PlantEntity] = [
            PlantEntity(
                id: "1",
                modelName: "Flytrap",
                thumbnailName: "flytrap"
            ),
            PlantEntity(
                id: "2",
                modelName: "Sad Plant",
                thumbnailName: "flytrap_crying",
                greenDot: GreenDot(offset: SIMD3<Float>(0.048, 0.296, -0.028), size: 0.5)
            ),
            PlantEntity(
                id: "3",
                modelName: "Happy Plant",
                thumbnailName: "succulent",
                greenDot: GreenDot(offset: SIMD3<Float>(0.048, 0.296, -0.028), size: 0.5)
            )
        ]
        self.plantEntities = plantEntities

        // Define all Plants referencing PlantEntitys by ID
        let plants: [Plant] = [
            Plant(
                id: "1",
                name: "Fake Stark",
                plantSpecies: "Venus Flytrap",
                status: .sad,
                model: plantEntities.first(where: { $0.id == "1" })!,
                imageName: "flytrap",
                overlaySize: (x: 0.9, y: 0.4)
            ),
            Plant(
                id: "2",
                name: "Stark",
                plantSpecies: "Venus Flytrap",
                status: .crying,
                model: plantEntities.first(where: { $0.id == "2" })!,
                imageName: "flytrap",
                overlaySize: (x: 0.9, y: 0.4)
            ),
            Plant(
                id: "3",
                name: "Peter",
                plantSpecies: "Succulents",
                status: .happy,
                model: plantEntities.first(where: { $0.id == "3" })!,
                imageName: "succulent",
                overlaySize: (x: 0.9, y: 0.4)
            )
        ]

        self.plantStore = PlantStore(initialPlants: plants)

        self.overlayPresenter = OverlayPresenter(arSession: ARSessionManager.shared,
                                                 plantStore: plantStore)

    }
}
