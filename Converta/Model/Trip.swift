//
//  Trip.swift
//  Converta
//
//  Created by Ernest Dainals on 08/08/2023.
//

import Foundation

// This may be replaced or altered for CloudKit support.
struct Trip: Identifiable {
    let id = UUID().uuidString
    let name: String
    let destination: String
    let destinationCurrency: CurrencyCode.RawValue
    let startDate: Date
    let endDate: Date
}

struct MockData_Trip {
    static var trip1 = Trip(name: "Family Trip to the U.K", destination: "London", destinationCurrency: CurrencyCode.BritishPoundSterling.rawValue, startDate: .now.someDayBefore(value: 7), endDate: .now.someDayAfter(value: 5))
    
    static var trip2 = Trip(name: "", destination: "Paris", destinationCurrency: CurrencyCode.Euro.rawValue, startDate: .now.someDayBefore(value: 17), endDate: .now.someDayBefore(value: 10))
    
    static var trips = [trip1, trip2]
}
