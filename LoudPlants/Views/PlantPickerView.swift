//
//  PlantPickerView.swift
//  LoudPlants
//
//  Created by 歐東 on 4/21/25.
//

import SwiftUI

struct PlantPickerView: View {
    /// from upper, available plant models list
    let plantEntities: [PlantEntity]
    /// when the user select a model
    let onSelect: (PlantEntity) -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 0) {

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {

                    ForEach(plantEntities) { model in
                        VStack(spacing: 8) {
                            Image(model.thumbnailName)
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(8)
                            Text(model.modelName)
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
        .cornerRadius(16)
    }
}

struct PlantPickerView_Previews: PreviewProvider {
    static let samples = [
        PlantEntity(id: "succulent", modelName: "Succulent", thumbnailName: "succ_thumb"),
    ]

    static var previews: some View {
        PlantPickerView(plantEntities: samples) { model in
            print("Selected:", model)
        }
    }
}
