//
//  KittenWeight.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 8/11/24.
//

import Foundation
import SwiftData

@Model
class KittenWeight {
    var date: Date
    var weight: Int
    
    // Add computed property for day-only comparison
    var dayDate: Date {
        Calendar.current.startOfDay(for: date)
    }

    init(weight: Int, date: Date) {
        // Set date to start of day for consistency
        self.date = Calendar.current.startOfDay(for: date)
        self.weight = weight
    }
    
    static let exampleData: [KittenWeight] = [
        KittenWeight(weight: 180, date: .now),
        KittenWeight(weight: 190, date: .now.advanced(by: 86400)),
        KittenWeight(weight: 225, date: .now.advanced(by: 86400 * 2)),
        KittenWeight(weight: 215, date: .now.advanced(by: 86400 * 4)),
        KittenWeight(weight: 460, date: .now.advanced(by: 86400 * 5)),
        KittenWeight(weight: 470, date: .now.advanced(by: 86400 * 6)),
        KittenWeight(weight: 510, date: .now.advanced(by: 86400 * 7)),
        KittenWeight(weight: 600, date: .now.advanced(by: 86400 * 8)),
        KittenWeight(weight: 710, date: .now.advanced(by: 86400 * 9)),
        KittenWeight(weight: 890, date: .now.advanced(by: 86400 * 10)),
    ]
}
