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
    @Binding var path: [Foster]
    
    // for image
    @State private var show = false
    @State private var showPicker = false
    @State private var selectedImage: PhotosPickerItem? = nil
    
    var body: some View {
        Form {
            Section {
                HStack {
                    ZStack {
                        if let profileImage = foster.profilePhoto, let uiImage = UIImage(data: profileImage) {
                            ProfileImageView(show: $show, showPicker: $showPicker, profileImage: uiImage)
                        } else {
                            EmptyImage(showPicker: $showPicker, show: $show)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        path.append(foster)
                    } label: {
                        HStack {
                            Image(systemName: "chart.xyaxis.line")
                                .font(.title2)
                            Text("Track Weight")
                                .font(.title3)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(.pink, in: .rect(cornerRadius: 10))
                    }
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                .listRowSeparator(.hidden)
            }
            
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
                    Text("Weight will update automatilly if you tap on track weight.")
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
    
    func loadPhoto() {
        Task { @MainActor in
            foster.profilePhoto = try await selectedImage?.loadTransferable(type: Data.self)
        }
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
