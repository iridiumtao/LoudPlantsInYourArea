//
//  WelcomeView.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var showDemo: Bool
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to Loud Plants")
                .font(.largeTitle)
            Button {
                showDemo.toggle()
            } label: {
                Label("View Your Plants", systemImage: "arkit")
            }
            .controlSize(.large)
            .padding(24)

        }
    }
}

#Preview {
    WelcomeView(showDemo: .constant(false))
}
