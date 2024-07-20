//
//  Indicator.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 15.07.24.
//

import SwiftUI

/// A SwiftUI view that displays an indicator with a text label.
struct Indicator: View {
    /// A boolean indicating whether the indicator is active.
    private let isActive: Bool
    /// The text to display next to the indicator.
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
            /// A rounded rectangle that acts as the indicator.
            RoundedRectangle(cornerRadius: 5)
                .fill(isActive ? Color.green : Color.red)
                .frame(height: 5) // Height of the indicator

            /// The text label next to the indicator.
            Text(text)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(minWidth: 50, alignment: .leading)
                .font(.body) // Font style of the text
                .padding(.bottom, 5)
        }
        .background(Color.gray.opacity(0.2)) // Background color with opacity
        .cornerRadius(10) // Corner radius for the background
    }
}
