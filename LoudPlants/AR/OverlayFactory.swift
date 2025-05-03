// AR/OverlayFactory.swift
import RealityKit
import UIKit  // 只有在要把 UIImage 當成材質時需要

enum OverlayFactory {
    /// 根據 PlantStatusViewModel 自動產生樣式化 Overlay
    static func makeBasicStatusCard(for vm: PlantStatusViewModel) -> ModelEntity {
        let width  = vm.overlaySize.x
        let height = vm.overlaySize.y
        let corner = width * 0.05

        let plane = MeshResource.generatePlane(
            width: width,
            height: height,
            cornerRadius: corner
        )
        let bgMat = SimpleMaterial(
            color: .white.withAlphaComponent(0.9),
            isMetallic: false
        )
        let card = ModelEntity(mesh: plane, materials: [bgMat])
        card.components.set(BillboardComponent())

        // Avatar
        if let avatar = vm.avatarImage, let cg = avatar.cgImage {
            let avatarSize = height * 0.6
            let avatarPlane = MeshResource.generatePlane(
                width: avatarSize,
                height: avatarSize,
                cornerRadius: avatarSize * 0.5
            )
            // Load texture and assign directly to UnlitMaterial's color parameter
            let tex = try! TextureResource(
                image: cg,
                options: .init(semantic: .color)
            )
            var avatarMat = UnlitMaterial()
            let materialParam = MaterialParameters.Texture(tex)
            avatarMat.color = UnlitMaterial.BaseColor(tint: .white, texture: materialParam)
            let avatarEnt = ModelEntity(mesh: avatarPlane, materials: [avatarMat])
            avatarEnt.position = [
                -width/2 + avatarSize/2 + width*0.02,
                height/2 - avatarSize/2 - height*0.02,
                0.002
            ]
            card.addChild(avatarEnt)
        }

        // Text sizing
        let titleFontSize  = CGFloat(height * 0.25)
        let statusFontSize = CGFloat(height * 0.18)

        // Horizontal offset if avatar present
        let leftX: Float = vm.avatarImage != nil
            ? -width/2 + height*0.6 + width*0.04
            : -width/2 + width*0.02

        // Display name
        addText(
            vm.displayName,
            font: .boldSystemFont(ofSize: titleFontSize),
            color: .black,
            at: [leftX,
                 height/2 - Float(titleFontSize)*0.6 - height*0.02,
                 0.002],
            to: card
        )

        // Status text
        addText(
            vm.statusText,
            font: .systemFont(ofSize: statusFontSize),
            color: vm.statusColor,
            at: [
                leftX,
                height/2
                  - Float(titleFontSize)*0.6
                  - Float(statusFontSize)*1.2
                  - height*0.01,
                0.002
            ],
            to: card
        )

        return card
    }

    /// helper：在 parent 裡建立一個 3D 文字實體
    private static func addText(
        _ text: String,
        font: UIFont,
        color: UIColor,
        at pos: SIMD3<Float>,
        to parent: ModelEntity
    ) {
        let mesh = MeshResource.generateText(
            text,
            extrusionDepth: 0.001,
            font: font
        )
        let mat  = SimpleMaterial(color: color, isMetallic: false)
        let ent  = ModelEntity(mesh: mesh, materials: [mat])
        ent.position = pos
        parent.addChild(ent)
    }
}
