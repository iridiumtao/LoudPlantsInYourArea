//
//  ARViewContainer.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    private let arSession = ARSessionManager.shared

    func makeUIView(context: Context) -> ARView {
        arSession.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // nothing for now
    }
}
