//
//  PlantPickerView.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//

import SwiftUI

struct PlantPickerView: View {
    /// from upper, available plant models list
    let plantModels: [PlantModel]
    /// when the user select a model
    let onSelect: (PlantModel) -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 0) {

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(plantModels) { model in
                        VStack(spacing: 8) {
                            Image(model.thumbnailName)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(8)
                            Text(model.displayName)
                                .font(.caption)
                        }
                        .onTapGesture {
                            onSelect(model)
                        }
                    }
                }
                .padding()
            }
        }
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct PlantPickerView_Previews: PreviewProvider {
    static let samples = [
        PlantModel(id: "fern", displayName: "Fern", thumbnailName: "fern_thumb"),
        PlantModel(id: "succulent", displayName: "Succulent", thumbnailName: "succ_thumb"),
    ]

    static var previews: some View {
        PlantPickerView(plantModels: samples) { model in
            print("Selected:", model)
        }
    }
}
