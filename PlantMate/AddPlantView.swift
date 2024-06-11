//
//  AddPlantView.swift
//  PlantMate
//
//  Created by Giuseppe Sardo on 10/6/2024.
//

import PhotosUI
import SwiftUI

struct AddPlantView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    @State private var plantName = ""
    @State private var optimalLocation = "Filtered Light"
    @State private var waterSchedule = "Weekly"
    @State private var waterAmount = "Moderate"
    @State private var notes = ""
    
    let optimalLocations = ["Full Sun", "Filtered Light", "Bright Indoors", "Part Shaded"]
    let waterSchedules = ["Weekly", "Fortnightly", "Monthly"]
    let waterAmounts = ["Light", "Moderate", "Heavy"]
    
    var isFormValid: Bool {
        if plantName.trimmingCharacters(in: .whitespaces).isEmpty || notes.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        return true
    }
    
    var body: some View {
        NavigationStack {
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
                
                Section {
                    TextField("Plant name", text: $plantName)
                }
                
                Section {
                    Text("About the plant")
                        .font(.headline)
                    TextEditor(text: $notes)
                }
                
                Section {
                    Picker("Optimal location", selection: $optimalLocation) {
                        ForEach(optimalLocations, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("Watering schedule", selection: $waterSchedule) {
                        ForEach(waterSchedules, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("Watering amount", selection: $waterAmount) {
                        ForEach(waterAmounts, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .navigationTitle("New plant")
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
            .toolbar {
                Button("Save") {
                    let newPlant = Plant(plantName: plantName, plantPicture: selectedPhotoData, waterSchedule: waterSchedule, waterAmount: waterAmount, optimalLocation: optimalLocation, notes: notes, gallery: nil)
                    modelContext.insert(newPlant)
                    dismiss()
                }
                .disabled(isFormValid == false)
            }
        }
    }
}

#Preview {
    AddPlantView()
}
