//
//  LibraryCurrencyDetailView.swift
//  Converta
//
//  Created by Ernest Dainals on 09/03/2023.
//

import SwiftUI
import ActivityIndicatorView

struct LibraryCurrencyDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let baseCurrency: CurrencyCode
    let destinationCurrency: CurrencyCode
    
    @EnvironmentObject var viewModel: ViewModel
    @State private var numberValue: String = ""
    @State private var baseAmount: CGFloat = 1.0
    
    @State private var currentAPIResponse_Latest: CurrencyAPIResponse_Latest? = nil
    @State private var isLoading: Bool = false
    
    @State private var hasSeenAd: Bool = false
    
    init(baseCurrency: CurrencyCode, destinationCurrency: CurrencyCode) {
        self.baseCurrency = baseCurrency
        self.destinationCurrency = destinationCurrency
    }
    
    var body: some View {
        VStack {
            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[baseCurrency.rawValue]??.decimalDigits
            
            ScrollView {
                VStack {
                    Spacer()
                    
                    VStack {
                        HStack {
                            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[baseCurrency.rawValue]??.decimalDigits
                            
                            Text(countryFlag(countryCode: String(baseCurrency.rawValue.dropLast(1))))
                                .customFont(size: 45)
                            
                            ZStack {
                                Text(numberValue)
                                    .customFont(size: 40, weight: .semibold)
                                
                                if numberValue.isEmpty {
                                    Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", 1.00))
                                        .customFont(size: 40, weight: .semibold)
                                        .foregroundColor(.secondary)
                                }
                            }.frame(minWidth: currentCurrencyDecimalDigit == 0 ? 5 : 42, alignment: .trailing)
                            
                            Text(baseCurrency.rawValue)
                                .customFont(size: 40, weight: .semibold)
                        }.frame(minWidth: 400)
                        
                        if currentCurrencyDecimalDigit != 0 {
                            Text("The amount was rounded to " + String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", baseAmount))
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .padding(.bottom)
                        }
                    }
                    
                    Image(systemName: "arrow.down.app.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 53, height: 53)
                        .foregroundColor(.accentColor)
                        .padding(.bottom, 5)
                    
                    HStack {
                        let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[destinationCurrency.rawValue]??.decimalDigits
                        let currencyValue = self.currentAPIResponse_Latest?.data[destinationCurrency.rawValue]?.value
                        
                        Text(countryFlag(countryCode: String(destinationCurrency.rawValue.dropLast(1))))
                            .customFont(size: 45)
                        
                        ZStack {
                            if isLoading {
                                ActivityIndicatorView(isVisible: $isLoading, type: .opacityDots(count: 3, inset: 6))
                                    .frame(width: 30, height: 50)
                                    .padding(.horizontal)
                            } else {
                                ZStack {
                                    if !numberValue.isEmpty {
                                        Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", (baseAmount * CGFloat(currencyValue ?? 1.0))))
                                            .customFont(size: 40, weight: .semibold)
                                    } else {
                                        Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", (1.00 * CGFloat(currencyValue ?? 1.0))))
                                            .customFont(size: 40, weight: .semibold)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }.frame(minWidth: currentCurrencyDecimalDigit == 0 ? 5 : 42, alignment: isLoading ? .center : .trailing)
                        
                        Text(destinationCurrency.rawValue)
                            .customFont(size: 40, weight: .semibold)
                    }.frame(minWidth: 400)
                }.padding()
            }
            
            VStack {
                let currencyValue = self.currentAPIResponse_Latest?.data[destinationCurrency.rawValue]?.value
                
                if ((baseAmount * CGFloat(currencyValue ?? 1.0)) < 0.01) {
                    Label("The converted values can appear as zero if the amount before conversion is too small.", systemImage: "info.circle")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
            }
            
            NumberKeypad(value: $numberValue, showPeriodButton: currentCurrencyDecimalDigit != 0, size: 24, paddingSize: 15, showDeleteButton: true, showResetButton: false)
            
            Button("Reset") {
                withAnimation {
                    numberValue.removeAll()
                    HapticManager.shared.impact(style: .soft)
                }
            }.fontWeight(.semibold).buttonStyle(.bordered).disabled(numberValue == "").padding(.bottom)
        }
        .navigationTitle("\(baseCurrency.rawValue)" + " → " + "\(destinationCurrency.rawValue)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { getLatestCurrencyInfos() }
        .onChange(of: self.numberValue) { newValue in
            withAnimation {
                if newValue.isEmpty {
                    updateBaseAmountFromString(string: "1.00")
                } else {
                    updateBaseAmountFromString(string: newValue)
                }
            }
        }
        .overlay {
            if !hasSeenAd {
                VStack(spacing: 30) {
                    Spacer()
                    
                    Text("This ad helps us \nkeep the service free")
                        .customFont(size: 23, weight: .bold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    // Test unitID: ca-app-pub-3940256099942544/2934735716
                    // Real unitID: ca-app-pub-6914406630651088/1511028533
                    BannerAd(unitID: "ca-app-pub-6914406630651088/1511028533")
                        .setBannerType(to: .rectangle).padding(.bottom)
                        .background { ProgressView("Loading") }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring()) { self.hasSeenAd = true }
                        HapticManager.shared.impact(style: .soft)
                    } label: {
                        Text("Continue")
                            .customFont(size: 20, weight: .semibold)
                            .foregroundColor(.white)
                            .padding()
                            .alignView(to: .center)
                            .background(Color.brandPurple3.gradient)
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .padding(.horizontal)
                    }.scaleButtonStyle().padding(.bottom)
                }.alignView(to: .center).alignViewVertically(to: .center).background(Material.ultraThin)
            }
        }
    }
    
    func updateBaseAmountFromString(string: String) {
        withAnimation {
            let formatter = NumberFormatter()
            
            let number = formatter.number(from: string)
            
            let result = number as? CGFloat ?? 1.00
            
            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[baseCurrency.rawValue]??.decimalDigits
            
            self.baseAmount = result.rounded(toPlaces: currentCurrencyDecimalDigit ?? 2)
        }
    }
    
    private func getLatestCurrencyInfos() {
        if viewModel.hasErrorOccured {
            withAnimation {
                viewModel.hasErrorOccured = false
                viewModel.currentError.removeAll()
            }
        }
        
        withAnimation { self.isLoading = true }
        CurrencyAPIManager.shared.getLatestCurrencyData(baseCurrency: self.baseCurrency) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    withAnimation {
                        self.currentAPIResponse_Latest = response
                        self.isLoading = false
                    }
                case .failure(let error):
                    withAnimation {
                        self.isLoading = false
                        viewModel.currentError = error.localizedDescription
                        viewModel.hasErrorOccured = true
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct LibraryCurrencyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LibraryCurrencyDetailView(baseCurrency: .SouthKoreanWon, destinationCurrency: .BritishPoundSterling)
                .environmentObject(ViewModel())
        }
    }
}
