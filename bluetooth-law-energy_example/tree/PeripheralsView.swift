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
    
    @EnvironmentObject var manager: BluetoothLEManager
    
    let id: Int // Identifier
    
    @State private var peripherals: [CBPeripheral] = []
        
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HeaderTpl(id: id)
            ForEach(peripherals, id : \.getId){ item in
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        Text(item.getName)
                            .font(.body)
                            .foregroundStyle(.gray)
                    }
                    ServicesView(for: item)
                    Divider()
                }
            }
        }
        .padding(.trailing, 5)
        .task {
            await fetchPeripherals() // Fetch peripherals when the view appears
        }
    }
    
    /// Fetches the list of Bluetooth peripherals.
    private func fetchPeripherals() async {
        for await cbPeripherals in manager.peripheralsStream {
            let filtered: [CBPeripheral] = cbPeripherals
                .unique(by: \.getId)
                .filterNilNames
                
            let diff = filtered.difference(from: peripherals)
            
            if let updatedPeripherals = peripherals.applying(diff) {
                peripherals = updatedPeripherals
            }
        }
    }
}
