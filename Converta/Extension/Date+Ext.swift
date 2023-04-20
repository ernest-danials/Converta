//
//  Date+EXt.swift
//  Converta
//
//  Created by Ernest Dainals on 09/04/2023.
//

import SwiftUI

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var twoDaysBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: self)!
    }
}
