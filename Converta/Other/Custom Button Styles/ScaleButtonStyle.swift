//
//  scaleButtonStyle.swift
//  Converta
//
//  Created by Ernest Dainals on 15/02/2023.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    let scaleAmount: CGFloat
    let opacityAmount: Double
    
    init(scaleAmount: CGFloat, opacityAmount: Double) {
        self.scaleAmount = scaleAmount
        self.opacityAmount = opacityAmount
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
            .opacity(configuration.isPressed ? opacityAmount : 1.0)
    }
}

extension View {
    func scaleButtonStyle(scaleAmount: CGFloat = 0.98, opacityAmount: Double = 1.0) -> some View {
        self.buttonStyle(ScaleButtonStyle(scaleAmount: scaleAmount, opacityAmount: opacityAmount))
    }
}
