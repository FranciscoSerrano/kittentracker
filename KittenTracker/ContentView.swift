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
    @Query(sort: [SortDescriptor(\Foster.name)]) var fosters: [Foster]
    @State private var path = [Foster]()
    
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
            .navigationDestination(for: Foster.self) { foster in
                EditProfileView(foster: foster, path: $path)
            }
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
