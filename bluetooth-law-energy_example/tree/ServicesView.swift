//
//  ServicesView.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 19.07.24.
//

import SwiftUI
import bluetooth_law_energy_swift
import CoreBluetooth

struct ServicesView: View {
    
    @EnvironmentObject var manager: BluetoothLEManager
    
    let item: CBPeripheral
    
    @State private var services: [String] = []
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @State private var isEmpty: Bool = false
    @State private var discoverTask: Task<Void, Never>? = nil
    
    init(for item: CBPeripheral) {
        self.item = item
    }
    
    var body: some View {
        HStack{
            if isLoading {
                ProgressView("Discovering Services...")
                    .foregroundColor(Color.white)
                    .padding()
            } else if let errorMessage {
                HStack{
                    Text(errorMessage)
                        .foregroundStyle(.yellow)
                }
            } else if isEmpty {
                Text("No services found")
                    .foregroundColor(Color.white)
                    .padding()
            } else {
                ServiceGrid(services: services)
            }
            
            Spacer()
            if !isLoading {
                CustomButtonView(text: "update") {
                    Task {
                        await discoverServices(cache: false)
                    }
                }.padding(.trailing)
            }
        }
        .padding(.top)
        .onAppear {
            discoverTask = Task {
                await discoverServices()
            }
        }
        .onDisappear {
            discoverTask?.cancel()
        }
    }

    func discoverServices(cache : Bool = true) async {
        errorMessage = nil
        isLoading = true
        isEmpty = false
        do {
            let discoveredServices = try await manager.fetchServices(for: item, cache: cache).map { $0.uuid.uuidString }
            self.services = discoveredServices
            if discoveredServices.isEmpty {
                isEmpty = true
            }
        } catch let error as BluetoothLEManager.Errors {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
