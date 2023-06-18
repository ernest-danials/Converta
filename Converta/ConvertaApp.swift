//
//  ConvertaApp.swift
//  Converta
//
//  Created by Ernest Dainals on 15/02/2023.
//

import SwiftUI
import GoogleMobileAds

@main
struct ConvertaApp: App {
    let viewModel: ViewModel = .init()
    
    init() { GADMobileAds.sharedInstance().start(completionHandler: nil) }
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(viewModel)
        }
    }
}
