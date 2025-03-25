//
//  KittenTrackerApp.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 7/26/24.
//

import SwiftUI
import SwiftData

@main
struct KittenTrackerApp: App {
    
    init() {
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Foster.self)
    }
}
