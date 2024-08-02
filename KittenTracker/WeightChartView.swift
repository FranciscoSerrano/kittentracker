//
//  WeightChartView.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 7/27/24.
//

import SwiftUI
import Charts

struct KittenWeight: Identifiable {
    var id = UUID()
    var date: Date
    var weight: Int


    init(month: Int, weight: Int) {
        let calendar = Calendar.autoupdatingCurrent
        self.date = calendar.date(from: DateComponents(year: 2024, month: month))!
        self.weight = weight
    }
}


var data: [KittenWeight] = [
    KittenWeight(month: 1, weight: 250),
    KittenWeight(month: 2, weight: 300),
    KittenWeight(month: 3, weight: 160),
    KittenWeight(month: 4, weight: 400),
    KittenWeight(month: 5, weight: 460),
    KittenWeight(month: 6, weight: 470),
    KittenWeight(month: 7, weight: 510),
    KittenWeight(month: 8, weight: 600),
    KittenWeight(month: 9, weight: 710),
    KittenWeight(month: 10, weight: 800),
]

struct WeightChartView: View {
    
    //@Bindable var foster: Foster
    
    @State private var showingRecordSheet = false
    @State private var selectedDate: Date = .now
    @State private var selectedWeight: Int = 0
    @State private var goalWeight = 750
    @State private var showingPopover = false
    
    var body: some View {
        VStack {
            HStack {
                GroupBox {
                    Text("\(data.last!.weight) grams")
                        .font(.title)
                }
                label: {
                    Label("Current Weight", systemImage: "calendar")
                        .foregroundStyle(.teal)
                }
                
                GroupBox {
                    Text("4% Increase")
                        .font(.title)
                }
                label: {
                    Label("Change", systemImage: "arrow.up.right")
                        .foregroundStyle(.green)
                }
            }
            .padding([.horizontal])
            
            GroupBox {
                Chart(data) {
                    RuleMark(y: .value("Goal Weight", goalWeight))
                        .foregroundStyle(.mint)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .annotation(alignment: .leading) {
                            Text("Goal")
                                .font(.caption2)
                                .foregroundStyle(.mint)
                        }
                    
                    LineMark(
                        x: .value("Month", $0.date),
                        y: .value("Weight", $0.weight)
                    )
                    .foregroundStyle(.pink)
                }
                .frame(height: 200)
            } label: {
                HStack {
                    Label("Foster Weight", systemImage: "list.bullet.clipboard")
                        .foregroundStyle(.red)
                    
                    Spacer()
                    
                    Menu("Adjust Goal Weight") {
                        Text("\(goalWeight)")
                        Stepper("", value: $goalWeight)
                    }
                    .font(.caption)
                }
            }
            .padding([.bottom, .horizontal])
            
            Button {
                showingRecordSheet.toggle()
            } label: {
                CustomButton(text: "Record New Weight", color: .pink)
            }
            
            VStack(alignment: .leading) {
                Label("History", systemImage: "clock.arrow.circlepath")
                    .font(.headline)
                
                List {
                    ForEach(data) { value in
                        VStack(alignment: .leading) {
                            Text("Weight: \(value.weight)")
                            Text("Date: \(value.date.formatted())")
                        }
                    }
                }
                .listStyle(.inset)
            }
            .padding()
            
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
                DatePicker("Date:", selection: $selectedDate, displayedComponents: .date)
                
                Section("Current Weight") {
                    TextField("Current Weight", value: $selectedWeight, format: .number)
                }
            }
            .formStyle(.grouped)
            .frame(maxWidth: .infinity, maxHeight: 300)
            
            Button {
                showingRecordSheet.toggle()
            } label: {
                CustomButton(text: "Save", color: .pink)
            }
            .padding(.top)
        }
        .padding(.horizontal, 40)
    }

}

struct CustomButton: View {
    var text: String
    var color: Color
    
    var body: some View {
        Text(text)
            .font(.headline)
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .background(color, in: .rect(cornerRadius: 10))
            .foregroundStyle(.white)
    }
}

#Preview {
    WeightChartView()
}
