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
    let plantSpecies: String
    let statusText: String
    let statusColor: UIColor
    let avatarImage: UIImage?
    let overlaySize: SIMD2<Float>

    init(plant: Plant) {
        self.id = plant.id
        self.plantNmae = plant.name
        self.plantSpecies = plant.plantSpecies
        
        /// Set image and statusColor
        let defaultImage = UIImage(named: plant.imageName)
        switch plant.status {
        case .happy:
            self.statusColor = .green
            self.statusText = randomPlantMessage(status: .happy, plantName: plant.name)
            self.avatarImage = UIImage(named: plant.imageName+"_good") ?? defaultImage
        case .normal:
            self.statusColor = .green
            self.statusText = randomPlantMessage(status: .normal, plantName: plant.name)
            self.avatarImage = UIImage(named: plant.imageName)
        case .sad:
            self.statusColor = .orange
            self.statusText = randomPlantMessage(status: .sad, plantName: plant.name)
            self.avatarImage = UIImage(named: plant.imageName+"_sad") ?? defaultImage
        case .crying:
            self.statusColor = .red
            self.statusText = randomPlantMessage(status: .crying, plantName: plant.name)
            self.avatarImage = UIImage(named: plant.imageName+"_crying") ?? defaultImage
        }

        self.overlaySize = SIMD2<Float>(Float(plant.overlaySize.x),
                                        Float(plant.overlaySize.y))
        
        func randomPlantMessage(status: PlantStatus, plantName: String) -> String {
            // Mapping each status to its list of description phrases
            let descriptions: [PlantStatus: [String]] = [
                .happy: [
                    "basking in sunlight with joy",
                    "smiling with vibrant green leaves",
                    "standing tall and proud",
                    "radiating warmth to its surroundings",
                    "thriving under gentle morning rays"
                ],
                .normal: [
                    "resting calmly in its pot",
                    "observing surroundings with mild curiosity",
                    "basking quietly under the light",
                    "standing steady and relaxed",
                    "waiting patiently for attention"
                ],
                .sad: [
                    "drooping leaves with a faint sigh",
                    "feeling a bit wilted today",
                    "needing care and extra sunlight",
                    "looking downcast under the shade",
                    "longing for a friendly touch"
                ],
                .crying: [
                    "tears trickling from its green leaves",
                    "feeling lost without enough water",
                    "shaking gently in silent sorrow",
                    "yearning for comfort and warmth",
                    "droplets glistening on its leaves"
                ]
            ]
            
            // Select a random phrase for the given status
            let phrases = descriptions[status] ?? []
            let selectedPhrase = phrases.randomElement() ?? ""
            
            // Construct and return the full message
            return "\(plantName) is \(selectedPhrase)."
        }
    }
    

}
