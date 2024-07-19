//
//  ContentView.swift
//  bluetooth-law-energy_example
//
//  Created by Igor on 12.07.24.
//

import SwiftUI
import Combine
import bluetooth_law_energy_swift
import CoreBluetooth

/// A SwiftUI view that manages Bluetooth LE operations and displays relevant information.
struct ContentView: View {
    
    /// State object for managing Bluetooth LE operations.
    @StateObject var manager = BluetoothLEManager()
    
    /// State variables for toggles.
    @State var isOne: Bool = true
    @State var isTwo: Bool = true
    @State var isThree: Bool = true
    
    /// State variables for Bluetooth LE states.
    @State private var showAlert = false
    @State var isAuthorized = false
    @State var isPowered = false
    @State var isScanning = false
    
    /// Combined publisher for authorization and power state.
    private var combinedPublisher: AnyPublisher<BLEState, Never> {
        manager.bleState
            .dropFirst() // Drop the initial values
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Computed property for power text.
    var powerText: String {
        isPowered ? "Powered" : (isAuthorized ? "Not powered..." : "Unknown")
    }
    
    /// Computed property for authorization text.
    var authorizedText: String {
        isAuthorized ? "Authorized" : "Not Authorized..."
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Toggle("First view", isOn: $isOne) // Toggle for the first view
                #if os(macOS)
                Toggle("Second view", isOn: $isTwo) // Toggle for the second view
                Toggle("Third view", isOn: $isThree) // Toggle for the third view
                #endif
            }
            .font(.title3)
            
            HStack(spacing: 5) {
                Spacer()
                Indicator(isPowered, powerText) // Indicator for power state
                Indicator(isAuthorized, authorizedText) // Indicator for authorization state
                Indicator(isScanning, "Scanning") // Indicator for scanning state
                Spacer()
            }
            
            ScrollView {
                HStack(alignment: .top, spacing: 5) {
                    if isOne {
                        PeripheralsView(id: 1).padding(.top)
                    }
                    #if os(macOS)
                    if isTwo {
                        PeripheralsView(id: 2).padding(.top)
                    }
                    if isThree {
                        ForEach(3..<5, id: \.self) { item in
                            PeripheralsView(id: item).padding(.top)
                        }
                    }
                    #endif
                }
            }
        }
        .onReceive(combinedPublisher) { state in
            isAuthorized = state.isAuthorized
            isPowered = state.isPowered
            isScanning = state.isScanning
            showAlert = !isAuthorized || !isPowered
        }
        .environmentObject(manager)
        .alert(isPresented: $showAlert) {
            alertView(isAuthorized) // Alert view
        }
    }
}
