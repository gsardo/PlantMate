//
//  PlantCollectionView.swift
//  PlantMate
//
//  Created by Giuseppe Sardo on 15/6/2024.
//

import SwiftData
import SwiftUI

struct PlantCollectionView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var showingAddScreen = false
    @State private var path = [Plant]()
    
    @Query var plants: [Plant]
    
    var body: some View {
        NavigationStack(path: $path) {
            List(plants) { plant in
                NavigationLink(value: plant) {
                    HStack {
                        if let selectedPhotoData = plant.plantPicture,
                           let uiImage = UIImage(data: selectedPhotoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 100, maxHeight: 100)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 10, style: .continuous)
                                )
                        }
                        
                        VStack(alignment: .leading) {
                            Text(plant.plantName)
                                .font(.headline)
                            
                            Text("Lorem Ipsum")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("PlantMate")
            .navigationDestination(for: Plant.self) { plant in
                EditPlantView(plant: plant)
            }
            .toolbar {
                Button("Add Plant", systemImage: "plus") {
                    showingAddScreen.toggle()
                }
            }
        }
        .sheet(isPresented: $showingAddScreen) {
            AddPlantView()
        }
    }
}


#Preview {
    PlantCollectionView()
}
