//
//  SettingView.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("plantVisibilityEnabled") private var plantVisibilityEnabled: Bool = true

    var body: some View {
        Form {
            Toggle("Set Plant Visibility", isOn: $plantVisibilityEnabled)
                .toggleStyle(SwitchToggleStyle())
                .padding()
        }
    }
}
