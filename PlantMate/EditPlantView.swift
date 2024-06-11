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
    let plant: Plant
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    var body: some View {
        ScrollView {
            VStack {
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
                    Text(plant.plantName)
                        .frame(alignment: .trailing)
                }
                
                Spacer()
                Divider()
                
                Text("Water Schedule: \(plant.waterSchedule)")
                Text("Water Amount: \(plant.waterAmount)")
                Text("Optimal Location: \(plant.optimalLocation)")
                
                
                Spacer()
                Divider()
                
                Text("Plant Notes")
                    .font(.headline)
                    .frame(alignment: .leading)
                Text(plant.notes)
                
                Spacer()
                Divider()
                
                // Notification Reminders
                VStack {
                    //potentially remove this and show as a prompt to enable notifications at app launch
                    Button("Enable Notifications") {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                print("Notifications set")
                            } else if let error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    
                    Button("Schedule next watering") {
                        let content = UNMutableNotificationContent()
                        content.title = "Time to water the \(plant.plantName)"
                        content.subtitle = "Needs \(plant.waterAmount.lowercased()) watering"
                        content.sound = UNNotificationSound.default
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                        
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        
                        UNUserNotificationCenter.current().add(request)
                    }
                }
                
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Add to gallery", systemImage: "leaf.circle")
                }
                
                //Show images already in the gallery
                if let plantGallery = plant.gallery,
                   let galleryUiImage = UIImage(data: plantGallery) {
                    Image(uiImage: galleryUiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
                
                // Show the newly uploaded image
                if let selectedPhotoData,
                   let uiImage = UIImage(data: selectedPhotoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
            .toolbar {
                // look at updating the plant item, and not creating a new one
                Button("Save") {
                    let updatedPlant = Plant(plantName: plant.plantName, plantPicture: plant.plantPicture, waterSchedule: plant.waterSchedule, waterAmount: plant.waterAmount, optimalLocation: plant.optimalLocation, notes: plant.notes, gallery: selectedPhotoData)
                    modelContext.insert(updatedPlant)
                }
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
