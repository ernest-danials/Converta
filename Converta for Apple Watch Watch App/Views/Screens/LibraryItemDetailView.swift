//
//  LibraryItemDetailView.swift
//  Converta for Apple Watch Watch App
//
//  Created by Ernest Dainals on 28/03/2023.
//

import SwiftUI

struct LibraryItemDetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    let baseCurrencyCode: CurrencyCode
    let destinationCurrencyCode: CurrencyCode
    
    @State private var APIResponse: CurrencyAPIResponse_Latest? = nil
    
    @State private var numberValue: String = ""
    @State private var baseAmount: CGFloat = 1.0
    var body: some View {
        ScrollView {
            Spacer(minLength: 35)
            
            NumberKeypad(value: $numberValue, showPeriodButton: false, size: 20, paddingSize: 3, showDeleteButton: true, showResetButton: true)
            
            NavigationLink {
                convertedView
            } label: {
                Label("Convert", systemImage: "arrow.right.square.fill")
                    .customFont(size: 15, weight: .medium)
                    .foregroundColor(.accentColor)
            }.buttonBorderShape(.capsule).padding(.top)
        }
        .navigationTitle("Convert From")
        .navigationBarTitleDisplayMode(.inline)
        .task { getCurrencyInformations() }
        .onChange(of: numberValue) { _ in
            updateBaseAmount()
        }
        .overlay(alignment: .top) {
            HStack {
                HStack(spacing: 5) {
                    Text(countryFlag(countryCode: String(baseCurrencyCode.rawValue.dropLast())))
                        .customFont(size: 20)
                    
                    if numberValue.isEmpty {
                        Text("1")
                            .customFont(size: 20, weight: .semibold)
                            .foregroundColor(.secondary)
                    } else {
                        Text(numberValue)
                            .customFont(size: 20, weight: .semibold)
                    }
                    
                    Text(baseCurrencyCode.rawValue)
                        .customFont(size: 20, weight: .semibold)
                        .lineLimit(1)
                }.minimumScaleFactor(0.4)
            }.frame(maxHeight: 30).alignView(to: .leading).padding(.horizontal).background()
        }
    }
    
    func updateBaseAmount() {
        withAnimation {
            let formatter = NumberFormatter()
            
            let number = formatter.number(from: numberValue)
            
            let result = number as? CGFloat ?? 1.00
            
            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[self.baseCurrencyCode.rawValue]?.decimalDigits
            print("\(result.rounded(toPlaces: currentCurrencyDecimalDigit ?? 2))")
            
            self.baseAmount = result.rounded(toPlaces: currentCurrencyDecimalDigit ?? 2)
        }
    }
    
    func getCurrencyInformations() {
        CurrencyAPIManager.shared.getLatestCurrencyData(baseCurrency: self.baseCurrencyCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    withAnimation { self.APIResponse = response }
                case .failure(let error):
                    withAnimation {
                        #if os(iOS)
                        HapticManager.shared.notification(type: .error)
                        #endif
                        self.viewModel.currentError = error.localizedDescription
                        self.viewModel.hasErrorOccured = true
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    var convertedView: some View {
        ScrollView {
            let destinationCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[destinationCurrencyCode.rawValue]?.decimalDigits
            let currencyValue = (APIResponse?.data[destinationCurrencyCode.rawValue]?.value ?? 1.00)
            
            Text("Converted To")
                .customFont(size: 15, weight: .medium)
            
            HStack(spacing: 5) {
                Text(countryFlag(countryCode: String(destinationCurrencyCode.rawValue.dropLast())))
                    .customFont(size: 23)
                
                if numberValue.isEmpty {
                    Text(String(format: "%.\(destinationCurrencyDecimalDigit ?? 2)f", (1 * CGFloat(currencyValue))))
                        .customFont(size: 23, weight: .semibold)
                } else {
                    Text(String(format: "%.\(destinationCurrencyDecimalDigit ?? 2)f", (self.baseAmount * CGFloat(currencyValue))))
                        .customFont(size: 23, weight: .semibold)
                }
                
                Text(destinationCurrencyCode.rawValue)
                    .customFont(size: 23, weight: .semibold)
                    .lineLimit(1)
            }.minimumScaleFactor(0.4)
            
            VStack(alignment: .leading, spacing: 5) {
                Label("Conversion Rate: \(currencyValue)", systemImage: "info.circle")
                    .customFont(size: 8)
                    .foregroundColor(.secondary)
                
                if (self.baseAmount * CGFloat(currencyValue)).rounded(toPlaces: destinationCurrencyDecimalDigit ?? 2) < 0.01 {
                    Label("The converted values can appear as zero if the amount before conversion is too small.", systemImage: "info.circle")
                        .customFont(size: 8)
                        .foregroundColor(.secondary)
                }
            }.padding(.top)
        }.navigationBarTitleDisplayMode(.inline)
    }
}

struct LibraryItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LibraryItemDetailView(baseCurrencyCode: .USDollar, destinationCurrencyCode: .SouthKoreanWon)
                .environmentObject(ViewModel())
        }
    }
}
