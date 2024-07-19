//
//  HeaderTpl.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 18.07.24.
//

import SwiftUI

struct HeaderTpl: View {
    let id: Int
    
    var body: some View {
        HStack{
            Text("VIEW ID :: \(id)")
                .lineLimit(1)
                .padding()
                .font(.body)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .shadow(radius: 1, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 0.5)
        )
        .padding(.bottom)
    }
}
