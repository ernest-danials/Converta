//
//  CurrencyCodesView.swift
//  Converta
//
//  Created by Ernest Dainals on 28/05/2023.
//

import SwiftUI

struct CurrencyCodesView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var copiedCode: CurrencyCode? = nil
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.currentAPIResponse_Currencies != nil {
                    LazyVStack {
                        ForEach(CurrencyCode.allCases, id: \.self) { code in
                            let currency = viewModel.currentAPIResponse_Currencies?.data[code.rawValue]
                            
                            HStack(spacing: 15) {
                                Text(countryFlag(countryCode: String(describing: code.rawValue.dropLast())))
                                    .customFont(size: 60)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(currency??.name ?? "Loading...")
                                        .customFont(size: 20, weight: .medium)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.4)
                                    
                                    HStack {
                                        Image(systemName: "arrow.uturn.down")
                                            .imageScale(.large)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.secondary)
                                            .rotationEffect(.degrees(270))
                                        
                                        Text(currency??.code ?? "Loading")
                                            .customFont(size: 30, weight: .semibold)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                    }
                                }
                                
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        UIPasteboard.general.string = code.rawValue
                                        self.copiedCode = code
                                        HapticManager.shared.impact(style: .soft)
                                    }
                                } label: {
                                    VStack(spacing: 5) {
                                        Image(systemName: self.copiedCode == code ? "checkmark.circle.fill" : "doc.on.doc.fill")
                                            .imageScale(.large)
                                            .foregroundColor(self.copiedCode == code ? .green : .brandPurple3)
                                        
                                        Text(self.copiedCode == code ? "Copied" : "Copy")
                                            .customFont(size: 14, weight: .medium)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.4)
                                            .transition(.opacity)
                                    }
                                }.scaleButtonStyle()
                            }.alignView(to: .leading).padding().background(Material.ultraThin).cornerRadius(15).padding(.horizontal)
                        }
                    }
                } else {
                    VStack(spacing: 10) {
                        ProgressView()
                        
                        Text("Loading")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }.padding(.vertical)
                }
            }.navigationTitle("Currency Codes")
        }
    }
}

struct CurrencyCodesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { CurrencyCodesView().environmentObject(ViewModel()) }
    }
}
