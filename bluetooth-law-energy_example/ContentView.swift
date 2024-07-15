//
//  ContentView.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 12.07.24.
//

import SwiftUI
import Combine
import bluetooth_law_energy_swift
import CoreBluetooth

/// A SwiftUI view that manages Bluetooth LE operations and displays relevant information.
struct ContentView: View {
    
    /// State object for managing Bluetooth LE operations.
    @StateObject var manager = BluetoothLEManager()
    
    /// State variable for the first toggle.
    @State var isOne: Bool = true
    
    /// State variable for the second toggle.
    @State var isTwo: Bool = false
    
    /// State variable for alert presentation.
    @State private var showAlert = false
    
    /// Combined publisher for authorization and power state.
    private var combinedPublisher: AnyPublisher<(Bool, Bool), Never> {
        manager.$isAuthorized
            .combineLatest(manager.$isPowered)
            .dropFirst() // Drop the initial values
            .eraseToAnyPublisher()
    }
    
    /// Computed property for power text.
    var powerText: String {
        manager.isPowered ? "Powered" : (manager.isAuthorized ? "Not powered..." : "Unknown")
    }
    
    /// Computed property for authorization text.
    var authorizedText: String {
        manager.isAuthorized ? "Authorized" : "Not Authorized..."
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                Toggle("First view", isOn: $isOne) // Toggle for the first view
                Toggle("Second view", isOn: $isTwo) // Toggle for the second view
            }
            .font(.title3)
     
            HStack(spacing: 5) {
                Spacer()
                Indicator(manager.isPowered, powerText) // Indicator for power state
                Indicator(manager.isAuthorized, authorizedText) // Indicator for authorization state
                Indicator(manager.isScanning, "Scanning") // Indicator for scanning state
                Spacer()
            }
            HStack(spacing: 0) {
                if isOne {
                    BLEView(id: 1)
                        .padding(.top) // First BLE view
                }
                if isTwo {
                    BLEView(id: 2)
                        .padding(.top) // Second BLE view
                }
            }
            Spacer()
        }
        .onReceive(combinedPublisher) { isAuthorized, isPowered in
            if !isAuthorized {
                showAlert = true
            } else if !isPowered {
                showAlert = true
            } else {
                showAlert = false
            }
        }
        .environmentObject(manager)
        .alert(isPresented: $showAlert) {
            alertView() // Alert view
        }
    }
    
    /// Creates the alert view based on the current Bluetooth state.
    ///
    /// - Returns: An alert informing the user about the Bluetooth authorization or power state.
    private func alertView() -> Alert {
        if !manager.isAuthorized {
            return Alert(
                title: Text("Bluetooth Not Authorized"),
                message: Text("Please enable Bluetooth in settings."),
                primaryButton: .default(Text("Settings")) {
                    openSettings()
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        } else {
            return Alert(
                title: Text("Bluetooth Off"),
                message: Text("Please enable Bluetooth power."),
                primaryButton: .default(Text("Settings")) {
                    openBluetoothSettings()
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
    
    /// Opens the Bluetooth settings.
    private func openBluetoothSettings() {
        #if os(iOS)
        guard let bluetoothSettingsURL = URL(string: "App-Prefs:root=Bluetooth") else {
            return
        }
        if UIApplication.shared.canOpenURL(bluetoothSettingsURL) {
            UIApplication.shared.open(bluetoothSettingsURL)
        } else {
            openSettings()
        }
        #elseif os(macOS)
        if let bluetoothPrefPane = URL(string: "x-apple.systempreferences:com.apple.Bluetooth") {
            NSWorkspace.shared.open(bluetoothPrefPane)
        }
        #endif
    }
    
    /// Opens the app settings.
    private func openSettings() {
        #if os(iOS)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
        #elseif os(macOS)
        if let appSettings = URL(string: "x-apple.systempreferences:com.apple.preferences") {
            NSWorkspace.shared.open(appSettings)
        }
        #endif
    }
}

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
            RoundedRectangle(cornerRadius: 15)
                .fill(isActive ? Color.green : Color.red)
                .frame(height: 15) // Indicator

            Text(text)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(minWidth: 50, alignment: .leading)
                .font(.title3) // Text label
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

/// A SwiftUI view that displays a list of Bluetooth peripherals.
struct BLEView: View {
    
    @EnvironmentObject var manager: BluetoothLEManager // Environment object for BluetoothLEManager
    
    let id: Int // Identifier for the BLE view
    
    @State private var peripherals: [Peripheral] = [] // State variable for the list of peripherals
    
    /// Initializes a `BLEView` with a given ID.
    ///
    /// - Parameter id: The identifier for the BLE view.
    init(id: Int) {
        self.id = id
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("View ID: \(id)").padding(.bottom) // Display the view ID
            List(peripherals) { peripheral in
                Text(peripheral.name) // Display the peripheral name
            }
        }
        .task {
            await fetchPeripherals() // Fetch peripherals when the view appears
        }
    }
    
    /// Fetches the list of Bluetooth peripherals.
    private func fetchPeripherals() async {
        for await cbPeripherals in manager.peripheralsStream {
            peripherals = cbPeripherals.compactMap { if let name = $0.name { return Peripheral(name: name, peripheral: $0) } else { return nil } }
        }
    }
}

/// A model representing a Bluetooth peripheral.
struct Peripheral: Identifiable, Hashable {
    
    let id = UUID() // Unique identifier for the peripheral
    
    let name: String // Name of the peripheral
    
    let peripheral: CBPeripheral
}
