//
//  ARSessionManager.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//

import RealityKit
import ARKit
import Combine

/// Manages a single ARView & handles raycasts + anchor placement
final class ARSessionManager: ObservableObject {
    static let shared = ARSessionManager()

    /// The ARView we drive
    let arView: ARView

    private init() {
        arView = ARView(frame: .zero)
        configureSession()
    }

    private func configureSession() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }

    /// Raycast from screen center and place the specified model
    func placeModel(named modelName: String) {
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
            // let plantEntity = try Entity.load(named: modelName)
            
            // For USDZ models use:
            let plantEntity = try Entity.load(named: modelName + ".usdz")
            
            anchor.addChild(plantEntity)
            arView.scene.addAnchor(anchor)
        } catch {
            print("❌ Failed to load model '\(modelName)': \(error)")
        }
    }
}
