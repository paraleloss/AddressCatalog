//
//  AddressManager.swift
//  AddressesCatalog
//
//  Created by Saúl Pérez on 29/04/26.
//

import Foundation

class AddressManager {
    static let shared = AddressManager()
    private(set) var addresses: [Address] = []
    
    private let fileName = "Address"
    private let savedFileName = "addresses.json"
    
    private init() {
        loadData()
    }

    func loadData() {

        if let savedAddresses = loadFromLocal() {
            addresses = savedAddresses
            return
        }
        
        guard let csvURL = Bundle.main.url(forResource: fileName, withExtension: "csv") else {
            print("No se encontró Address.csv")
            return
        }
        
        do {
            let csvString = try String(contentsOf: csvURL, encoding: .utf8)
            addresses = parseCSV(csvString)
            saveToLocal() // 1st save
        } catch {
            print("Error leyendo CSV: \(error)")
        }
    }
    
    private func parseCSV(_ csvString: String) -> [Address] {
        var addresses: [Address] = []
        let rows = csvString.components(separatedBy: .newlines)
        
        guard rows.count > 1 else { return [] }
        
        for row in rows.dropFirst() {
            let columns = row.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            guard columns.count >= 9 else { continue }
            
            if let addressID = Int(columns[0]),
               let modifiedDate = parseDate(columns[8]) {
                
                let address = Address(
                    id: addressID,
                    addressLine1: columns[1],
                    addressLine2: columns[2] == "NULL" ? nil : columns[2],
                    city: columns[3],
                    stateProvince: columns[4],
                    countryRegion: columns[5],
                    postalCode: columns[6],
                    rowguid: columns[7],
                    modifiedDate: modifiedDate
                )
                addresses.append(address)
            }
        }
        return addresses
    }
    
    private func parseDate(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateString)
    }
    
    // MARK: - data persistance
    private func saveToLocal() {
        do {
            let data = try JSONEncoder().encode(addresses)
            let url = getDocumentsDirectory().appendingPathComponent(savedFileName)
            try data.write(to: url)
        } catch {
            print("Error guardando datos: \(error)")
        }
    }
    
    private func loadFromLocal() -> [Address]? {
        let url = getDocumentsDirectory().appendingPathComponent(savedFileName)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Address].self, from: data)
        } catch {
            print("Error cargando datos locales: \(error)")
            return nil
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - update method
    func updateAddress(_ address: Address) {
        if let index = addresses.firstIndex(where: { $0.id == address.id }) {
            addresses[index] = address
            saveToLocal()
        }
    }
    
    // get cities
    func getUniqueCities() -> [String] {
        Array(Set(addresses.map { $0.city })).sorted()
    }
    
    func getUniqueStates() -> [String] {
        Array(Set(addresses.map { $0.stateProvince })).sorted()
    }
}
