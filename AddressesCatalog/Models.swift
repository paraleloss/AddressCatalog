//
//  Models.swift
//  AddressesCatalog
//
//  Created by Saúl Pérez on 29/04/26.
//

import Foundation

struct Address: Codable, Identifiable {
    let id: Int
    var addressLine1: String
    var addressLine2: String?
    var city: String
    var stateProvince: String
    var countryRegion: String
    var postalCode: String
    var rowguid: String
    var modifiedDate: Date
    
    var idString: String { "\(id)" }
    
    enum CodingKeys: String, CodingKey {
        case id = "AddressID"
        case addressLine1 = "AddressLine1"
        case addressLine2 = "AddressLine2"
        case city = "City"
        case stateProvince = "StateProvince"
        case countryRegion = "CountryRegion"
        case postalCode = "PostalCode"
        case rowguid
        case modifiedDate = "ModifiedDate"
    }
}
