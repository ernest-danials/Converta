//
//  EditHomeBaseCurrencyView.swift
//  Converta
//
//  Created by Ernest Dainals on 17/02/2023.
//

import SwiftUI

struct EditHomeBaseCurrencyView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var currentEditStatus: EditStatus = .amount
    @State private var currencyViewStyle: CurrencyViewStyle = .Code
    @State private var numberValue: String = ""
    @State private var searchText: String = ""
    @State private var isShowingEditFavoritesView: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            header
            
            if currentEditStatus == .amount {
                amountEditor
            } else {
                currencyEditor
            }
        }
        .onAppear { setUp() }
        .sheet(isPresented: $isShowingEditFavoritesView) { EditFavoritesView(searchTextFieldColor: Color(.systemGray6), showHelpButton: false) }
        .onChange(of: self.numberValue) { newValue in
            withAnimation {
                if newValue.isEmpty {
                    viewModel.updateBaseAmountFromString(string: "1.00")
                } else {
                    viewModel.updateBaseAmountFromString(string: newValue)
                }
            }
        }
        .onChange(of: currencyViewStyle) { _ in
            HapticManager.shared.impact(style: .soft)
        }
    }
    
    func toggleCurrentEditStatus(shouldResetAmount: Bool = false) {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentEditStatus == .amount {
                self.currentEditStatus = .currency
            } else {
                //let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.decimalDigits
                //self.numberValue = String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", viewModel.baseAmount)
                if shouldResetAmount { self.numberValue.removeAll() }
                self.currentEditStatus = .amount
            }
            
            self.searchText.removeAll()
        }
        
        HapticManager.shared.impact(style: .soft)
    }
    
    func setUp() {
        withAnimation {
            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.decimalDigits
            
            if viewModel.baseAmount == 1.00 {
                self.numberValue = ""
            } else {
                self.numberValue = String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", viewModel.baseAmount)
            }
            
            self.currentEditStatus = .amount
            self.currencyViewStyle = .Code
        }
    }
    
    var header: some View {
        VStack {
            Text("Converting From")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Button {
                toggleCurrentEditStatus()
            } label: {
                HStack {
                    let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.decimalDigits
                    
                    Text(countryFlag(countryCode: String(viewModel.baseCurrency?.rawValue.dropLast(1) ?? "US")))
                        .customFont(size: 45)
                    
                    ZStack {
                        Text(numberValue)
                            .customFont(size: 30, weight: .semibold)
                        
                        if numberValue.isEmpty {
                            Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", 1.00))
                                .customFont(size: 30, weight: .semibold)
                                .foregroundColor(.secondary)
                        }
                    }.frame(minWidth: currentCurrencyDecimalDigit == 0 ? 5 : 42, alignment: .trailing)
                    
                    Text(viewModel.baseCurrency?.rawValue ?? "USD")
                        .customFont(size: 30, weight: .semibold)
                    
                    Image(systemName: "chevron.forward")
                        .imageScale(.large)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(currentEditStatus == .amount ? 0 : 90))
                }
            }.scaleButtonStyle(scaleAmount: 0.9, opacityAmount: 1)
        }
    }
    
    var amountEditor: some View {
        VStack {
            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.decimalDigits
            
            if currentCurrencyDecimalDigit != 0 {
                Label("The amount will be rounded to " + "\(currentCurrencyDecimalDigit ?? 2)" + " decimal places.", systemImage: "info.circle")
                    .foregroundColor(.secondary)
                    .font(.footnote)
                    .padding(.horizontal, 3)
            }
            
            NumberKeypad(value: $numberValue, showPeriodButton: currentCurrencyDecimalDigit != 0, size: 24, paddingSize: 15, showDeleteButton: true, showResetButton: false)
            
            Button("Reset") {
                withAnimation {
                    numberValue.removeAll()
                    HapticManager.shared.impact(style: .soft)
                }
            }.fontWeight(.semibold).buttonStyle(.bordered).disabled(numberValue == "")
        }
    }
    
    var currencyEditor: some View {
        VStack(spacing: 0) {
            Text("Show with")
                .font(.footnote)
                .foregroundColor(.secondary)
                .alignView(to: .leading)
                .padding(.horizontal)
            
            Picker("Style", selection: $currencyViewStyle) {
                ForEach(CurrencyViewStyle.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }.pickerStyle(.segmented).padding([.horizontal, .bottom]).padding(.top, 5)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(searchText.isEmpty ? .primary : .brandPurple3)
                    .fontWeight(searchText.isEmpty ? .regular : .semibold)
                
                TextField("Search with currency code", text: $searchText)
                    .submitLabel(.search)
                    .autocorrectionDisabled()
                    .keyboardType(.alphabet)
                
                if !searchText.isEmpty {
                    Button {
                        withAnimation {
                            self.searchText.removeAll()
                            HapticManager.shared.impact(style: .rigid)
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.brandPurple3)
                    }.scaleButtonStyle(scaleAmount: 0.9, opacityAmount: 1)
                }
                
                Button {
                    withAnimation {
                        viewModel.isShowingCurrencyCodeInfo = true
                        HapticManager.shared.impact(style: .soft)
                    }
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.accentColor)
                }.scaleButtonStyle(scaleAmount: 0.9, opacityAmount: 1)
            }
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color(.systemGray5))
            }
            .padding([.horizontal, .bottom])
            
            Divider()
            
            ScrollView {
                VStack(spacing: 10) {
                    if CurrencyCode.allCases.filter({ $0.rawValue.hasPrefix(searchText.uppercased()) }).isEmpty {
                        VStack(spacing: 15) {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            
                            Text("Sorry, we couldn't find what currency you were looking for.")
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Label("You can only search with currency codes.", systemImage: "info.circle")
                                .font(.footnote)
                                .padding(.horizontal)
                        }.foregroundColor(.secondary).padding(.vertical)
                    }
                    
                    if searchText.isEmpty && !viewModel.favoriteCurrencies.isEmpty {
                        HStack {
                            Text("Your Favorite Currencies")
                                .customFont(size: 20, weight: .semibold)

                            Spacer()
                            
                            Button("Edit") {
                                isShowingEditFavoritesView = true
                                HapticManager.shared.impact(style: .soft)
                            }.fontWeight(.semibold).buttonStyle(.bordered)
                        }
                        .alignView(to: .leading)
                        .padding(.horizontal)
                        .padding(.top, 5)
                        
                        ForEach(viewModel.favoriteCurrencies, id: \.self) { rawValue in
                            let currency = viewModel.currentAPIResponse_Currencies?.data[rawValue]
                            let code = CurrencyCode(rawValue: rawValue)
                            
                            Button {
                                withAnimation {
                                    viewModel.updateBaseCurrency(to: code ?? .USDollar)
                                    toggleCurrentEditStatus(shouldResetAmount: true)
                                }
                            } label: {
                                HStack {
                                    Text(countryFlag(countryCode: String(currency?.code.dropLast(1) ?? "US")))
                                        .customFont(size: 35)
                                    
                                    if currencyViewStyle == .Name {
                                        Text(currency?.name ?? "US Dollar")
                                            .customFont(size: 28, weight: .semibold, design: .rounded)
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.3)
                                    } else {
                                        Text(currency?.code ?? "USD")
                                            .customFont(size: 28, weight: .semibold, design: .rounded)
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Spacer()
                                    
                                    if viewModel.baseCurrency == code {
                                        Image(systemName: "checkmark.circle")
                                            .imageScale(.large)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.brandPurple3)
                                    }
                                }.alignView(to: .leading).padding(.horizontal)
                            }.scaleButtonStyle()
                        }
                        
                        Divider().padding(.horizontal)
                    }
                    
                    if searchText.isEmpty && !viewModel.favoriteCurrencies.isEmpty {
                        Text("All Currencies")
                            .customFont(size: 20, weight: .semibold)
                            .alignView(to: .leading)
                            .padding(.horizontal)
                    }
                    
                    ForEach(CurrencyCode.allCases.filter { $0.rawValue.hasPrefix(searchText.uppercased()) }, id: \.self) { code in
                        let currency = viewModel.currentAPIResponse_Currencies?.data[code.rawValue]
                        
                        Button {
                            withAnimation {
                                viewModel.updateBaseCurrency(to: code)
                                numberValue = ""
                                toggleCurrentEditStatus()
                            }
                        } label: {
                            HStack {
                                Text(countryFlag(countryCode: String(currency?.code.dropLast(1) ?? "US")))
                                    .customFont(size: 35)
                                
                                if currencyViewStyle == .Name {
                                    Text(currency?.name ?? "US Dollar")
                                        .customFont(size: 28, weight: .semibold, design: .rounded)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.3)
                                } else {
                                    Text(currency?.code ?? "USD")
                                        .customFont(size: 28, weight: .semibold, design: .rounded)
                                        .foregroundColor(.primary)
                                }
                                
                                Spacer()
                                
                                if viewModel.baseCurrency == code {
                                    Image(systemName: "checkmark.circle")
                                        .imageScale(.large)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.brandPurple3)
                                }
                            }.alignView(to: .leading).padding(.horizontal)
                        }.scaleButtonStyle()
                    }
                }.padding(.vertical, 5)
            }.frame(maxHeight: 400).scrollDismissesKeyboard(.immediately)
            
            Divider()
        }
    }
    
    enum EditStatus { case amount, currency }
    enum CurrencyViewStyle: String, CaseIterable { case Code, Name }
}

struct EditHomeBaseCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        EditHomeBaseCurrencyView()
            .environmentObject(ViewModel())
        
        AppTabView()
            .environmentObject(ViewModel())
    }
}
