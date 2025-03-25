//
//  EditProfileView.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 7/26/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct EditProfileView: View {
    @Bindable var foster: Foster
    @State private var show = false
    @State private var showPicker = false
    @State private var selectedImage: PhotosPickerItem? = nil
    
    func loadPhoto() {
        Task { @MainActor in
            foster.profilePhoto = try await selectedImage?.loadTransferable(type: Data.self)
        }
    }
    
    var body: some View {
        Form {
            // Profile Header Section
            Section {
                VStack(spacing: 16) {
                    // Profile Image
                    ZStack {
                        if let profileImage = foster.profilePhoto, let uiImage = UIImage(data: profileImage) {
                            ProfileImageView(show: $show, showPicker: $showPicker, profileImage: uiImage)
                        } else {
                            EmptyImage(showPicker: $showPicker, show: $show)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
            
            // Action Buttons - Now in separate sections
            Section {
                NavigationLink(destination: FeedingLogView(foster: foster)) {
                    Label("Feedings", systemImage: "clock.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .listRowInsets(EdgeInsets())
                
                NavigationLink(destination: WeightChartView(foster: foster)) {
                    Label("Weight", systemImage: "chart.xyaxis.line")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .background(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .listRowInsets(EdgeInsets())
            }
            .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
            
            
            TextField("Name", text: $foster.name, axis: .vertical)
                .font(.title)
                .lineLimit(2)
            
            Section("Vet ID") {
                TextField("Vet ID:", text: $foster.vetId)
            }
            
            Section {
                Picker("Age:", selection: $foster.age) {
                    ForEach(0..<13) {
                        Text("\($0) Weeks").tag($0)
                    }
                }
                
                Picker("Weight:", selection: $foster.weight) {
                    ForEach(60..<1000) {
                        Text("\($0) Grams").tag($0)
                    }
                }
                
                Picker("Gender:", selection: $foster.gender) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                }
                
                DatePicker("Began Fostering:", selection: $foster.beganFostering, displayedComponents: .date)
                
                Toggle("Currently Fostering:", isOn: $foster.currentlyFostering)
            } header: {
                Text("Details")
            } footer: {
                VStack(alignment: .leading) {
                    Text("Age will update automatically as your foster grows up once you set it!")
                    Text("Weight will update automatically if you tap on track weight.")
                }
            }
            
            Section("Appearance") {
                TextField("Breed:", text: $foster.breed)
                
                TextField("Pattern:", text: $foster.pattern)
            }
            
            Section("Notes") {
                TextField("Foster Notes", text: $foster.notes, axis: .vertical)
            }
        }
        .photosPicker(isPresented: $showPicker, selection: $selectedImage, matching: .images)
        .onChange(of: selectedImage, loadPhoto)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EmptyImage: View {
    @Binding var showPicker: Bool
    @Binding var show: Bool
    
    var body: some View {
        Image(systemName: "photo.fill")
            .frame(width: 110, height: 110)
            .font(.largeTitle)
            .foregroundStyle(.white)
            .background(.gray, in: Circle())
            .onTapGesture {
                showPicker.toggle()
            }
    }
}

struct ProfileImageView: View {
    @Binding var show: Bool
    @Binding var showPicker: Bool
    var profileImage: UIImage
    var body: some View {
        Image(uiImage: profileImage)
            .resizable()
            .scaledToFill()
            .frame(width: 110, height: 110)
            .clipShape(.rect(cornerRadius: 100))
            .onTapGesture {
                showPicker.toggle()
            }
    }
}
