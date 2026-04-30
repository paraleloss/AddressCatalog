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
    
    private let csvFileName = "Address"
    private let savedFileName = "addresses.json"
    
    private init() {
        loadData()
    }
    
    func loadData() {
        // 1. Intentar cargar desde JSON local
        if let saved = loadFromLocal(), !saved.isEmpty {
            addresses = saved
            print("✅ Cargadas \(addresses.count) direcciones desde JSON local")
            return
        }
        
        // 2. Cargar CSV desde Bundle
        guard let csvURL = Bundle.main.url(forResource: csvFileName, withExtension: "csv") else {
            print("❌ ERROR CRÍTICO: No se encontró Address.csv en el Bundle")
            return
        }
        
        do {
            let csvString = try String(contentsOf: csvURL, encoding: .utf8)
            print("✅ CSV encontrado | Caracteres: \(csvString.count)")
            print("Primeras 300 caracteres:\n\(csvString.prefix(300))")
            
            // Parser muy simple para diagnóstico
            addresses = simpleParseCSV(csvString)
            
            print("📊 Total de direcciones parseadas: \(addresses.count)")
            
            if addresses.count > 0 {
                saveToLocal()
                print("🎉 ¡ÉXITO! Se cargaron \(addresses.count) direcciones.")
            } else {
                print("❌ Falló el parsing. Ninguna dirección fue cargada.")
            }
        } catch {
            print("❌ Error al leer el archivo: \(error)")
        }
    }
    
    // Parser extremadamente simple y tolerante para este CSV
    private func simpleParseCSV(_ csvString: String) -> [Address] {
        var result: [Address] = []
        let lines = csvString.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        print("Total de líneas detectadas: \(lines.count)")
        
        for (index, line) in lines.enumerated() {
            if index == 0 { continue } // saltar header
            
            let columns = line.components(separatedBy: ",")
            
            guard columns.count >= 9 else {
                if index < 10 {
                    print("Línea \(index) tiene solo \(columns.count) columnas: \(line.prefix(100))...")
                }
                continue
            }
            
            guard let id = Int(columns[0].trimmingCharacters(in: .whitespaces)) else { continue }
            
            let dateStr = columns[8].trimmingCharacters(in: .whitespaces)
            guard let modifiedDate = parseDate(dateStr) else { continue }
            
            let address = Address(
                id: id,
                addressLine1: columns[1].trimmingCharacters(in: .whitespaces),
                addressLine2: columns[2] == "NULL" ? nil : columns[2].trimmingCharacters(in: .whitespaces),
                city: columns[3].trimmingCharacters(in: .whitespaces),
                stateProvince: columns[4].trimmingCharacters(in: .whitespaces),
                countryRegion: columns[5].trimmingCharacters(in: .whitespaces),
                postalCode: columns[6].trimmingCharacters(in: .whitespaces),
                rowguid: columns[7].trimmingCharacters(in: .whitespaces),
                modifiedDate: modifiedDate
            )
            result.append(address)
        }
        return result
    }
    
    private func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        if let date = formatter.date(from: dateString) { return date }
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: dateString) { return date }
        
        return nil
    }
    
    // Persistencia (sin cambios)
    private func saveToLocal() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(addresses)
            let url = getDocumentsDirectory().appendingPathComponent(savedFileName)
            try data.write(to: url)
        } catch { print("Error guardando JSON") }
    }
    
    private func loadFromLocal() -> [Address]? {
        let url = getDocumentsDirectory().appendingPathComponent(savedFileName)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Address].self, from: data)
        } catch { return nil }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func updateAddress(_ address: Address) {
        if let index = addresses.firstIndex(where: { $0.id == address.id }) {
            addresses[index] = address
            saveToLocal()
        }
    }
    
    func getUniqueCities() -> [String] { Array(Set(addresses.map { $0.city })).sorted() }
    func getUniqueStates() -> [String] { Array(Set(addresses.map { $0.stateProvince })).sorted() }
}
