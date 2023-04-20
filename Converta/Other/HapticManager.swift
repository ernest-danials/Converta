//
//  HapticManaget.swift
//  Converta
//
//  Created by Ernest Dainals on 15/02/2023.
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    init() {}
    
    #if os(iOS)
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    #endif
}
