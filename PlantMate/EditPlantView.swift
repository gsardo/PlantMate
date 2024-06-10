//
//  EditPlantView.swift
//  PlantMate
//
//  Created by Giuseppe Sardo on 10/6/2024.
//

import SwiftData
import SwiftUI
import UserNotifications

struct EditPlantView: View {
    let plant: Plant
    
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
                }
                Text("Water Schedule: \(plant.waterSchedule)")
                Text("Water Amount: \(plant.waterAmount)")
                Text("Optimal Location: \(plant.optimalLocation)")
                
                Text(plant.notes)
                
                
                VStack {
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
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Plant.self, configurations: config)
        let example = Plant(plantName: "Cactus", plantPicture: nil, waterSchedule: "Monthly", waterAmount: "Light", optimalLocation: "Full Sun", notes: "Hardy plant that loves a bright spot, and only requires light watering.")
        
        return EditPlantView(plant: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
