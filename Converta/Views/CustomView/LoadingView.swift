//
//  LoadingView.swift
//  Converta
//
//  Created by Ernest Dainals on 16/02/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image("Logo")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 80)
                .padding()
            
            HStack(spacing: 10) {
                ProgressView().foregroundColor(.secondary)
                
                Text("Getting Currency Informations")
                    .fontWeight(.semibold)
            }.opacity(0.6)
        }.alignView(to: .center).alignViewVertically(to: .center).padding().background(Material.thick)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .background {
                AppTabView()
                    .environmentObject(ViewModel())
            }
    }
}
