//
//  LaudPlantsApp.swift
//  LaudPlants
//
//  Created by 歐東 on 4/21/25.
//

import SwiftUI

@main
struct LaudPlantsApp: App {
    @StateObject private var plantStore = PlantStore()
    @StateObject private var coordinator = AppCoordinator()
    @State private var showDemo: Bool = false
    
    var body: some Scene {
        WindowGroup {
            WelcomeView(showDemo: $showDemo)
                .environmentObject(plantStore)
                .environmentObject(coordinator)
                .fullScreenCover(isPresented: $showDemo) {
                    DemoView()
                        .environmentObject(plantStore)
                        .environmentObject(coordinator)
                }
            
            
        }
    }
}
