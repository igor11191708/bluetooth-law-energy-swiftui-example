//
//  CustomButtonView.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 18.07.24.
//

import SwiftUI

struct CustomButtonView: View {
    let text: String
    let color : Color = .green
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.body)
                .padding(8)
                .background(.clear)
                .foregroundColor(color)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
