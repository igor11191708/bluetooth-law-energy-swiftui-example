//
//  Array+.swift
//  bluetooth-law-energy_example
//
//  Created by Igor  on 17.07.24.
//

import CoreBluetooth

extension Array {
    func unique<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { element in
            let key = element[keyPath: keyPath]
            return seen.insert(key).inserted
        }
    }
}

extension Array {
    func filter<T: Hashable>(by keyPath: KeyPath<Element, T>, value : T) -> [Element] {
        return filter { element in
            let v = element[keyPath: keyPath]
            return v == value
        }
    }
}

extension Array where Element: CBPeripheral {
    var filterNilNames : [CBPeripheral] {
        
        let newElements: [CBPeripheral] = self.compactMap { peripheral in
            guard peripheral.name != nil else {
                return nil
            }
            return peripheral
        }
        return newElements
    }
}

extension Array where Element: Identifiable {
    func difference(from other: [Element]) -> [Element] {
        return self.compactMap{
            other.containsElement(withID: $0.id) ? nil : $0
        }
    }
}

extension Array where Element: Identifiable {
    func containsElement(withID id: Element.ID) -> Bool {
        return self.contains { $0.id == id }
    }
}
