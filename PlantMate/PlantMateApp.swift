//
//  PlantMateApp.swift
//  PlantMate
//
//  Created by Giuseppe Sardo on 10/6/2024.
//

import SwiftData
import SwiftUI

@main
struct PlantMateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Plant.self)
    }
}
