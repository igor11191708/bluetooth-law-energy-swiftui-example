//
//  Indicator.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 15.07.24.
//

import SwiftUI


/// A SwiftUI view that displays an indicator with a text label.
struct Indicator: View {
    private let isActive: Bool
    private let text: String

    /// Initializes an `Indicator` view.
    ///
    /// - Parameters:
    ///   - isActive: A boolean indicating whether the indicator is active.
    ///   - text: The text to display next to the indicator.
    init(_ isActive: Bool, _ text: String) {
        self.isActive = isActive
        self.text = text
    }

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(isActive ? Color.green : Color.red)
                .frame(height: 5) // Indicator

            Text(text)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(minWidth: 50, alignment: .leading)
                .font(.body) // Text label
                .padding(.bottom, 5)
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
