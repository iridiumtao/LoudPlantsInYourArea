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

/// Stores original PlantModel on placed Entity
struct PlantInfoComponent: Component {
    let model: PlantModel
}

/// Manages a single ARView & handles raycasts + anchor placement
final class ARSessionManager: ObservableObject {
    static let shared = ARSessionManager()

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
    func placeModel(_ plant: PlantModel) {
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
            let plantEntity = try Entity.load(named: plant.modelName + ".usdz")
            plantEntity.components.set(PlantInfoComponent(model: plant))
            placedPlants.append(plantEntity)
            
            if let dotConfig = plant.greenDot,
               let dotEntity = try? Entity.load(named: "Green Dot" + ".usdz") {
                dotEntity.name = "statusDot"
                dotEntity.scale = SIMD3<Float>(repeating: dotConfig.size)
                dotEntity.position = dotConfig.offset
                dotEntity.components.set(BillboardComponent())
                plantEntity.addChild(dotEntity)
            }
            
            anchor.addChild(plantEntity)
            arView.scene.addAnchor(anchor)
        } catch {
            print("❌ Failed to load model '\(plant.modelName)': \(error)")
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
            if d < 0.6, d < nearestDist {         // 0.6 m trigger
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
