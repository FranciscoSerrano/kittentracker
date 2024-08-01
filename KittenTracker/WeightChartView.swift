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
    KittenWeight(month: 1, weight: 150),
    KittenWeight(month: 2, weight: 165),
    KittenWeight(month: 3, weight: 160),
    KittenWeight(month: 4, weight: 167),
    KittenWeight(month: 5, weight: 180),
    KittenWeight(month: 6, weight: 175),
    KittenWeight(month: 7, weight: 190),
    KittenWeight(month: 8, weight: 210),
    KittenWeight(month: 9, weight: 240),
    KittenWeight(month: 10, weight: 280),
]

struct WeightChartView: View {
    var body: some View {
        GroupBox {
            Text("Kitten Weight Over Time")
            
            Chart(data) {
                LineMark(
                    x: .value("Month", $0.date),
                    y: .value("Weight", $0.weight)
                )
            }
        }
    }
}

#Preview {
    WeightChartView()
}
