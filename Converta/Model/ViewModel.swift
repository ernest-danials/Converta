//
//  ViewModel.swift
//  Converta
//
//  Created by Ernest Dainals on 15/02/2023.
//

import SwiftUI

final class ViewModel: ObservableObject {
    @Published var baseCurrency: CurrencyCode? = nil
    @Published var baseAmount: CGFloat = 1.00
    @AppStorage("savedBaseCurrencyCode") var savedBaseCurrency: CurrencyCode.RawValue = ""
    
    @AppStorage("favorites") @Storage var favoriteCurrencies: [CurrencyCode.RawValue] = []
    
    @AppStorage("colorScheme") var colorScheme: String = AppearanceMode.device.rawValue
    @AppStorage("appIcon") var appIcon: String = AppIcon.icon.rawValue
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @Published var isShowingOnboarding: Bool = false
    
    @Published var currentAPIResponse_Latest: CurrencyAPIResponse_Latest? = nil
    @Published var currentAPIResponse_Currencies: CurrencyAPIResponse_Currencies? = nil
    
    @Published var hasErrorOccured: Bool = false
    @Published var currentError: String = ""
    
    @Published var isShowingHomeEditBaseCurrencyView: Bool = false
    @Published var isShowingHomeInfoView: Bool = false
    
    @Published var isShowingEditHistoricalRateBaseCurrencyView: Bool = false
    @Published var isShowingEditCryptoBaseCurrencyView: Bool = false
    
    @Published var isShowingHomeAmountZeroLabel: Bool = false
    @Published var isShowingHistoricalViewAmountZeroLabel: Bool = false
    
    @Published var isShowingCurrencyDetailView: Bool = false
    @Published var selectedCurrencyForDetail: CurrencyCode? = nil
    
    @Published var isShowingCurrencyDetailViewOnHistorical: Bool = false
    @Published var selectedCurrencyForDetailOnHistorical: CurrencyCode? = nil
    
    #if os(macOS)
    @Published var selectedView: TabViewItems = .Home
    
    func changeSelectedView(to view: TabViewItems) {
        withAnimation(.spring()) {
            self.selectedView = view
        }
    }
    #endif
    
    func updateGemCount(to newValue : Double) {
        let store = NSUbiquitousKeyValueStore()
        
        store.set(newValue, forKey: "gems")
        store.synchronize()
    }
    
    func getLatestCurrencyInfos() {
        if hasErrorOccured {
            withAnimation {
                hasErrorOccured = false
                currentError.removeAll()
            }
        }
        
        CurrencyAPIManager.shared.getLatestCurrencyData(baseCurrency: self.baseCurrency ?? .USDollar) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    withAnimation { self.currentAPIResponse_Latest = response }
                case .failure(let error):
                    withAnimation {
                        #if os(iOS)
                        HapticManager.shared.notification(type: .error)
                        #endif
                        self.currentError = error.localizedDescription
                        self.hasErrorOccured = true
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getAvailableCurrencies() {
        if hasErrorOccured {
            withAnimation {
                hasErrorOccured = false
                currentError.removeAll()
            }
        }
        
        CurrencyAPIManager.shared.getAvailableCurrencies { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    withAnimation { self.currentAPIResponse_Currencies = response }
                case .failure(let error):
                    withAnimation {
                        #if os(iOS)
                        HapticManager.shared.notification(type: .error)
                        #endif
                        self.currentError = error.localizedDescription
                        self.hasErrorOccured = true
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    #if os(iOS)
    func initiateFunctions(getData: Bool = true) {
        withAnimation {
            if savedBaseCurrency.isEmpty {
                self.baseCurrency = .USDollar
            } else {
                self.baseCurrency = .init(rawValue: savedBaseCurrency)
            }
            
            updateBaseAmountFromString(string: "1.00")
        }
        
        if getData {
            if currentAPIResponse_Latest == nil {
                getLatestCurrencyInfos()
            }
            
            if currentAPIResponse_Currencies == nil {
                getAvailableCurrencies()
            }
        }
    }
    #endif
    
    #if os(watchOS)
    func initiateFuctionsForWatchOS() {
        withAnimation {
            hasErrorOccured = false
            currentError.removeAll()
            
            if currentAPIResponse_Currencies == nil {
                getAvailableCurrencies()
            }
        }
    }
    #endif
    
    func updateBaseCurrency(to currency: CurrencyCode) {
        withAnimation {
            self.baseCurrency = currency
            self.savedBaseCurrency = currency.rawValue
            getLatestCurrencyInfos()
        }
    }
    
    func updateBaseAmountFromString(string: String) {
        withAnimation {
            let formatter = NumberFormatter()
            
            let number = formatter.number(from: string)
            
            let result = number as? CGFloat ?? 1.00
            
            let currentCurrencyDecimalDigit = self.currentAPIResponse_Currencies?.data[self.baseCurrency?.rawValue ?? "USD"]??.decimalDigits
            
            self.baseAmount = result.rounded(toPlaces: currentCurrencyDecimalDigit ?? 2)
        }
    }
    
    func showCurrencyDetail(currency: CurrencyCode) {
        withAnimation {
            self.selectedCurrencyForDetail = currency
            self.isShowingCurrencyDetailView = true
            #if os(iOS)
            HapticManager.shared.impact(style: .soft)
            #endif
        }
    }
    
    func hideCurrencyDetail() {
        withAnimation {
            self.isShowingCurrencyDetailView = false
            self.selectedCurrencyForDetail = nil
            #if os(iOS)
            HapticManager.shared.impact(style: .soft)
            #endif
        }
    }
    
    func showCurrencyDetailOnHistorical(currency: CurrencyCode) {
        withAnimation {
            self.selectedCurrencyForDetailOnHistorical = currency
            self.isShowingCurrencyDetailViewOnHistorical = true
            #if os(iOS)
            HapticManager.shared.impact(style: .soft)
            #endif
        }
    }
    
    func hideCurrencyDetailOnHistorical() {
        withAnimation {
            self.isShowingCurrencyDetailViewOnHistorical = false
            self.selectedCurrencyForDetailOnHistorical = nil
            #if os(iOS)
            HapticManager.shared.impact(style: .soft)
            #endif
        }
    }
    
    func changeColorScheme(to colorScheme: AppearanceMode) {
        withAnimation {
            self.colorScheme = colorScheme.rawValue
        }
    }
    
    func isLoading() -> Bool {
        withAnimation {
            if !self.hasErrorOccured && (self.currentAPIResponse_Latest == nil && self.currentAPIResponse_Currencies == nil) {
                return true
            } else {
                return false
            }
        }
    }
    
    let appVersionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let appBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
}

extension CGFloat {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
