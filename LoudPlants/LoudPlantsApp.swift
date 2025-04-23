//
//  LoudPlantsApp.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//

import SwiftUI

@main
struct LoudPlantsApp: App {
    @StateObject private var plantStore = PlantStore()
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var arSession = ARSessionManager.shared
    
    @State private var showDemo: Bool = false
    
    var body: some Scene {
        WindowGroup {
            WelcomeView(showDemo: $showDemo)
                .environmentObject(plantStore)
                .environmentObject(coordinator)
                .environmentObject(arSession)
                .fullScreenCover(isPresented: $showDemo) {
                    DemoView()
                        .environmentObject(plantStore)
                        .environmentObject(coordinator)
                }
            
            
        }
    }
}
