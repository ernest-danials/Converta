//
//  Schema.swift
//  Converta
//
//  Created by Ernest Dainals on 15/02/2023.
//

import Foundation

// MARK: - API Responses
struct CurrencyAPIResponse_Latest: Decodable {
    let meta: Meta
    let data: [String: Currency]
    
    init(data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(Self.self, from: data)
    }
}

struct CurrencyAPIResponse_Currencies: Decodable {
    let data: [String: CurrencyData?]
}

struct CurrencyAPIResponse_Historical: Decodable {
    let meta: Meta
    let data: [String: Currency]
    
    init(data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(Self.self, from: data)
    }
}

// MARK: - Models
struct Currency: Decodable {
    let code: String
    let value: Float
}

struct Meta: Decodable {
    let lastUpdatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case lastUpdatedAt = "last_updated_at"
    }
}

struct CurrencyData: Decodable {
    let symbol, name, symbolNative: String
    let decimalDigits, rounding: Int
    let code, namePlural: String
    let iconName: String?

    enum CodingKeys: String, CodingKey {
        case symbol, name
        case symbolNative = "symbol_native"
        case decimalDigits = "decimal_digits"
        case rounding, code
        case namePlural = "name_plural"
        case iconName = "icon_name"
    }
}
