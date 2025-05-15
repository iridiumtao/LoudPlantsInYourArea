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
    @Published var plants: [Plant]
    let plantStore: PlantStore
    let overlayPresenter: OverlayPresenter
    let arSession = ARSessionManager.shared

    init() {
        // define models
        // Define all PlantEntitis
        let greenDotOffset = SIMD3<Float>(0.048, 0.296, -0.028)
        let greenDotSize: Float = 0.3

        let plantEntities: [PlantEntity] = [
            PlantEntity(
                id: "1",
                modelName: "Flytrap with Green Dot",
                thumbnailName: "flytrap"
                // no greenDot because modelName contains "Green Dot"
            ),
            PlantEntity(
                id: "2",
                modelName: "Flytrap",
                thumbnailName: "flytrap",
                greenDot: GreenDot(offset: SIMD3<Float>(0.048, 0.296, -0.028), size: 0.3) // only Flytrap gets a green dot
            ),

            PlantEntity(
                id: "3",
                modelName: "Succulent",
                thumbnailName: "succulent",
                greenDot: GreenDot(offset: SIMD3<Float>(0.048, 0.596, -0.028), size: 0.3) // succulent without background also gets a green dot
            ),

            PlantEntity(
                id: "5",
                modelName: "Happy Plant WoZ", // hidden plant
                thumbnailName: "succulent",
            ),
            PlantEntity(
                id: "6",
                modelName: "Sad Plant WoZ", // hidden plant
                thumbnailName: "flytrap",
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
                entity: plantEntities.first(where: { $0.modelName == "Flytrap with Green Dot" })!,
                imageName: "flytrap",
                overlaySize: (x: 0.9, y: 0.4)
            ),
            Plant(
                id: "2",
                name: "Stark",
                plantSpecies: "Venus Flytrap",
                status: .happy,
                entity: plantEntities.first(where: { $0.modelName == "Flytrap" })!,
                imageName: "flytrap",
                overlaySize: (x: 0.9, y: 0.4)
            ),
            Plant(
                id: "3",
                name: "Peter",
                plantSpecies: "Succulents",
                status: .happy,
                entity: plantEntities.first(where: { $0.modelName == "Succulent" })!,
                imageName: "succulent",
                overlaySize: (x: 0.9, y: 0.4)
            ),
            Plant(
                id: "5",
                name: "Happy Peter",
                plantSpecies: "succulent",
                status: .happy,
                entity: plantEntities.first(where: { $0.modelName == "Happy Plant WoZ" })!,
                imageName: "succulent",
                overlaySize: (x: 0.9, y: 0.4)
            ),
            Plant(
                id: "6",
                name: "Sad Stark",
                plantSpecies: "Venus Flytrap",
                status: .sad,
                entity: plantEntities.first(where: { $0.modelName == "Sad Plant WoZ" })!,
                imageName: "flytrap",
                overlaySize: (x: 0.9, y: 0.4)
            ),
        ]
        
        self.plantStore = PlantStore(initialPlants: plants)
        self.plants = plants

        self.overlayPresenter = OverlayPresenter(arSession: ARSessionManager.shared,
                                                 plantStore: plantStore)

    }
}
