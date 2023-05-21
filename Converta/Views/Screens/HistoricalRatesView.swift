//
//  HistoricalRatesView.swift
//  Converta
//
//  Created by Ernest Dainals on 09/04/2023.
//

import SwiftUI

struct HistoricalRatesView: View {
    @EnvironmentObject var viewModel: ViewModel
    let subViewModel: HistoricalRatesViewModel
    @State private var isShowingEditFavoritesView: Bool = false
    @State private var searchText: String = ""
    @State private var date: Date = .init().twoDaysBefore
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .fontWeight(.semibold)
                        
                        Text("Use Data from...")
                            .customFont(size: 20, weight: .semibold)
                        
                        Spacer()
                    }
                    
                    var minimumDate: Date {
                        var components = DateComponents()
                        components.year = 1999
                        components.month = 1
                        components.day = 1
                        let date = Calendar.current.date(from: components) ?? .now
                        
                        return date
                    }
                    
                    DatePicker("Date", selection: $date, in: minimumDate...Date().twoDaysBefore, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
                .alignView(to: .leading)
                .padding()
                .background(Material.ultraThin)
                .cornerRadius(15)
                .padding(.horizontal)
                
                Label("The converted values can appear as 1.0 if our data provider doesn't have currency data of the base currency from \(date.formatted(date: .long, time: .omitted)).", systemImage: "info.circle")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .alignView(to: .leading)
                    .padding()
                    .background(Material.ultraThin)
                    .cornerRadius(15)
                    .padding([.bottom, .horizontal])
                
                convertingFromView
                
                if subViewModel.isLoading {
                    VStack(spacing: 5) {
                        Divider().padding([.horizontal, .bottom])
                        
                        ProgressView().foregroundColor(.secondary)
                        
                        Text("Loading")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                } else {
                    if subViewModel.currentAPIResponse != nil {
                        favoritesView
                        
                        allCurrenciesView.padding(.bottom)
                    } else {
                        Divider().padding([.horizontal, .bottom])
                        
                        VStack(spacing: 30) {
                            Text("Update with data from \(date.formatted(date: .long, time: .omitted))")
                                .customFont(size: 22, weight: .bold)
                                .multilineTextAlignment(.center)
                            
                            Button {
                                subViewModel.getHistoricalRate(date: date)
                                HapticManager.shared.impact(style: .soft)
                            } label: {
                                Text("Update Now")
                                    .customFont(size: 20, weight: .semibold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.brandPurple3))
                            }.scaleButtonStyle()
                        }.alignView(to: .center).padding().padding(.vertical).background(Material.ultraThin).cornerRadius(15).padding([.horizontal, .bottom])
                    }
                }
                
                if viewModel.isShowingHistoricalViewAmountZeroLabel { Spacer(minLength: 90) }
            }
            .navigationTitle("Historical")
        }
        .sheet(isPresented: $isShowingEditFavoritesView) { EditFavoritesView(searchTextFieldColor: Color(.systemGray6), showHelpButton: false) }
        .task { if subViewModel.currentAPIResponse == nil { subViewModel.getHistoricalRate(date: date) } }
        .onChange(of: self.date) { newValue in
            if !viewModel.isShowingEditHistoricalRateBaseCurrencyView {
                HapticManager.shared.impact(style: .soft)
                withAnimation { subViewModel.currentAPIResponse = nil }
            }
        }
        .onChange(of: subViewModel.hasErrorOccured) { newValue in
            withAnimation {
                viewModel.hasErrorOccured = newValue
                viewModel.currentError = "An error has occured while getting historical data."
            }
        }
    }
    
    var convertingFromView: some View {
        VStack(alignment: .leading) {
            Divider()
            
            Text("Converting From")
                .customFont(size: 23, weight: .bold)
                .alignView(to: .leading)
            
            Button {
                withAnimation {
                    viewModel.isShowingEditHistoricalRateBaseCurrencyView = true
                    self.date = .now.dayBefore
                }
                HapticManager.shared.impact(style: .soft)
            } label: {
                HStack {
                    Text(countryFlag(countryCode: String(subViewModel.baseCurrency.rawValue.dropLast(1))))
                        .customFont(size: 50, weight: .bold, design: .rounded)
                    
                    HStack(spacing: 5) {
                        let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[subViewModel.baseCurrency.rawValue]??.decimalDigits
                        
                        Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", subViewModel.baseAmount))
                            .customFont(size: 23, weight: .bold, design: .rounded)
                        
                        Text(viewModel.currentAPIResponse_Currencies?.data[subViewModel.baseCurrency.rawValue]??.code ?? "")
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
    
    var favoritesView: some View {
        VStack(alignment: .leading) {
            Divider().padding(.horizontal).padding(.horizontal, 5)
            
            HStack {
                Text("Your Favourites")
                    .customFont(size: 23, weight: .bold)
                
                Spacer()
                
                Button("Edit") {
                    isShowingEditFavoritesView = true
                    HapticManager.shared.impact(style: .soft)
                }.fontWeight(.semibold).buttonStyle(.bordered)
            }.padding(.horizontal).padding(.horizontal, 5)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Converting From")
                        .customFont(size: 16, weight: .semibold)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(countryFlag(countryCode: String(subViewModel.baseCurrency.rawValue.dropLast(1))))
                            .customFont(size: 40, weight: .bold, design: .rounded)
                        
                        HStack(spacing: 5) {
                            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[subViewModel.baseCurrency.rawValue]??.decimalDigits
                            
                            Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", subViewModel.baseAmount))
                                .customFont(size: 20, weight: .bold, design: .rounded)
                            
                            Text(viewModel.currentAPIResponse_Currencies?.data[subViewModel.baseCurrency.rawValue]??.code ?? "")
                                .customFont(size: 20, weight: .bold, design: .rounded)
                        }.foregroundColor(.primary)
                    }
                }.padding(.top, 5)
                
                Spacer()
                
                Image(systemName: "arrow.turn.right.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            .alignView(to: .center)
            .padding()
            .background(Material.ultraThin)
            .cornerRadius(15)
            .padding(.horizontal)
            .padding(.horizontal, 5)
            
            if viewModel.favoriteCurrencies.filter({ $0 != subViewModel.baseCurrency.rawValue }).isEmpty {
                VStack {
                    Image(systemName: "tray.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.secondary)
                    
                    Text("There isn't any available favourite currencies.")
                        .customFont(size: 20, weight: .semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    
                    Text("Currency picked as base currency doesn't appear here.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .opacity(0.5)
                        .multilineTextAlignment(.center)
                        .padding(.top, 1)
                    
                    Button {
                        withAnimation {
                            isShowingEditFavoritesView = true
                            HapticManager.shared.impact(style: .soft)
                        }
                    } label: {
                        Label("Add Favourite Currencies", systemImage: "plus")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 14).foregroundColor(.accentColor))
                    }
                    .padding(.top, 5)
                    .scaleButtonStyle(opacityAmount: 1.0)
                }
                .alignView(to: .center)
                .padding()
                .padding(.vertical)
                .background(Material.ultraThin)
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.horizontal, 5)
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 0) {
                ForEach(viewModel.favoriteCurrencies.filter { $0 != subViewModel.baseCurrency.rawValue }, id: \.self) { code in
                    let destinationCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[code]??.decimalDigits
                    let destinationCurrencyName = viewModel.currentAPIResponse_Currencies?.data[code]??.name
                    let currencyValue = (subViewModel.currentAPIResponse?.data[code]?.value ?? 1.00)
                    
                    Button {
                        viewModel.showCurrencyDetailOnHistorical(currency: CurrencyCode(rawValue: code) ?? .USDollar)
                    } label: {
                        CurrencyCard(code: code, destinationCurrencyName: destinationCurrencyName ?? "US Dollar", destinationCurrencyDecimalDigit: destinationCurrencyDecimalDigit ?? 2, currencyValue: currencyValue)
                    }
                    .scaleButtonStyle(scaleAmount: 0.95, opacityAmount: 1.0)
                    .padding(5)
                    .onAppear {
                        if (viewModel.baseAmount * CGFloat(currencyValue)).rounded(toPlaces: destinationCurrencyDecimalDigit ?? 2) < 0.01 {
                            withAnimation {
                                viewModel.isShowingHistoricalViewAmountZeroLabel = true
                            }
                        }
                    }
                }
            }.padding(.horizontal)
        }.padding(.bottom)
    }
    
    var allCurrenciesView: some View {
        VStack {
            Divider().padding(.horizontal).padding(.horizontal, 5)
            
            Text("All Currencies")
                .customFont(size: 23, weight: .bold)
                .alignView(to: .leading)
                .padding(.horizontal).padding(.horizontal, 5)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(searchText.isEmpty ? .primary : .accentColor)
                    .fontWeight(searchText.isEmpty ? .regular : .semibold)
                
                TextField("Search with currency code", text: $searchText)
                    .submitLabel(.search)
                
                if !searchText.isEmpty {
                    Button {
                        withAnimation {
                            self.searchText.removeAll()
                            HapticManager.shared.impact(style: .rigid)
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.accentColor)
                    }.scaleButtonStyle(scaleAmount: 0.9, opacityAmount: 1)
                }
            }
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color(.systemGray5))
            }
            .padding(.horizontal)
            .padding(.horizontal, 5)
            .padding(.bottom, 3)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Converting From")
                        .customFont(size: 16, weight: .semibold)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(countryFlag(countryCode: String(subViewModel.baseCurrency.rawValue.dropLast(1))))
                            .customFont(size: 40, weight: .bold, design: .rounded)
                        
                        HStack(spacing: 5) {
                            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[subViewModel.baseCurrency.rawValue]??.decimalDigits
                            
                            Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", subViewModel.baseAmount))
                                .customFont(size: 20, weight: .bold, design: .rounded)
                            
                            Text(viewModel.currentAPIResponse_Currencies?.data[subViewModel.baseCurrency.rawValue]??.code ?? "")
                                .customFont(size: 20, weight: .bold, design: .rounded)
                        }.foregroundColor(.primary)
                    }
                }.padding(.top, 5)
                
                Spacer()
                
                Image(systemName: "arrow.turn.right.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            .alignView(to: .center)
            .padding()
            .background(Material.ultraThin)
            .cornerRadius(15)
            .padding(.horizontal)
            .padding(.horizontal, 5)
            
            let data = CurrencyCode.allCases.filter { $0 != subViewModel.baseCurrency }
            
            if data.filter({ $0.rawValue.hasPrefix(searchText.uppercased()) }).isEmpty {
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
                }.foregroundColor(.secondary).padding(.vertical).padding(.bottom)
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 0) {
                ForEach(data.filter { $0.rawValue.hasPrefix(searchText.uppercased()) }, id: \.self) { code in
                    let destinationCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[code.rawValue]??.decimalDigits
                    let destinationCurrencyName = viewModel.currentAPIResponse_Currencies?.data[code.rawValue]??.name
                    let currencyValue = (subViewModel.currentAPIResponse?.data[code.rawValue]?.value ?? 1.00)
                    
                    Button {
                        viewModel.showCurrencyDetailOnHistorical(currency: code)
                    } label: {
                        CurrencyCard(code: code.rawValue, destinationCurrencyName: destinationCurrencyName ?? "US Dollar", destinationCurrencyDecimalDigit: destinationCurrencyDecimalDigit ?? 2, currencyValue: currencyValue)
                    }
                    .scaleButtonStyle(scaleAmount: 0.95, opacityAmount: 1.0)
                    .padding(5)
                    .onAppear {
                        if (subViewModel.baseAmount * CGFloat(currencyValue)).rounded(toPlaces: destinationCurrencyDecimalDigit ?? 2) < 0.01 {
                            withAnimation {
                                viewModel.isShowingHistoricalViewAmountZeroLabel = true
                            }
                        }
                    }
                }
            }.padding(.horizontal)
        }
    }
}

struct HistoricalRatesView_Previews: PreviewProvider {
    static var previews: some View {
        HistoricalRatesView(subViewModel: .init()).environmentObject(ViewModel())
    }
}

final class HistoricalRatesViewModel: ObservableObject {
    @Published var currentAPIResponse: CurrencyAPIResponse_Historical? = nil
    
    @Published var baseCurrency: CurrencyCode = .USDollar
    @Published var baseAmount: CGFloat = 1.00
    
    @Published var isLoading: Bool = false
    @Published var hasErrorOccured: Bool = false
    
    func getHistoricalRate(date: Date) {
        if hasErrorOccured {
            withAnimation {
                hasErrorOccured = false
            }
        }
        
        withAnimation { isLoading = true }
        CurrencyAPIManager.shared.getHistoricalCurrencyData(date: date, baseCurrency: baseCurrency) { result in
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
            
            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[self.baseCurrency.rawValue]??.decimalDigits
            
            self.baseAmount = result.rounded(toPlaces: currentCurrencyDecimalDigit ?? 2)
        }
    }
    
    func updateBaseCurrency(to currency: CurrencyCode, date: Date) {
        withAnimation {
            self.baseCurrency = currency
            getHistoricalRate(date: date)
        }
    }
}
