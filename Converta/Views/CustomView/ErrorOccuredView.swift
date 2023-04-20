//
//  ErrorOccuredView.swift
//  Converta
//
//  Created by Ernest Dainals on 16/02/2023.
//

import SwiftUI

struct ErrorOccuredView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.brandWhite)
            
            Text("Error")
                .customFont(size: 35, weight: .heavy, design: .rounded)
                .foregroundColor(.brandWhite)
            
            Text("Sorry, an error has occured\nwhile loading the currency data.")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text("Error: " + (viewModel.currentError.isEmpty ? "Warning - the error is nil." : viewModel.currentError))
                .customFont(size: 15)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            VStack {
                HStack(spacing: 14) {
                    Image(systemName: "wifi.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    Text("Please make sure you're currently connected to the Internet.")
                        .customFont(size: 15, weight: .medium)
                        .minimumScaleFactor(0.3)
                }.foregroundColor(.secondary).alignView(to: .leading).padding().background(Material.ultraThin).cornerRadius(15).padding(.horizontal, 5)
                
                HStack(spacing: 14) {
                    Image(systemName: "bolt.horizontal.icloud.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    Text("This error may be caused by our data provider's internal server error.")
                        .customFont(size: 15, weight: .medium)
                        .minimumScaleFactor(0.3)
                }.foregroundColor(.secondary).alignView(to: .leading).padding().background(Material.ultraThin).cornerRadius(15).padding(.horizontal, 5)
                
//                HStack(spacing: 14) {
//                    Image(systemName: "exclamationmark.bubble.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30, height: 30)
//
//                    VStack(alignment: .leading) {
//                        Text("Please report this error to us using the button below. It can help us to make Converta even better. Thank you!")
//                            .customFont(size: 15, weight: .medium)
//                            .minimumScaleFactor(0.3)
//                    }
//                }.foregroundColor(.secondary).alignView(to: .leading).padding().background(Material.ultraThin).cornerRadius(15).padding(.horizontal, 5)
                
//                HStack(spacing: 14) {
//                    Image(systemName: "envelope.badge.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 30, height: 30)
//
//                    Text("If you're currently offline, there's a chance that your report couldn't be sent via email. If so, please check the Mail app's \"Outbox\" and send the report from there after getting back online.")
//                        .customFont(size: 15, weight: .medium)
//                        .minimumScaleFactor(0.3)
//                }.foregroundColor(.secondary).alignView(to: .leading).padding().background(Material.ultraThin).cornerRadius(15).padding(.horizontal, 5)
            }.padding(.bottom)
            
            HStack {
                Button {
                    withAnimation {
                        viewModel.hasErrorOccured = false
                        viewModel.currentError.removeAll()
                        viewModel.initiateFunctions()
                        HapticManager.shared.impact(style: .soft)
                    }
                } label: {
                    Label("Try Again", systemImage: "arrow.clockwise")
                        .fontWeight(.semibold)
                        .foregroundColor(.brandWhite)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.brandPurple3)
                        }
                }.scaleButtonStyle()
            }.padding(.bottom)
        }
        .alignView(to: .center).alignViewVertically(to: .center).background(Color.brandPurple4).transition(.opacity)
    }
}

struct ErrorOccuredView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorOccuredView()
            .environmentObject(ViewModel())
    }
}
