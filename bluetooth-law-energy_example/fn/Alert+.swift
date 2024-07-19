//
//  Alert+.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 19.07.24.
//

import SwiftUI

/// Creates the alert view based on the current Bluetooth state.
///
/// - Returns: An alert informing the user about the Bluetooth authorization or power state.
func alertView(_ isAuthorized: Bool) -> Alert {
    if !isAuthorized {
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
