//
//  Converta_for_MacApp.swift
//  Converta for Mac
//
//  Created by Ernest Dainals on 19/03/2023.
//

import SwiftUI

@main
struct Converta_for_MacApp: App {
    let viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }.windowStyle(.hiddenTitleBar)
    }
}
