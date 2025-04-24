//
//  DemoView.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//

import SwiftUI
import RealityKit

struct DemoView: View {
    @Environment(\.dismiss) private var dismiss
    private let arSession = ARSessionManager.shared
    
    // Local state for showing sheets
    @State private var showPicker = false
    @State private var showSettings = false
    
    // Sample plant models
    private let plantModels = [
        PlantModel(id: "1", displayName: "Flytrap (Fixed Greeen Dot)", modelName: "Flytrap with Green Dot", thumbnailName: "flytrap_thumb"),
        PlantModel(id: "2", displayName: "Flytrap (Real Green Dot)", modelName: "Flytrap", thumbnailName: "flytrap_thumb", greenDot: GreenDot(offset: SIMD3<Float>(0.048, 0.296, -0.028), size: 0.1)),

    ]
    
    var body: some View {
        ZStack {

            
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // MARK: — Top Options
                HStack {
                    
                    // MARK: — Close Button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .padding(.top, 20)
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    // MARK: — Setting Button
                    Button {
                        showSettings = true // show settings sheet
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                }
                
                Spacer()
                
                // MARK: — Bottom Left: Add Plant button
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            showPicker = true // show plant picker sheet
                        } label: {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .frame(width: 60, height: 60)
                        }
                        .buttonStyle(.plain)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .padding(.leading, 20)
                        .padding(.bottom, 20)

                        Spacer()
                    }
                }
                
            }
            // MARK: — Sheets for Picker & Settings
            .sheet(
                isPresented: $showPicker
            ) {
                PlantPickerView(plantModels: plantModels) { selected in
                    arSession.placeModel(selected)
                    showPicker = false
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThinMaterial).ignoresSafeArea()
                .presentationCompactAdaptation(.sheet)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }

            
        }
        .background(
            Image("indoor-plants-studio").resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea(.all)
        )
    }
}

#Preview {
    DemoView()
        .environmentObject(ARSessionManager.shared)
        .environmentObject(PlantStore())
        .environmentObject(AppCoordinator())
}
