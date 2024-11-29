
# Bluetooth Low Energy Service example

This example project demonstrates how to use the bluetooth-law-energy-swift package to manage Bluetooth Low Energy (BLE) operations within a SwiftUI application.
[Bluetooth Low Energy Service package](https://github.com/swiftuiux/bluetooth-law-energy-swift)

## 🟡 Running Bluetooth LE Code on Simulator


The example code provided for Bluetooth Low Energy (BLE) functionality utilizes CoreBluetooth, which requires actual Bluetooth hardware to operate like iPhone etc. Simulators does not support Bluetooth functionalities as it lacks the necessary hardware capabilities.

## 🟡 De-initialization
De-initialization of a BLE manager, may not be instantaneous and can vary in duration, depending largely on ongoing BLE tasks and the specifics of Swift’s concurrency model. Tasks already in progress must be completed before resources are freed, as ongoing operations cannot be arbitrarily canceled once they have begun. This behavior is influenced not only by the internal mechanics of the BLE manager but also by the concurrency model where certain tasks, even if marked for cancellation, continue until their current actions are resolved.

 ![macOS 11](https://github.com/swiftuiux/bluetooth-law-energy-swift/blob/main/img/ble_mac.png)  

## Granting Bluetooth Access for macOS

When your macOS application is not authorized to use Bluetooth, you will see a window directing you to System Preferences, Security & Privacy, and Bluetooth. To grant access, follow these steps:

### Locate the Compiled macOS File

1. Open Xcode.
2. Go to the menu bar and select `Xcode` > `Preferences...`.
3. In the Preferences window, select the `Locations` tab.
4. Note the path to the Derived Data directory.
5. Open Finder and navigate to the Derived Data directory:
   ```shell
   ~/Library/Developer/Xcode/DerivedData/
   ```
6. Inside the Derived Data directory, locate the folder for your project. It will have a name that includes your project's name and a random identifier (e.g., `Your_Project_Name-abcdefgh`).
7. Navigate to `Build/Products/Debug` (or `Build/Products/Release` if you built a release version).
8. You will find the compiled macOS executable file in this folder.

### Grant Access to Bluetooth

1. Open System Preferences on your Mac.
2. Go to `Security & Privacy`.
3. Select the `Privacy` tab.
4. Scroll down to find and select `Bluetooth`.
5. Click the lock icon to make changes and enter your admin password.
6. Click the `+` button to add a new application.
7. Navigate to the location of your compiled macOS executable file (as described above) and select it.
8. Ensure that your application is checked in the list to allow Bluetooth access.

## Enabling Bluetooth in Entitlements

To enable Bluetooth access for your macOS application, you need to modify the entitlements file. Here are the steps to add the required entitlement:

### Add Bluetooth Entitlement

1. Open your project in Xcode.
2. Select your project in the Project Navigator.
3. Select your app target.
4. Go to the `Signing & Capabilities` tab.
5. Click the `+ Capability` button.
6. Add the `App Sandbox` capability if it is not already added.
7. Under the `App Sandbox` settings, ensure that the `Hardware` > `Bluetooth` option is checked.

### Modify the Entitlements File

1. Open your entitlements file (usually named `YourApp.entitlements`).
2. Ensure it includes the `com.apple.security.device.bluetooth` key. It should look like this:

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>com.apple.security.app-sandbox</key>
       <true/>
       <key>com.apple.security.device.bluetooth</key>
       <true/>
   </dict>
   </plist>
   ```

This configuration ensures that your application has the necessary permissions to use Bluetooth on macOS.
