//
//  OverlayPresenter.swift
//  LoudPlants
//
//  Created by 歐東 on 5/2/25.
//

import RealityKit
import Combine

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


        let vm = PlantStatusViewModel(model: model.model,
                                      status: plantStore.statusFor(id: model.model.id))
        let overlay = OverlayFactory.makeBasicStatusCard(for: vm)
        overlay.position = [0.15, 0.05, 0]
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
        let newVM = PlantStatusViewModel(model: info.model,
                                         status: plantStore.statusFor(id: info.model.id))
        // ...update overlay’s child text entities here
    }
}
