//
//  BadgeView.swift
//  KittenTracker
//
//  Created by Francisco Serrano on 7/27/24.
//

import SwiftUI

struct Badge: View {
    var systemImage: String
    var text: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
            
            Text(text)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 12)
        .background(color)
        .foregroundColor(.white)
        .clipShape(.capsule)
    }
}
