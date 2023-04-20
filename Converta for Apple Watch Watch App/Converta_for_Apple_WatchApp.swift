//
//  Converta_for_Apple_WatchApp.swift
//  Converta for Apple Watch Watch App
//
//  Created by Ernest Dainals on 26/03/2023.
//

import SwiftUI

@main
struct Converta_for_Apple_Watch_Watch_AppApp: App {
    let viewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(viewModel)
        }
    }
}
