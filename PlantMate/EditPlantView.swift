//
//  EditPlantView.swift
//  PlantMate
//
//  Created by Giuseppe Sardo on 10/6/2024.
//

import PhotosUI
import SwiftData
import SwiftUI
import UserNotifications

struct EditPlantView: View {
    @Environment(\.modelContext) var modelContext
    
    @Bindable var plant: Plant
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    let optimalLocations = ["Full Sun", "Filtered Light", "Bright Indoors", "Part Shaded"]
    let waterSchedules = ["Weekly", "Fortnightly", "Monthly"]
    let waterAmounts = ["Light", "Moderate", "Heavy"]    
    
    var body: some View {
        Form {
            Section {
                if let selectedPhotoData,
                   let uiImage = UIImage(data: selectedPhotoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                }
                
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Select a picture", systemImage: "photo")
                }
            }
            
            Section("Plant Name") {
                TextField("Plant name", text: $plant.plantName)
            }
            
            Section("Notes") {
                TextField("About the plant", text: $plant.notes, axis: .vertical)
                    .lineLimit(1...5)
            }
            
            Section {
                Picker("Optimal location", selection: $plant.optimalLocation) {
                    ForEach(optimalLocations, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section("Watering Schedule") {
                Picker("Watering schedule", selection: $plant.waterSchedule) {
                    ForEach(waterSchedules, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("Watering Amount") {
                Picker("Watering amount", selection: $plant.waterAmount) {
                    ForEach(waterAmounts, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("Edit Plant")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                selectedPhotoData = data
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Plant.self, configurations: config)
        let example = Plant(plantName: "Cactus", plantPicture: nil, waterSchedule: "Monthly", waterAmount: "Light", optimalLocation: "Full Sun", notes: "Hardy plant that loves a bright spot, and only requires light watering.", gallery: nil)
        
        return EditPlantView(plant: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
