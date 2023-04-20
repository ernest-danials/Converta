//
//  HomeView.swift
//  Converta for Mac
//
//  Created by Ernest Dainals on 19/03/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 45)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("Converting From")
                            .customFont(size: 20, weight: .bold)
                        
                        HStack {
                            Text(countryFlag(countryCode: String(viewModel.baseCurrency?.rawValue.dropLast() ?? "US")))
                                .customFont(size: 40)
                            
                            
                        }
                    }
                }
                
                Spacer(minLength: 20)
            }.alignView(to: .center)
        }
        .overlay(alignment: .top) {
            Text("Home")
                .customFont(size: 18, weight: .semibold)
                .padding(.top)
                .padding(.bottom, 3.5)
                .alignView(to: .center)
                .background(Material.ultraThin)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(initialView: .Home)
            .environmentObject(ViewModel())
    }
}
