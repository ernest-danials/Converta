//
//  CurrencyCard.swift
//  Converta
//
//  Created by Ernest Dainals on 05/03/2023.
//

import SwiftUI

struct CurrencyCard: View {
    @EnvironmentObject var viewModel: ViewModel
    let code: String
    let destinationCurrencyName: String
    let destinationCurrencyDecimalDigit: Int
    let currencyValue: Float
    let showFavoriteButton: Bool
    let minHeight: CGFloat
    
    init(code: String, destinationCurrencyName: String, destinationCurrencyDecimalDigit: Int, currencyValue: Float, showFavoriteButton: Bool = true, minHeight: CGFloat = 120) {
        self.code = code
        self.destinationCurrencyName = destinationCurrencyName
        self.destinationCurrencyDecimalDigit = destinationCurrencyDecimalDigit
        self.currencyValue = currencyValue
        self.showFavoriteButton = showFavoriteButton
        self.minHeight = minHeight
    }
    
    var body: some View {
        VStack {
            Text(countryFlag(countryCode: String(code.dropLast())))
                .customFont(size: 55)
            
            Text(destinationCurrencyName)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
            
            HStack(spacing: 3) {
                Text(String(format: "%.\(destinationCurrencyDecimalDigit)f", (viewModel.baseAmount * CGFloat(currencyValue))) + " " + code)
                    .customFont(size: 25, weight: .semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
            }
        }
        .alignView(to: .center)
        .frame(minHeight: minHeight)
        .padding()
        .background(Material.ultraThin)
        .cornerRadius(15)
        .overlay(alignment: .topTrailing) {
            if showFavoriteButton {
                Button {
                    withAnimation {
                        if viewModel.favoriteCurrencies.contains(code) {
                            viewModel.favoriteCurrencies = viewModel.favoriteCurrencies.compactMap { item in
                                if item == code {
                                    return nil
                                } else {
                                    return item
                                }
                            }
                            
                            HapticManager.shared.impact(style: .rigid)
                        } else {
                            viewModel.favoriteCurrencies.append(code)
                            HapticManager.shared.impact(style: .soft)
                        }
                    }
                } label: {
                    Image(systemName: "star")
                        .symbolVariant(viewModel.favoriteCurrencies.contains(code) ? .fill : .none)
                }.foregroundColor(.accentColor).scaleButtonStyle(scaleAmount: 0.9, opacityAmount: 1.0).padding(10)
            }
        }
    }
}

struct CurrencyCard_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyCard(code: "USD", destinationCurrencyName: "US Dollar", destinationCurrencyDecimalDigit: 2, currencyValue: 1.0)
            .environmentObject(ViewModel())
            .padding()
    }
}
