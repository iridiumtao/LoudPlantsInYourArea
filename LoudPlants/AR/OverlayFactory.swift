// AR/OverlayFactory.swift
import RealityKit
import UIKit
import SwiftUI

enum OverlayFactory {
    /// 根據 PlantStatusViewModel 自動產生樣式化 Overlay
    static func makeBasicStatusCard(for plantStatusVM: PlantStatusViewModel) -> ModelEntity {
        
        @AppStorage("statusCardFollowCameraEnabled") var statusCardFollowCameraEnabled: Bool = true
        
        let width  = plantStatusVM.overlaySize.x
        let height = plantStatusVM.overlaySize.y
        let corner = width * 0.1

        let plane = MeshResource.generatePlane(
            width: width,
            height: height,
            cornerRadius: corner
        )
        
        var simpleMaterial = UnlitMaterial(color: .white)
        simpleMaterial.blending = .transparent(opacity: 0.95)
        
        let card = ModelEntity(mesh: plane, materials: [simpleMaterial])
        
        if statusCardFollowCameraEnabled {
            card.components.set(BillboardComponent())
        }

        // Avatar
        if let avatar = plantStatusVM.avatarImage {
            try? card.addAvatar(with: avatar, in: plantStatusVM.overlaySize)
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
        let headerX = iconX + iconSize * 1.3
        let headerY1 = height/2 * 0.8
        let bodyY1   = height/2 * 0.5
        let headerY2 = -height/2 * 0.2
        let bodyY2   = -height/2 * 0.5
        
        // Title container: full width minus icon offset, height proportional to card
        let bodyWidth = CGFloat(width * 0.55)
        let headerWidth  = bodyWidth - CGFloat(iconX * 2)
        let headerHeight = height * 0.2
        let headerFrame1 = CGRect(origin: .zero,
                                  size: CGSize(width: CGFloat(headerWidth), height: CGFloat(headerHeight)))
        let headerFrame2 = headerFrame1
        
        // Body container: full card width, height proportional to card
        let bodyHeight = height * 0.3
        let bodyFrame1 = CGRect(origin: .zero,
                                size: CGSize(width: CGFloat(bodyWidth), height: CGFloat(bodyHeight)))
        let bodyFrame2 = bodyFrame1
        
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
                              at: [headerX, headerY1, iconDepth])
        
        // 5) 第二段：描述文字
        let statusBody = plantStatusVM.statusText
        card.addMultilineText(statusBody,
                              font: bodyFont,
                              color: bodyTextColor,
                              containerFrame: bodyFrame1,
                              alignment: .left,
                              lineBreakMode: .byWordWrapping,
                              at: [iconX, bodyY1, iconDepth])
        
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
                              at: [headerX, headerY2, iconDepth])
        
        // 7) 第四段：Plant 名稱
        let plantBody = plantStatusVM.plantSpecies
        card.addMultilineText(plantBody,
                              font: bodyFont,
                              color: bodyTextColor,
                              containerFrame: bodyFrame2,
                              alignment: .left,
                              lineBreakMode: .byTruncatingTail,
                              at: [iconX, bodyY2, iconDepth])
        

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
        
        let material = SimpleMaterial(color: color, isMetallic: false)
        let textEntity = ModelEntity(mesh: mesh, materials: [material])
        
        // calculate pivot offset to left-top
        let bounds = textEntity.visualBounds(relativeTo: textEntity)
        let pivotOffset = SIMD3<Float>(-bounds.min.x, -bounds.max.y, 0)
        // set position including pivot offset
        textEntity.position = position + pivotOffset
        
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
        
        let bounds = iconEnt.visualBounds(relativeTo: iconEnt)
        let pivotOffset = SIMD3<Float>(-bounds.min.x, -bounds.max.y, 0)
        iconEnt.position = position + pivotOffset
        
        self.addChild(iconEnt)
    }
}
