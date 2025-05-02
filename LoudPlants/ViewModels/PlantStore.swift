//
//  PlantStore.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//
import SwiftUI

class PlantStore: ObservableObject {
    @Published var plants: [PlantModel] = []
    @Published var statuses: [String: PlantStatus] = [:]

    init(initialPlants: [PlantModel] = []) {
        self.plants = initialPlants
        // Initialize default statuses (e.g., Healthy)
        for plant in plants {
            statuses[plant.id] = PlantStatus(text: "Unknown", color: .gray)
        }
    }

    /// Returns the status for a given plant ID, or a default if missing
    func statusFor(id: String) -> PlantStatus {
        return statuses[id] ?? PlantStatus(text: "Unknown", color: .gray)
    }

    /// Update status for plant with given ID
    func updateStatus(for id: String, to newStatus: PlantStatus) {
        statuses[id] = newStatus
    }
}
