import UIKit
//
//  Plant.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//
struct Plant: Identifiable {
    public var id: String
    public var name: String
    public var status: PlantStatus
    public var model: PlantModel
    public var imageName: String
    public var overlaySize: (x: Double, y: Double)
}

struct PlantModel: Identifiable {
    var id: String
    var modelName: String
    var thumbnailName: String
    var size: SIMD3<Float>?
    var greenDot: GreenDot?
    
}

enum PlantStatus: String, CaseIterable, Codable {
    case happy
    case normal
    case sad
    case crying
}

