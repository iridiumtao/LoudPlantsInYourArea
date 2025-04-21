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
    
    // Local state for showing sheets
    @State private var showPicker = false
    @State private var showSettings = false
    
    // Sample plant models
    private let plantModels = [
        PlantModel(id: "fern", displayName: "Fern", thumbnailName: "fern_thumb"),
        PlantModel(id: "succulent", displayName: "Succulent", thumbnailName: "succ_thumb"),
        PlantModel(id: "fern2", displayName: "Fern2", thumbnailName: "fern_thumb"),
        PlantModel(id: "succulent2", displayName: "Succulent2", thumbnailName: "succ_thumb")
    ]
    
    var body: some View {
        ZStack {

            
//            ARViewContainer()
//                .edgesIgnoringSafeArea(.all)
            
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
}
