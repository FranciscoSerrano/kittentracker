//
//  Foster.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 7/27/24.
//

import Foundation
import SwiftData

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
    @Attribute(.externalStorage) var profilePhoto: Data?
    
    init(vetId: String = "", name: String = "", age: Int = 0, weight: Int = 100, gender: String = "Male", breed: String = "", pattern: String = "", beganFostering: Date = .now, currentlyFostering: Bool = false, notes: String = "", profilePhoto: Data? = nil) {
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
    }
}
