//
//  WeightChartView.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 7/27/24.
//

import SwiftUI
import Charts

//struct KittenWeight: Identifiable {
//    var id = UUID()
//    var date: Date
//    var weight: Int
//
//
//    init(month: Int, weight: Int) {
//        let calendar = Calendar.autoupdatingCurrent
//        self.date = calendar.date(from: DateComponents(year: 2024, month: month))!
//        self.weight = weight
//    }
//}
//
//

struct WeightChartView: View {
    
    @Bindable var foster: Foster
    @Environment(\.modelContext) var modelContext
    @State private var showingRecordSheet = false
    @State private var selectedDate: Date = .now
    @State private var selectedWeight: Int = 0
    @State private var goalWeight = 750
    @State private var showingPopover = false
    
    
    // Add computed property to check for existing weight on selected date
    private var hasRecordedWeightToday:  Bool {
        fosterWeights.contains { weight in
            Calendar.current.isDate(weight.dayDate, inSameDayAs: selectedDate)
        }
    }
    
    private var weightChange: (Double, Bool) {
        guard fosterWeights.count >= 2 else { return (0, true) }
        
        let sortedWeights = fosterWeights.sorted { $0.date > $1.date }
        let currentWeight = Double(sortedWeights[0].weight)
        let previousWeight = Double(sortedWeights[1].weight)
        
        let percentChange = ((currentWeight - previousWeight) / previousWeight) * 100
        return (abs(percentChange), percentChange >= 0)
    }
    
    var fosterWeights: [KittenWeight] {
        foster.weights
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    // Add fixed width GroupBox for weight
                    GroupBox {
                        Text("\(fosterWeights.last?.weight ?? 0) grams")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                    label: {
                        Label("Current Weight", systemImage: "scalemass.fill")
                            .foregroundStyle(.teal)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Add fixed width GroupBox for percentage
                    GroupBox {
                        Text(String(format: "%.1f%% %@", weightChange.0, weightChange.1 ? "Increase" : "Decrease"))
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                    label: {
                        Label("Change", systemImage: weightChange.1 ? "arrow.up.right" : "arrow.down.right")
                            .foregroundStyle(weightChange.1 ? .green : .red)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            
            Section {
                if fosterWeights.isEmpty {
                    ContentUnavailableView("No Weight Records",
                                           systemImage: "scale.3d",
                                           description: Text("Add your first weight record to start tracking growth")
                    )
                } else {
                    GroupBox {
                        Chart(fosterWeights) {
                            RuleMark(y: .value("Goal Weight", goalWeight))
                                .foregroundStyle(.mint)
                                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                                .annotation(alignment: .leading) {
                                    Text("Goal")
                                        .font(.caption2)
                                        .foregroundStyle(.mint)
                                }
                            
                            LineMark(
                                x: .value("Day", $0.dayDate),
                                y: .value("Weight", $0.weight)
                            )
                            .foregroundStyle(.pink)
                        }
                        .frame(height: 200)
                    } label: {
                        HStack {
                            Label("Growth Chart", systemImage: "chart.xyaxis.line")
                                .foregroundStyle(.pink)
                            
                            Spacer()
                            
                            Menu("Goal: \(goalWeight)g") {
                                Stepper("", value: $goalWeight, step: 50)
                            }
                            .font(.caption)
                        }
                    }
                }
            }
            
            Section {
                Button(action: { showingRecordSheet.toggle() }) {
                    Label(hasRecordedWeightToday ? "Weight Recorded! 🎉" : "Record New Weight",
                          systemImage: hasRecordedWeightToday ? "checkmark.circle.fill" : "plus.circle.fill")
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(hasRecordedWeightToday ? .green : .pink)
                .disabled(hasRecordedWeightToday)
            } footer: {
                if hasRecordedWeightToday {
                    Text("Come back tomorrow to record a new weight.")
                }
            }
            
            Section("Weight History") {
                if fosterWeights.isEmpty {
                    ContentUnavailableView("No Records",
                                           systemImage: "clock.badge.questionmark")
                } else {
                    ForEach(fosterWeights.sorted { $0.date > $1.date }) { value in
                        HStack {
                            Image(systemName: "scalemass.fill")
                            Text(value.date.formatted(date: .abbreviated, time: .omitted))
                            Spacer()
                            Text("\(value.weight) g")
                                .bold()
                        }
                    }
                    
                }
            }
        }
        .sheet(isPresented: $showingRecordSheet) {
            newRecordView
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.visible)
        }
        .navigationTitle("Weight Tracker")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var newRecordView: some View {
        VStack {
            Form {
                DatePicker("Date:", selection: $selectedDate,
                           displayedComponents: .date)
                .disabled(true) // Force today's date
                
                Section("Current Weight") {
                    TextField("Current Weight", value: $selectedWeight,
                              format: .number)
                }
            }
            .formStyle(.grouped)
            .frame(maxWidth: .infinity, maxHeight: 300)
            
            Button {
                let newWeight = KittenWeight(weight: selectedWeight,
                                             date: .now)
                foster.weights.append(newWeight)
                do {
                    try modelContext.save()
                    showingRecordSheet.toggle()
                } catch {
                    print("Failed to save weight: \(error.localizedDescription)")
                }
            } label: {
                SaveButton()
            }
            .padding(.top)
        }
        .padding(.horizontal, 40)
        .onAppear {
            selectedDate = .now
        }
    }
    
}

struct SaveButton: View {
    
    var body: some View {
        Text("Save")
            .font(.headline)
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .background(.pink, in: .rect(cornerRadius: 10))
            .foregroundStyle(.white)
    }
}

#Preview {
    WeightChartView(foster: Foster.exampleData)
}
