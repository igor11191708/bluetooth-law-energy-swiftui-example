//
//  ServicesView.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 19.07.24.
//

import SwiftUI
import bluetooth_law_energy_swift
import CoreBluetooth

/// A SwiftUI view that displays the services of a Bluetooth peripheral.
struct ServicesView: View {
    
    /// The Bluetooth manager environment object.
    @EnvironmentObject var manager: BluetoothLEManager
    
    /// The Bluetooth peripheral for which services are being displayed.
    let item: CBPeripheral
    
    /// State variables to hold service data and status.
    @State private var services: [String] = []
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @State private var isEmpty: Bool = false
    @State private var discoverTask: Task<Void, Never>? = nil
    
    /// Initializes the view for a specific peripheral.
    ///
    /// - Parameter item: The `CBPeripheral` instance.
    init(for item: CBPeripheral) {
        self.item = item
    }
    
    var body: some View {
        HStack {
            if isLoading {
                /// Shows a progress view when services are being discovered.
                ProgressView("Discovering Services...")
                    .foregroundColor(Color.white)
                    .padding()
            } else if let errorMessage {
                /// Displays an error message if discovery fails.
                HStack {
                    Text(errorMessage)
                        .foregroundStyle(.yellow)
                }
            } else if isEmpty {
                /// Shows a message if no services are found.
                Text("No services found")
                    .foregroundColor(Color.white)
                    .padding()
            } else {
                /// Displays the services in a grid view.
                ServiceGrid(services: services)
            }
            
            Spacer()
            if !isLoading {
                /// Button to manually update the services.
                CustomButtonView(text: "update") {
                    Task {
                        await discoverServices(cache: false)
                    }
                }
                .padding(.trailing)
            }
        }
        .padding(.top)
        .onAppear {
            /// Start discovering services when the view appears.
            discoverTask = Task {
                await discoverServices()
            }
        }
        .onDisappear {
            /// Cancel the discovery task when the view disappears.
            discoverTask?.cancel()
        }
    }

    /// Discovers the services for the peripheral.
    ///
    /// - Parameter cache: A Boolean value indicating whether to use cached data.
    func discoverServices(cache: Bool = true) async {
        errorMessage = nil
        isLoading = true
        isEmpty = false
        do {
            /// Fetch the services and update the state variables.
            let discoveredServices = try await manager.discoverServices(for: item, from: cache).map { $0.uuid.uuidString }
            self.services = discoveredServices
            if discoveredServices.isEmpty {
                isEmpty = true
            }
        } catch let error as BluetoothLEManager.Errors {
            /// Handle known errors from the Bluetooth manager.
            self.errorMessage = error.localizedDescription
        } catch {
            /// Handle any other errors.
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
