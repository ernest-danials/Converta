//
//  SettingsView.swift
//  Converta for Mac
//
//  Created by Ernest Dainals on 20/03/2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 45)
                
                
                
                Spacer(minLength: 20)
            }.alignView(to: .center)
        }
        .overlay(alignment: .top) {
            Text("Settings")
                .customFont(size: 18, weight: .semibold)
                .padding(.top)
                .padding(.bottom, 3.5)
                .alignView(to: .center)
                .background(Material.ultraThin)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(initialView: .Settings)
            .environmentObject(ViewModel())
    }
}
