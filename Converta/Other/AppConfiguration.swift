//
//  AppConfiguration.swift
//  Converta
//
//  Created by Ernest Dainals on 19/06/2023.
//

import SwiftUI

enum AppConfiguration: String {
    case Debug = "Debug"
    case TestFlight = "TestFlight"
    case AppStore = "App Store"
}

struct AppConfig {
    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    
    static var isDebug: Bool {
    #if DEBUG
        return true
    #else
        return false
    #endif
    }
    
    static var appConfiguration: AppConfiguration {
        if isDebug {
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }
}
