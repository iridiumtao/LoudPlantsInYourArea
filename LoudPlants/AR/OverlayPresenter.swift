//
//  OverlayPresenter.swift
//  LoudPlants
//
//  Created by 歐東 on 5/2/25.
//

import RealityKit
import Combine
import UIKit

final class OverlayPresenter {
    private let arSession: ARSessionManager
    private var cancellables = Set<AnyCancellable>()
    
    init(arSession: ARSessionManager, plantStore: PlantStore) {
        print("init OverlayPresenter")
        self.arSession = arSession
        
        // 1. Monitor focused plant
        arSession.$focusedPlant
            .sink { [weak self] entity in
                self?.showOverlay(for: entity, plantStore: plantStore)
            }
            .store(in: &cancellables)
        
        // 2. Monitor status changes (will connect to PlantStatusService later)
        plantStore.$plants
            .sink { [weak self] _ in
                self?.refreshOverlay(plantStore: plantStore)
            }
            .store(in: &cancellables)
        
        // todo: did not listen to plant status change
    }
    
    private var currentOverlay: Entity?
    
    private func showOverlay(for plantEntity: Entity?, plantStore: PlantStore) {
        currentOverlay?.removeFromParent()
        
        print("showOverlay Called")
        guard
            let plantEntity,
            let model = plantEntity.components[PlantInfoComponent.self]
        else { return }
        
        print("Showing overlay for", plantEntity.name)
        
        // 根據 plantStore 找到完整 Plant
        guard let plant = plantStore.plants.first(where: { $0.id == model.model.id }) else {
            return
        }
        let vm = PlantStatusViewModel(plant: plant)
        let overlay = OverlayFactory.makeBasicStatusCard(for: vm)
        overlay.adjustPosition(for: plantEntity, with: vm)
        plantEntity.addChild(overlay)
        currentOverlay = overlay
    }
    
    private func refreshOverlay(plantStore: PlantStore) {
        print("refreshOverlay Called")
        guard
            let plantEntity = arSession.focusedPlant,
            let info = plantEntity.components[PlantInfoComponent.self],
            let overlay = currentOverlay
        else { return }
        print("Refresing overlay for", info.model)
        
        // Only need to update text or materials, no need to rebuild Entity
        //        let newVM = PlantStatus(model: info.model,
        //                                         status: plantStore.statusFor(id: info.model.id))
        // ...update overlay’s child text entities here
    }
}

extension ModelEntity {
    func adjustPosition(for plantEntity: Entity, with vm: PlantStatusViewModel) {
        // 1. get the visual bounds of the plantEntity itself
        let bounds = plantEntity.visualBounds(relativeTo: plantEntity)
        
        // 2. overlay size from your view model
        let overlayW = vm.overlaySize.x
        let overlayH = vm.overlaySize.y
        
        // 3. padding to separate plant and overlay
        let padding: Float = 0.02
        
        // 4. compute the offsets
        let xOffset = bounds.extents.x + overlayW / 2 + padding
        let yOffset = bounds.extents.y + overlayH / 2 + padding
        let zOffset: Float = 0.01  // small positive z to avoid z-fighting
        
        // 5. set the position relative to plantEntity
        self.position = [ xOffset,
                          yOffset,
                          zOffset ]
    }
}
