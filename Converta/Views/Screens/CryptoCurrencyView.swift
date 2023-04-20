//
//  CryptoCurrencyView.swift
//  Converta
//
//  Created by Ernest Dainals on 10/04/2023.
//

import SwiftUI

struct CryptoCurrencyView: View {
    @EnvironmentObject var viewModel: ViewModel
    let subViewModel: CryptoCurrencyViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                convertingFromView
                
                if subViewModel.isLoading || subViewModel.currentAPIResponse == nil {
                    VStack(spacing: 5) {
                        Divider().padding([.horizontal, .bottom])
                        
                        ProgressView().foregroundColor(.secondary)
                        
                        Text("Loading")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                } else {
                    VStack {
                        Divider().padding(.horizontal)
                        
                        Text("Converted To")
                            .customFont(size: 23, weight: .bold)
                            .alignView(to: .leading)
                            .padding(.horizontal)
                        
                        LazyVStack {
                            ForEach(CryptoCurrency.allCases, id: \.self) { currency in
                                let cryptoCurrencyName = viewModel.currentAPIResponse_Currencies?.data[currency.rawValue]?.name
                                let currencyValue = (subViewModel.currentAPIResponse?.data[currency.rawValue]?.value ?? 1.00)
                                let destinationCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[currency.rawValue]?.decimalDigits
                                
                                VStack {
                                    HStack(spacing: 10) {
                                        currency.getImage()
                                        
                                        Text(cryptoCurrencyName ?? "")
                                            .customFont(size: 20, weight: .semibold)
                                        
                                        Spacer()
                                        
                                        Link(destination: currency.getLink()) {
                                            Image(systemName: "link")
                                        }
                                    }
                                    
                                    HStack {
                                        Text(String(format: "%.\(destinationCurrencyDecimalDigit ?? 5)f", (subViewModel.baseAmount * CGFloat(currencyValue))) + " " + currency.rawValue)
                                            .customFont(size: 25, weight: .semibold)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.4)
                                        
                                        Spacer()
                                    }
                                }
                                .padding().background(Material.ultraThin).cornerRadius(15)
                            }
                        }.padding([.horizontal, .bottom])
                        
                        Label("The converted values can appear as zero if the amount before conversion is too small or the base currency does not have crypto currency data.", systemImage: "info.circle")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .alignView(to: .leading)
                            .padding()
                            .background(Material.ultraThin)
                            .cornerRadius(15)
                            .padding([.bottom, .horizontal])
                    }
                }
            }.navigationTitle("Crypto Currency")
        }
        .onChange(of: subViewModel.hasErrorOccured) { newValue in
            withAnimation {
                viewModel.hasErrorOccured = newValue
                viewModel.currentError = "An error has occured while getting Crypto Currency data."
            }
        }
    }
    
    var convertingFromView: some View {
        VStack(alignment: .leading) {
            Text("Converting From")
                .customFont(size: 23, weight: .bold)
                .alignView(to: .leading)
            
            Button {
                withAnimation { viewModel.isShowingEditCryptoBaseCurrencyView = true }
                HapticManager.shared.impact(style: .soft)
            } label: {
                HStack {
                    Text(countryFlag(countryCode: String(subViewModel.baseCurrency.rawValue.dropLast(1))))
                        .customFont(size: 50, weight: .bold, design: .rounded)
                    
                    HStack(spacing: 5) {
                        let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[subViewModel.baseCurrency.rawValue]?.decimalDigits
                        
                        Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", subViewModel.baseAmount))
                            .customFont(size: 23, weight: .bold, design: .rounded)
                        
                        Text(viewModel.currentAPIResponse_Currencies?.data[subViewModel.baseCurrency.rawValue]?.code ?? "")
                            .customFont(size: 23, weight: .bold, design: .rounded)
                    }.foregroundColor(.primary)
                }
                .alignView(to: .leading)
                .padding()
                .background(Material.ultraThin)
                .cornerRadius(15)
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "pencil")
                        .imageScale(.small)
                        .foregroundColor(.brandWhite)
                        .padding(5)
                        .background { Circle().foregroundColor(.accentColor) }
                        .padding(7)
                }
            }.scaleButtonStyle(scaleAmount: 0.97, opacityAmount: 1)
        }.padding([.horizontal, .bottom])
    }
}

struct CryptoCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoCurrencyView(subViewModel: .init()).environmentObject(ViewModel())
    }
}

final class CryptoCurrencyViewModel: ObservableObject {
    @Published var currentAPIResponse: CurrencyAPIResponse_Latest? = nil
    
    @Published var baseCurrency: CurrencyCode = .USDollar
    @Published var baseAmount: CGFloat = 1.00
    
    @Published var isLoading: Bool = false
    @Published var hasErrorOccured: Bool = false
    
    func getCryptoCurrencyData() {
        if hasErrorOccured {
            withAnimation {
                hasErrorOccured = false
            }
        }
        
        withAnimation { isLoading = true }
        CurrencyAPIManager.shared.getLatestCurrencyData(baseCurrency: baseCurrency, currencies: CryptoCurrency.getFullListForAPI()) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let response):
                    withAnimation { self.currentAPIResponse = response }
                    withAnimation { isLoading = false }
                case .failure(let error):
                    withAnimation { isLoading = false }
                    withAnimation {
                        HapticManager.shared.notification(type: .error)
                        self.hasErrorOccured = true
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateBaseAmountFromString(string: String, viewModel: ViewModel) {
        withAnimation {
            let formatter = NumberFormatter()
            
            let number = formatter.number(from: string)
            
            let result = number as? CGFloat ?? 1.00
            
            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[self.baseCurrency.rawValue]?.decimalDigits
            
            self.baseAmount = result.rounded(toPlaces: currentCurrencyDecimalDigit ?? 2)
        }
    }
    
    func updateBaseCurrency(to currency: CurrencyCode) {
        withAnimation {
            self.baseCurrency = currency
            getCryptoCurrencyData()
        }
    }
}

enum CryptoCurrency: String, CaseIterable {
    case Bitcoin = "BTC"
    case Ethereum = "ETH"
    case Binance = "BNB"
    case Polkadot = "DOT"
    case Avalanche = "AVAX"
    case Litecoin = "LTC"
    
    func getImage() -> some View {
        ZStack {
            switch self {
            case .Bitcoin:
                return Image("BTC").resizable().scaledToFit()
            case .Ethereum:
                return Image("ETH").resizable().scaledToFit()
            case .Binance:
                return Image("BNB").resizable().scaledToFit()
            case .Polkadot:
                return Image("DOT").resizable().scaledToFit()
            case .Avalanche:
                return Image("AVAX").resizable().scaledToFit()
            case .Litecoin:
                return Image("LTC").resizable().scaledToFit()
            }
        }.frame(width: 35, height: 35)
    }
    
    func getLink() -> URL {
        switch self {
        case .Bitcoin:
            return URL(string: "https://bitcoin.org")!
        case .Ethereum:
            return URL(string: "https://ethereum.org")!
        case .Binance:
            return URL(string: "https://www.binance.com")!
        case .Polkadot:
            return URL(string: "https://polkadot.network")!
        case .Avalanche:
            return URL(string: "https://www.avax.com")!
        case .Litecoin:
            return URL(string: "https://litecoin.org")!
        }
    }
    
    static func getFullListForAPI() -> String { return "BTC,ETH,BNB,DOT,AVAX,LTC" }
}
