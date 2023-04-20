//
//  CGFloat+EXt.swift
//  Converta
//
//  Created by Ernest Dainals on 25/02/2023.
//

import Foundation

extension CGFloat {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}
