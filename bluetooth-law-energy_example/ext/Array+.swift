//
//  Array+.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 17.07.24.
//

import CoreBluetooth

/// Extension to filter unique elements in an array based on a given key path.
extension Array {
    /// Returns an array of unique elements based on the specified key path.
    ///
    /// - Parameter keyPath: The key path to use for uniqueness.
    /// - Returns: An array of unique elements.
    func unique<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { element in
            let key = element[keyPath: keyPath]
            return seen.insert(key).inserted
        }
    }
}

/// Extension to filter elements in an array based on a specific value for a given key path.
extension Array {
    /// Returns an array of elements that match the specified value for the given key path.
    ///
    /// - Parameters:
    ///   - keyPath: The key path to filter by.
    ///   - value: The value to filter elements against.
    /// - Returns: An array of elements that match the specified value.
    func filter<T: Hashable>(by keyPath: KeyPath<Element, T>, value: T) -> [Element] {
        return filter { element in
            let v = element[keyPath: keyPath]
            return v == value
        }
    }
}

/// Extension specific to arrays of `CBPeripheral` to filter out peripherals with nil names.
extension Array where Element: CBPeripheral {
    /// Returns an array of peripherals that have non-nil names.
    var filterNilNames: [CBPeripheral] {
        let newElements: [CBPeripheral] = self.compactMap { peripheral in
            guard peripheral.name != nil else {
                return nil
            }
            return peripheral
        }
        return newElements
    }
}

/// Extension to calculate the difference between two arrays of identifiable elements.
extension Array where Element: Identifiable {
    /// Returns an array of elements that are present in the current array but not in the other array.
    ///
    /// - Parameter other: The array to compare against.
    /// - Returns: An array of elements that are different from the other array.
    func difference(from other: [Element]) -> [Element] {
        return self.compactMap {
            other.containsElement(withID: $0.id) ? nil : $0
        }
    }
}

/// Extension to check if an array contains an element with a specific ID.
extension Array where Element: Identifiable {
    /// Checks if the array contains an element with the given ID.
    ///
    /// - Parameter id: The ID to check for.
    /// - Returns: A boolean indicating whether an element with the given ID is present in the array.
    func containsElement(withID id: Element.ID) -> Bool {
        return self.contains { $0.id == id }
    }
}
