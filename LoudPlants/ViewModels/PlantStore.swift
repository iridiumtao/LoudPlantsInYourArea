//
//  PlantStore.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//
import SwiftUI

/// PlantStore manages the collection of Plant objects used throughout the app.
/// It acts as the single source of truth for all Plant data and provides methods
/// to update a plant's status, notifying views of changes via Combine.
class PlantStore: ObservableObject {
    @Published var plants: [Plant] = []

    init(initialPlants: [Plant] = []) {
        self.plants = initialPlants
    }

    /// Update the status of the plant with the given ID
    func updateStatus(for id: String, to newStatus: PlantStatus) {
        guard let index = plants.firstIndex(where: { $0.id == id }) else { return }
        plants[index].status = newStatus
    }
}
