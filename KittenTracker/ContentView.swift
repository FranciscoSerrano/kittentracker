//
//  ContentView.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 7/26/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Foster.name) var fosters: [Foster]
    @State private var path = [Foster]()
    
    // custom sorting
    @State private var sortOrder = SortDescriptor(\Foster.name)
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(fosters) { foster in
                    NavigationLink(value: foster) {
                        KittenListItem(foster: foster)
                            .listRowSeparator(.hidden)
                    }
                }
                .onDelete(perform: deleteFoster)
            }
            .listStyle(.plain)
            .navigationTitle("Fosters")
            .navigationDestination(for: Foster.self, destination: EditProfileView.init)
            .toolbar {
                Button("Add Foster", systemImage: "plus", action: addFoster)
            }
        }
    }
    
    func addFoster() {
        let foster = Foster()
        modelContext.insert(foster)
        path = [foster]
    }
    
    func deleteFoster(_ indexSet: IndexSet) {
        for index in indexSet {
            let foster = fosters[index]
            modelContext.delete(foster)
        }
    }
}

#Preview {
    ContentView()
}
