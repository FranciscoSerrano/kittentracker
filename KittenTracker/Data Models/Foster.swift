//
//  Foster.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 7/27/24.
//

import Foundation
import SwiftData

@Model
class FeedingRecord {
    var date: Date
    var amount: Double // in milliliters
    var notes: String
    
    init(date: Date = .now, amount: Double = 0.0, notes: String = "") {
        self.date = date
        self.amount = amount
        self.notes = notes
    }
}

@Model
class Foster {
    var vetId: String
    var name: String
    var age: Int
    var weight: Int
    var gender: String
    var breed: String
    var pattern: String
    var beganFostering: Date
    var currentlyFostering: Bool
    var notes: String
    var nextFeedingTime: Date?
    var feedingIntervalHours: Double
    
    @Attribute(.externalStorage) var profilePhoto: Data?
    @Relationship(deleteRule: .cascade) var weights = [KittenWeight]()
    @Relationship(deleteRule: .cascade) var feedings = [FeedingRecord]()
    
    init(vetId: String = "", name: String = "", age: Int = 0, weight: Int = 100,
         gender: String = "Male", breed: String = "", pattern: String = "",
         beganFostering: Date = .now, currentlyFostering: Bool = false,
         notes: String = "", profilePhoto: Data? = nil,
         nextFeedingTime: Date? = nil,
         feedingIntervalHours: Double = 2.0) {
        self.vetId = vetId
        self.name = name
        self.age = age
        self.weight = weight
        self.gender = gender
        self.breed = breed
        self.pattern = pattern
        self.beganFostering = beganFostering
        self.currentlyFostering = currentlyFostering
        self.notes = notes
        self.profilePhoto = profilePhoto
        self.nextFeedingTime = nextFeedingTime
        self.feedingIntervalHours = feedingIntervalHours
    }
    
    func updateFeedingInterval() {
        switch age {
        case 0...1: // 0-1 weeks
            feedingIntervalHours = 2.0
        case 2...3: // 2-3 weeks
            feedingIntervalHours = 3.0
        case 4: // 4 weeks
            feedingIntervalHours = 4.0
        default: // 5+ weeks
            feedingIntervalHours = 6.0
        }
    }
    
    func addFeeding(amount: Double, notes: String = "") {
        let feeding = FeedingRecord(amount: amount, notes: notes)
        feedings.append(feeding)
        nextFeedingTime = Date(timeInterval: feedingIntervalHours * 3600, since: .now)
        
        // Schedule next feeding notification
        NotificationManager.shared.scheduleFeedingNotification(for: self)
    }
}

extension Foster {
    static var exampleData = Foster(vetId: "V1234", name: "Marbles", age: 4, weight: 200, gender: "Male", breed: "Maine Coon", pattern: "Grey Long Hair", beganFostering: .now, currentlyFostering: true, notes: "", profilePhoto: nil, nextFeedingTime: nil, feedingIntervalHours: 2)
}
