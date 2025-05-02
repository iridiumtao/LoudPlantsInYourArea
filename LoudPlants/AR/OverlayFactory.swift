// AR/OverlayFactory.swift
import RealityKit
import UIKit // Only needed when using SwiftUI View as a texture

enum OverlayFactory {
    /// Directly use RealityKit primitives + text
    static func makeBasicStatusCard(for status: PlantStatusViewModel) -> ModelEntity {
        let width: Float = 0.18, height: Float = 0.10
        let plane  = MeshResource.generatePlane(width: width, height: height, cornerRadius: 0.01)
        let bgMat  = SimpleMaterial(color: .white.withAlphaComponent(0.9), isMetallic: false)
        let card   = ModelEntity(mesh: plane, materials: [bgMat])
        card.components.set(BillboardComponent())

        // title
        addText(status.displayName,
                font: .boldSystemFont(ofSize: 0.045),
                color: .black,
                at: [-width*0.45, height*0.15, 0.002],
                to: card)

        // status
        addText(status.statusText,
                font: .systemFont(ofSize: 0.035),
                color: status.statusColor,
                at: [-width*0.45, -height*0.05, 0.002],
                to: card)

        return card
    }

    /// Rasterize UIKit/SwiftUI views into textures and apply them to planes
    static func makeCardFrom(view: UIView, size: CGSize) -> ModelEntity {
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { _ in view.drawHierarchy(in: view.bounds, afterScreenUpdates: true) }

        let tex   = try! TextureResource(image: img.cgImage!, options: .init(semantic: .color))
        var mat   = UnlitMaterial()
        mat.color = .init(texture: .init(tex))
        let mesh  = MeshResource.generatePlane(width: Float(size.width/1000),
                                               height: Float(size.height/1000))
        let card  = ModelEntity(mesh: mesh, materials: [mat])
        card.components.set(BillboardComponent())
        return card
    }

    // helper
    private static func addText(_ text: String,
                                font: UIFont,
                                color: UIColor,
                                at pos: SIMD3<Float>,
                                to parent: ModelEntity) {
        let mesh = MeshResource.generateText(text,
                                             extrusionDepth: 0.001,
                                             font: font)
        let mat  = SimpleMaterial(color: color, isMetallic: false)
        let ent  = ModelEntity(mesh: mesh, materials: [mat])
        ent.position = pos
        parent.addChild(ent)
    }
}
