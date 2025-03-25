//
//  FeedingLogView.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 3/24/25.
//


import SwiftUI

struct FeedingLogView: View {
    @Bindable var foster: Foster
    @State private var feedingAmount: Double = 0
    @State private var feedingNotes: String = ""
    
    var body: some View {
        Form {
            Section {
                Text("Next feeding in: \(nextFeedingTimeString)")
                    .font(.headline)
            }
            
            Section("Add Feeding") {
                HStack {
                    Text("Amount (ml):")
                    TextField("0", value: $feedingAmount, format: .number)
                        .keyboardType(.decimalPad)
                }
                
                TextField("Notes", text: $feedingNotes, axis: .vertical)
                    .lineLimit(1...4)
                
                Button(action: addFeeding) {
                    Text("Record Feeding")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(feedingAmount <= 0)
            }
            
            Section("Feeding History") {
                if foster.feedings.isEmpty {
                    ContentUnavailableView("No Feedings Recorded", 
                        systemImage: "clock.badge.questionmark")
                } else {
                    ForEach(foster.feedings.sorted { $0.date > $1.date }) { feeding in
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "clock")
                                Text(feeding.date.formatted(date: .abbreviated, time: .shortened))
                                Spacer()
                                Text("\(feeding.amount, specifier: "%.1f") ml")
                                    .bold()
                            }
                            if !feeding.notes.isEmpty {
                                Text(feeding.notes)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Feeding Log")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var nextFeedingTimeString: String {
        guard let nextFeeding = foster.nextFeedingTime else {
            return "Not scheduled"
        }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: nextFeeding, relativeTo: .now)
    }
    
    private func addFeeding() {
        foster.addFeeding(amount: feedingAmount, notes: feedingNotes)
        feedingAmount = 0
        feedingNotes = ""
    }
}