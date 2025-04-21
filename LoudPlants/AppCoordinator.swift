//
//  AppCoordinator.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//

import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var path: [Route] = []
    
    enum Route {
        case demo
    }
    
    func goToDemo() {
        path.append(.demo)
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
