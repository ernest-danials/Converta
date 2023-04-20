//
//  HomeInfoView.swift
//  Converta
//
//  Created by Ernest Dainals on 05/03/2023.
//

import SwiftUI

struct HomeInfoView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 80)
            
            Text("Welcome to Converta.")
                .customFont(size: 20, weight: .semibold)
                .padding(.top)
            
            Text("These currency informations were updated at \(viewModel.currentAPIResponse_Latest?.meta.lastUpdatedAt.homeInfoDisplay ?? Date.now.homeInfoDisplay)")
                .multilineTextAlignment(.center)
        }.padding(.horizontal)
    }
}

extension Date {
    var homeInfoDisplay: String {
        self.formatted(
            .dateTime
                .year(.defaultDigits)
                .month(.wide)
                .day(.defaultDigits)
                .hour(.conversationalDefaultDigits(amPM: .abbreviated))
                .minute(.defaultDigits)
        )
    }
}

struct HomeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        HomeInfoView()
            .environmentObject(ViewModel())
    }
}
