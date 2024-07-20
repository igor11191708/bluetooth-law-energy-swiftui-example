//
//  ServiceView.swift
//  bluetooth-law-energy_example
//
//  Created by Igor on 18.07.24.
//

import SwiftUI

/// A SwiftUI view that displays a grid of service descriptions.
struct ServiceGrid: View {
    let services: [String]

    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 80))
        ]
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            ForEach(services, id: \.self) { service in
                Text(service.description)
                    .lineLimit(1)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            }
        }
    }
}
