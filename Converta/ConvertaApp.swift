//
//  ConvertaApp.swift
//  Converta
//
//  Created by Ernest Dainals on 15/02/2023.
//

import SwiftUI

@main
struct ConvertaApp: App {
    let viewModel: ViewModel = .init()
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(viewModel)
        }
    }
}
