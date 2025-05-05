//
//  ARSessionManager.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//

import RealityKit
import ARKit
import Combine
import simd
import Foundation
import SwiftUI

/// Stores original PlantEntity on placed Entity
struct PlantInfoComponent: Component {
    let model: PlantEntity
}

/// Manages a single ARView & handles raycasts + anchor placement
final class ARSessionManager: ObservableObject {
    static let shared = ARSessionManager()
    @AppStorage("plantVisibilityEnabled") private var plantVisibilityEnabled: Bool = true
    
    


    /// The ARView we drive
    let arView: ARView
    private var cameraAnchor: AnchorEntity

    // MARK: – Runtime state
    @Published var focusedPlant: Entity?
    private var placedPlants: [Entity] = []
    private var updateCancellable: Cancellable?

    private init() {
        arView = ARView(frame: .zero)
        
        // init camera anchor
        cameraAnchor = AnchorEntity(.camera)
        arView.scene.addAnchor(cameraAnchor)
        
        configureSession()
        
        startDistanceTracking()
    }

    private func configureSession() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }

    /// Raycast from screen center and place the specified model
    func placeModel(_ plant: Plant) {
        let center = arView.center
        guard let query = arView.makeRaycastQuery(from: center,
                                                  allowing: .estimatedPlane,
                                                  alignment: .any),
              let result = arView.session.raycast(query).first else {
            print("⚠️ Raycast failed")
            return
        }

        let anchor = AnchorEntity(world: result.worldTransform)
        do {
            // For .reality files use:
            // let plantEntity = try Entity.load(named: model.modelName)
            
            // For USDZ models use:
            let plantModelEntity = try Entity.load(named: plant.entity .modelName)
            let plantEntity = plant.entity
            plantModelEntity.components.set(PlantInfoComponent(model: plantEntity))
            plantModelEntity.setVisibility(plantVisibilityEnabled)
            
            placedPlants.append(plantModelEntity)
            
            
            switch plant.status {
            case .happy:
                if let dotConfig = plantEntity.greenDot,
                   let dotEntity = try? Entity.load(named: "Green Dot" + ".usdz") {
                    dotEntity.name = "statusDot"
                    dotEntity.scale = SIMD3<Float>(repeating: dotConfig.size)
                    dotEntity.position = dotConfig.offset
                    dotEntity.components.set(BillboardComponent())
                    plantModelEntity.addChild(dotEntity)
                }
            case .crying:
                if let dotConfig = plantEntity.greenDot,
                   let dotEntity = try? Entity.load(named: "Orange Dot" + ".usdz") {
                    dotEntity.name = "statusDot"
                    dotEntity.scale = SIMD3<Float>(repeating: dotConfig.size)
                    dotEntity.position = dotConfig.offset
                    dotEntity.components.set(BillboardComponent())
                    plantModelEntity.addChild(dotEntity)
                }
            default:
                if let dotConfig = plantEntity.greenDot,
                   let dotEntity = try? Entity.load(named: "Green Dot" + ".usdz") {
                    dotEntity.name = "statusDot"
                    dotEntity.scale = SIMD3<Float>(repeating: dotConfig.size)
                    dotEntity.position = dotConfig.offset
                    dotEntity.components.set(BillboardComponent())
                    plantModelEntity.addChild(dotEntity)
                }
            }

            anchor.addChild(plantModelEntity)
            arView.scene.addAnchor(anchor)
        } catch {
            print("❌ Failed to load model '\(plant.entity.modelName)': \(error)")
        }
    }

    // MARK: – Camera‑distance focus logic
    private func startDistanceTracking() {
        updateCancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { [weak self] _ in
            self?.updateFocusPlant()
        }
    }

    private func updateFocusPlant() {
        let camPos = arView.cameraTransform.translation
        var nearest: Entity?
        var nearestDist: Float = .greatestFiniteMagnitude

        for entity in placedPlants {
            let d = distance(entity.position(relativeTo: nil), camPos)
            if d < 5.6, d < nearestDist {         // 0.6 m trigger
                nearest = entity
                nearestDist = d
            }
        }

        if nearest?.id != focusedPlant?.id {
            print("Focused plant changed: \(String(describing: nearest?.id))")
            focusedPlant = nearest
        }
    }
}
extension Entity {
    /// Recursively collect this entity and all descendants
    private var allEntities: [Entity] {
        return [self] + children.flatMap { $0.allEntities }
    }

    /// Set visibility by adjusting material alpha (0 = invisible, 1 = fully visible)
    func setVisibility(_ visible: Bool) {
        // Iterate through this entity and all descendants
        for entity in allEntities {
            if let modelEntity = entity as? ModelEntity,
               let materials = modelEntity.model?.materials {
                if visible {
                    // Do nothing when making visible (materials remain as is)
                } else {
                    // Replace all materials with fully transparent material
                    let transparentMaterials = materials.map { _ in
                        var mat = UnlitMaterial()
                        mat.blending = .transparent(opacity: 0.0)
                        return mat
                    }
                    modelEntity.model?.materials = transparentMaterials
                }
            }
        }
    }
}
