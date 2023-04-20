//
//  LibraryView.swift
//  Converta for Mac
//
//  Created by Ernest Dainals on 20/03/2023.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 45)
                
                
                
                Spacer(minLength: 20)
            }.alignView(to: .center)
        }
        .overlay(alignment: .top) {
            Text("Library")
                .customFont(size: 18, weight: .semibold)
                .padding(.top)
                .padding(.bottom, 3.5)
                .alignView(to: .center)
                .background(Material.ultraThin)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(initialView: .Library)
            .environmentObject(ViewModel())
    }
}
