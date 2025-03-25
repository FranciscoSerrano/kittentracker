//
//  KittenListItem.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 7/26/24.
//

import SwiftUI
import SwiftData

struct KittenListItem: View, Identifiable {
    @Bindable var foster: Foster
    var id = UUID()
    
    // Colors, THANKS BRITTANY
    let lavendar: Color = Color(red: 145 / 255, green: 166 / 255, blue: 255 / 255)
    let melon: Color = Color(red: 255 / 255, green: 166 / 255, blue: 158 / 255)
    
    var body: some View {
        HStack {
            if let profileImage = foster.profilePhoto, let uiImage = UIImage(data: profileImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            } else {
                Image(systemName: "cat.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(foster.name)
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "pawprint.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.pink)
                            .opacity(foster.currentlyFostering ? 1 : 0)
                          
                    }
                    
                    Text(foster.vetId)
                        .fontWeight(.light)
                }
                
                HStack {
                    HStack {
                        Text("🎂 \(foster.age) Weeks")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .background(melon)
                    .foregroundColor(.white)
                    .clipShape(.capsule)
                    
                    HStack {
                        Text("🥌 \(foster.weight)g")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .background(lavendar)
                    .foregroundColor(.white)
                    .clipShape(.capsule)
                }
                
            }
            Spacer()
        }
    }
}
