// AR/OverlayFactory.swift
import RealityKit
import UIKit

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
        

        
        // 3) Font & common settings
        let titleFont = UIFont.systemFont(ofSize: CGFloat(height * 0.1), weight: .semibold)
        let bodyFont  = UIFont.systemFont(ofSize: CGFloat(height * 0.1), weight: .regular)
        let titleTextColor = UIColor.gray
        let bodyTextColor = UIColor.black
        // Icon sizing and depth
        let iconSize = Float(height * 0.08)
        let iconDepth = Float(height * 0.01)
        
        // Precomputed relative positions
        let iconX = -width * 0.08
        let textX = iconX + iconSize * 1.2
        let headerY1 = height * 0.15
        let bodyY1   = height * 0.15
        let headerY2 = -height * 0.05
        let bodyY2   = -height * 0.25
        
        // 2) 根據卡片尺寸計算兩種文字區塊大小
        //    headerFrame: 用於「Icon + 標題」(共用)
        //    bodyFrame: 用於「描述文字」(共用)
        let headerWidth  = CGFloat(width * 0.6)
        let headerHeight = CGFloat(height * 0.5)
        let headerFrame1  = CGRect(origin: CGPoint(x: 0 - CGFloat(iconX), y: 0-headerHeight+0.1),
                                  size: CGSize(width: headerWidth, height: headerHeight))
        let headerFrame2  = CGRect(origin: CGPoint(x: 0 - CGFloat(iconX), y: 0-headerHeight+0.1),
                                  size: CGSize(width: headerWidth, height: headerHeight))
        
        let bodyWidth  = CGFloat(width * 0.6)
        let bodyHeight = CGFloat(height * 0.4)
        let bodyFrame1  = CGRect(origin: CGPoint(x: 0, y: 0-bodyHeight),
                                size: CGSize(width: bodyWidth, height: bodyHeight))
        let bodyFrame2  = CGRect(origin: CGPoint(x: 0, y: 0-bodyHeight),
                                size: CGSize(width: bodyWidth, height: bodyHeight))
        
        // 4) 第一段：Icon + Status
        //    a) 先貼一個 SF Symbol
        if let bell = UIImage(systemName: "bell.fill") {
            try? card.addIcon(bell,
                              size: iconSize,
                              at: [iconX, headerY1, iconDepth])
        }
        //    b) 接著文字「Status」
        card.addMultilineText("Status",
                              font: titleFont,
                              color: titleTextColor,
                              containerFrame: headerFrame1,
                              alignment: .left,
                              lineBreakMode: .byTruncatingTail,
                              at: [0, 0, iconDepth])
        
        // 5) 第二段：描述文字
        let statusBody = "Stark is crying. Some more texts here texts texts"
        card.addMultilineText(statusBody,
                              font: bodyFont,
                              color: bodyTextColor,
                              containerFrame: bodyFrame1,
                              alignment: .left,
                              lineBreakMode: .byWordWrapping,
                              at: [0, 0, iconDepth])
        
        // 6) 第三段：Icon + Plant
        if let leaf = UIImage(systemName: "leaf.fill") {
            try? card.addIcon(leaf,
                              size: iconSize,
                              at: [iconX, headerY2, iconDepth])
        }
        card.addMultilineText("Plant",
                              font: titleFont,
                              color: titleTextColor,
                              containerFrame: headerFrame2,
                              alignment: .left,
                              lineBreakMode: .byTruncatingTail,
                              at: [0, 0, iconDepth])
        
        // 7) 第四段：Plant 名稱
        let plantBody = "Venus Flytrap"
        card.addMultilineText(plantBody,
                              font: bodyFont,
                              color: bodyTextColor,
                              containerFrame: bodyFrame2,
                              alignment: .left,
                              lineBreakMode: .byTruncatingTail,
                              at: [0, 0, iconDepth])
        

        return card
    }
}

extension Entity {

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
    
    func addMultilineText(
            _ text: String,
            font: UIFont,
            color: UIColor,
            containerFrame: CGRect,
            alignment: CTTextAlignment = .left,
            lineBreakMode: CTLineBreakMode = .byWordWrapping,
            at position: SIMD3<Float>
        ) {
            // 1. Generate the text mesh with layout parameters
            let mesh = MeshResource.generateText(
                text,
                extrusionDepth: 0.001,
                font: font,
                containerFrame: containerFrame,
                alignment: alignment,
                lineBreakMode: lineBreakMode
            )
            
            // 2. Create material
            let material = SimpleMaterial(color: color, isMetallic: false)
            
            // 3. Instantiate ModelEntity
            let textEntity = ModelEntity(mesh: mesh, materials: [material])
            
            // 4. Set position
            textEntity.position = position
            
            // 5. Add to self
            self.addChild(textEntity)
        }
    func addIcon(_ image: UIImage, size: Float, at position: SIMD3<Float>) throws {
        guard let cg = image.cgImage else { return }
        let plane = MeshResource.generatePlane(width: size, height: size)
        let tex   = try TextureResource(image: cg,
                                        options: .init(semantic: .color))
        var mat   = UnlitMaterial()
        mat.opacityThreshold = 0.1
        let param = MaterialParameters.Texture(tex)
        mat.color = UnlitMaterial.BaseColor(tint: .white, texture: param)
        let iconEnt = ModelEntity(mesh: plane, materials: [mat])
        iconEnt.position = position
        self.addChild(iconEnt)
    }
}
