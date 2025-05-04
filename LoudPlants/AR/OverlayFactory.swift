// AR/OverlayFactory.swift
import RealityKit
import UIKit  // 只有在要把 UIImage 當成材質時需要

enum OverlayFactory {
    /// 根據 PlantStatusViewModel 自動產生樣式化 Overlay
    static func makeBasicStatusCard(for vm: PlantStatusViewModel) -> ModelEntity {
        let width  = vm.overlaySize.x
        let height = vm.overlaySize.y
        let corner = width * 0.1

        let plane = MeshResource.generatePlane(
            width: width,
            height: height,
            cornerRadius: corner
        )
        
        var simpleMaterial = UnlitMaterial(color: .white)
        simpleMaterial.blending = .transparent(opacity: 0.95)
        
        let card = ModelEntity(mesh: plane, materials: [simpleMaterial])
        card.components.set(BillboardComponent())


        // Avatar
        if let avatar = vm.avatarImage {
            try? card.addAvatar(with: avatar, in: vm.overlaySize)
        }
//
//        // Text sizing
//        let titleFontSize  = CGFloat(height * 0.25)
//        let statusFontSize = CGFloat(height * 0.18)
//
//        // Horizontal offset if avatar present
//        let leftX: Float = vm.avatarImage != nil
//            ? -width/2 + height*0.6 + width*0.04
//            : -width/2 + width*0.02
//
//        // Display name
//        addText(
//            vm.displayName,
//            font: .boldSystemFont(ofSize: titleFontSize),
//            color: .black,
//            at: [leftX,
//                 height/2 - Float(titleFontSize)*0.6 - height*0.02,
//                 0.002],
//            to: card
//        )
//
//        // Status text
//        addText(
//            vm.statusText,
//            font: .systemFont(ofSize: statusFontSize),
//            color: vm.statusColor,
//            at: [
//                leftX,
//                height/2
//                  - Float(titleFontSize)*0.6
//                  - Float(statusFontSize)*1.2
//                  - height*0.01,
//                0.002
//            ],
//            to: card
//        )

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

extension Entity {
    /// 將背景圖與頭像同時加入到指定的 card Entity 上
    /// - Parameters:
    ///   - card: 要加入子 Entity 的父 Entity
    ///   - vm: 包含 avatarImage 的 ViewModel
    ///   - size: card 的整體尺寸 (width, height)
    func addAvatar(with avatarImage: UIImage,
                   in cardSize: SIMD2<Float>) throws {
        
        guard let cgImage = avatarImage.cgImage else {
            return
        }
        let cardWidth = cardSize.x
        let cardHeight = cardSize.y
        
        let avatarSize = cardSize.y * 0.9
        let avatarPlane = MeshResource.generatePlane(
            width: avatarSize,
            height: avatarSize,
            cornerRadius: avatarSize * 0.5
        )
        let avatarTexture = try TextureResource(
            image: cgImage,
            options: .init(semantic: .color)
        )
        var avatarMaterial = UnlitMaterial()
        avatarMaterial.opacityThreshold = 0.1 // Use alpha musk to avoid render transparent bg
        let avatarParam = MaterialParameters.Texture(avatarTexture)
        avatarMaterial.color = UnlitMaterial.BaseColor(tint: .white, texture: avatarParam)
        
        let avatarEntity = ModelEntity(mesh: avatarPlane, materials: [avatarMaterial])
        
        
        // Calculate avatar position within the card
        avatarEntity.position = [
            // X: start from left edge (-cardWidth/2),
            // move right by half avatar size,
            // then add 2% horizontal margin of card width
            -cardWidth / 2 + avatarSize / 2 + cardWidth * 0.02,
             
             // Y: start from top edge (cardHeight/2),
             // move down by half avatar size,
             // then subtract 2% vertical margin of card height
             cardHeight / 2 - avatarSize / 2 + cardHeight * 0.2,
             
             // Z: fixed depth offset in front of the card
             0.02
        ]
        self.addChild(avatarEntity)
    }
}
