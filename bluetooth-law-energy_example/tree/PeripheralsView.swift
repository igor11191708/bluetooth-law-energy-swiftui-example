//
//  PeripheralsView.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 19.07.24.
//

import SwiftUI
import bluetooth_law_energy_swift
import CoreBluetooth

/// A SwiftUI view that displays a list of Bluetooth peripherals.
struct PeripheralsView: View {
    
    /// The Bluetooth manager environment object.
    @EnvironmentObject var manager: BluetoothLEManager
    
    /// Identifier for the view.
    let id: Int
    
    /// State variable to hold the list of discovered peripherals.
    @State private var peripherals: [CBPeripheral] = []
        
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            /// Header view with the given identifier.
            HeaderTpl(id: id)
            /// List of peripherals displayed in a vertical stack.
            ForEach(peripherals, id: \.getId) { item in
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(item.getName)
                            .font(.body)
                            .foregroundStyle(.gray)
                    }
                    /// Display services for each peripheral.
                    ServicesView(for: item)
                    Divider()
                }
            }
        }
        .padding(.trailing, 5)
        /// Fetch peripherals when the view appears.
        .task {
            await fetchPeripherals()
        }
    }
    
    /// Fetches the list of Bluetooth peripherals.
    private func fetchPeripherals() async {
        for await cbPeripherals in await manager.peripheralsStream {
            /// Filter out peripherals with duplicate IDs and nil names.
            let filtered: [CBPeripheral] = cbPeripherals
                .unique(by: \.getId)
                .filterNilNames
            
            /// Calculate the difference between the current and new list of peripherals.
            let diff = filtered.difference(from: peripherals)
            
            /// Update the peripherals list if there are changes.
            if let updatedPeripherals = peripherals.applying(diff) {
                peripherals = updatedPeripherals
            }
        }
    }
}
