//
//  WelcomeView.swift
//  LaudPlants
//
//  Created by 歐東 on 4/21/25.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var showDemo: Bool
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to Laud Plants")
                .font(.largeTitle)
            Button {
                showDemo.toggle()
            } label: {
                Label("View Demo", systemImage: "arkit")
            }
            .controlSize(.large)
            .padding(24)

        }
    }
}

#Preview {
    WelcomeView(showDemo: .constant(false))
}
