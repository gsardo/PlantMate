//
//  PlantModel.swift
//  PlantMate
//
//  Created by Giuseppe Sardo on 10/6/2024.
//

import Foundation
import SwiftData

@Model
class Plant {
    var plantName: String
    var plantPicture: Data?
    var waterSchedule: String
    var waterAmount: String
    var optimalLocation: String
    var notes: String
    var gallery: Data?
    
    init(plantName: String = "", plantPicture: Data? = nil, waterSchedule: String = "", waterAmount: String = "", optimalLocation: String = "", notes: String = "", gallery: Data? = nil) {
        self.plantName = plantName
        self.plantPicture = plantPicture
        self.waterSchedule = waterSchedule
        self.waterAmount = waterAmount
        self.optimalLocation = optimalLocation
        self.notes = notes
        self.gallery = gallery
    }
}
