//
//  HomeView.swift
//  Converta
//
//  Created by Ernest Dainals on 15/02/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var searchText: String = ""
    @State private var isShowingEditFavoritesView: Bool = false
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    header
                    
                    baseCurrencyView
                    
                    favoritesView
                    
                    LazyVStack {
                        allCurrenciesView
                    }.offset(y: 80).padding(.top)
                }
                .padding(.top, geo.safeAreaInsets.top + 20)
                .padding(.bottom)
                .padding(.bottom, 60)
                .frame(width: geo.size.width)
                .frame(minHeight: geo.size.height, alignment: .top)
                .background {
                    LinearGradient(colors: [.brandPurple3, .brandPurple4], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: 500, alignment: .top)
                        .cornerRadius(20)
                        .alignViewVertically(to: .top)
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .edgesIgnoringSafeArea(.top)
        }
        .sheet(isPresented: $isShowingEditFavoritesView) {
            EditFavoritesView(searchTextFieldColor: Color(.systemGray6), showHelpButton: false)
        }
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            Text("Welcome to \nConverta, Ernest.")
                .customFont(size: 25, weight: .heavy, design: .rounded)
                .foregroundColor(.white)
            
            if viewModel.currentAPIResponse_Latest != nil {
                Text("These Informations were updated at \((viewModel.currentAPIResponse_Latest?.meta.lastUpdatedAt.formatted(date: .numeric, time: .shortened))!)")
                    .customFont(size: 17, weight: .semibold, design: .rounded)
                    .foregroundColor(.brandWhite)
                    .opacity(0.7)
            } else {
                Text("Loading Data...")
                    .customFont(size: 17, weight: .semibold, design: .rounded)
                    .foregroundColor(.brandWhite)
                    .opacity(0.7)
            }
        }.alignView(to: .leading).padding(.horizontal)
    }
    
    var baseCurrencyView: some View {
        VStack(alignment: .leading) {
            Text("Converting From")
                .customFont(size: 20, weight: .bold, design: .rounded)
                .foregroundColor(.white)
            
            Button {
                withAnimation { viewModel.isShowingHomeEditBaseCurrencyView = true }
                HapticManager.shared.impact(style: .soft)
            } label: {
                HStack {
                    Text(countryFlag(countryCode: String(viewModel.baseCurrency?.rawValue.dropLast(1) ?? "US")))
                        .customFont(size: 50, weight: .bold, design: .rounded)
                    
                    HStack(spacing: 5) {
                        let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.decimalDigits
                        
                        Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", viewModel.baseAmount))
                            .customFont(size: 23, weight: .bold, design: .rounded)
                        
                        Text(viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.code ?? "")
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
                        .background { Circle().foregroundColor(.brandPurple3) }
                        .padding(7)
                }
            }.scaleButtonStyle(scaleAmount: 0.97, opacityAmount: 1)
        }.alignView(to: .leading).padding(.horizontal).padding(.top, 2)
    }
    
    var favoritesView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Your Favorites")
                    .customFont(size: 20, weight: .bold, design: .rounded)
                    .foregroundColor(.brandWhite)
                
                Spacer()
                
                Button("Edit") {
                    isShowingEditFavoritesView = true
                    HapticManager.shared.impact(style: .soft)
                }.fontWeight(.semibold).foregroundColor(.brandPurple1).buttonStyle(.bordered)
            }
            .alignView(to: .leading)
            .padding(.horizontal)
            
            TabView {
                if viewModel.favoriteCurrencies.isEmpty {
                    VStack {
                        Text("You don't have favorite currencies yet.")
                            .customFont(size: 20, weight: .semibold, design: .rounded)
                            .padding()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .alignView(to: .center)
                    .frame(height: 175)
                    .background(Material.ultraThin)
                    .cornerRadius(15)
                    .padding(.horizontal, 9)
                }
                
                ForEach(viewModel.favoriteCurrencies.filter { $0 != viewModel.baseCurrency?.rawValue }, id: \.self) { rawValue in
                    let code = CurrencyCode(rawValue: rawValue)
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("To")
                                .customFont(size: 19, weight: .semibold)
                                .foregroundColor(.secondary)
                            
                            Text(countryFlag(countryCode: String(viewModel.currentAPIResponse_Currencies?.data[code?.rawValue ?? "USD"]?.code.dropLast(1) ?? "US")))
                                .customFont(size: 30, weight: .bold, design: .rounded)
                            
                            Text(viewModel.currentAPIResponse_Currencies?.data[code?.rawValue ?? "USD"]?.name ?? "Loading Data...")
                                .customFont(size: 19, weight: .semibold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }.alignView(to: .leading).padding(.horizontal)
                        
                        Divider().padding(.horizontal)
                        
                        HStack(spacing: 4) {
                            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.decimalDigits
                            
                            Text(countryFlag(countryCode: String(viewModel.baseCurrency?.rawValue.dropLast(1) ?? "US")))
                                .customFont(size: 35, weight: .bold, design: .rounded)
                            
                            Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", viewModel.baseAmount))
                                .customFont(size: 22, weight: .semibold, design: .rounded)
                            
                            Text(viewModel.baseCurrency?.rawValue ?? "")
                                .customFont(size: 22, weight: .semibold)
                        }.alignView(to: .leading).padding(.horizontal)
                        
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.turn.down.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 5) {
                                let destinationCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[code?.rawValue ?? "USD"]?.decimalDigits
                                let currencyValue = (viewModel.currentAPIResponse_Latest?.data[code?.rawValue ?? "USD"]?.value ?? 1.00)
                                
                                Text(countryFlag(countryCode: String(viewModel.currentAPIResponse_Currencies?.data[code?.rawValue ?? "USD"]?.code.dropLast(1) ?? "US")))
                                    .customFont(size: 40, weight: .bold, design: .rounded)
                                
                                Text(String(format: "%.\(destinationCurrencyDecimalDigit ?? 2)f", (viewModel.baseAmount * CGFloat(currencyValue))))
                                    .customFont(size: 30, weight: .semibold, design: .rounded)
                                
                                Text(viewModel.currentAPIResponse_Latest?.data[code?.rawValue ?? "USD"]?.code ?? "")
                                    .customFont(size: 30, weight: .semibold)
                            }
                        }.alignView(to: .leading).padding(.horizontal)
                        
                        let currencyValue = (viewModel.currentAPIResponse_Latest?.data[code?.rawValue ?? "USD"]?.value ?? 1.00)
                        let destinationCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[code?.rawValue ?? "USD"]?.decimalDigits
                        
                        if (viewModel.baseAmount * CGFloat(currencyValue)).rounded(toPlaces: destinationCurrencyDecimalDigit ?? 2) < 0.01 {
                            Label("The converted value can be a zero if the amount before conversion is too small.", systemImage: "info.circle")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .alignView(to: .center)
                    .frame(height: 200)
                    .background(Material.ultraThin)
                    .cornerRadius(15)
                    .padding(.horizontal, 9)
                }.scaleButtonStyle(scaleAmount: 0.98, opacityAmount: 1)
            }.tabViewStyle(.page(indexDisplayMode: .never)).frame(height: 200)
        }.frame(height: 170).offset(y: 50)
    }
    
    var allCurrenciesView: some View {
        LazyVStack(alignment: .leading) {
            Text("All Currencies")
                .customFont(size: 20, weight: .bold, design: .rounded)
                .foregroundColor(.primary)
                .padding(.horizontal)
                .alignView(to: .leading)
            
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
                            .foregroundColor(.brandPurple4)
                    }.scaleButtonStyle(scaleAmount: 0.9, opacityAmount: 1)
                }
            }
            .padding(15)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color(.systemGray5))
            }
            .padding(.horizontal)
            .padding(.bottom, 3)
            
            LazyVStack {
                let data = CurrencyCode.allCases.filter { $0 != viewModel.baseCurrency }
                
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
                    }.foregroundColor(.secondary).padding(.vertical)
                }
                
                ForEach(data.filter { $0.rawValue.hasPrefix(searchText.uppercased()) }, id: \.self) { code in
                    let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.decimalDigits
                    let destinationCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[code.rawValue]?.decimalDigits
                    let currencyValue = (viewModel.currentAPIResponse_Latest?.data[code.rawValue]?.value ?? 1.00)
                    let baseCurrencyCode = viewModel.baseCurrency?.rawValue
                    let baseCurrencyName = viewModel.currentAPIResponse_Currencies?.data[baseCurrencyCode ?? "USD"]?.name
                    let baseCurrencyNamePlural = viewModel.currentAPIResponse_Currencies?.data[baseCurrencyCode ?? "USD"]?.namePlural
                    let destinationCurrencyCountryCode = viewModel.currentAPIResponse_Currencies?.data[code.rawValue]?.code
                    
                    VStack {
                        HStack(spacing: 5) {
                            Text(countryFlag(countryCode: String(baseCurrencyCode?.dropLast() ?? "US")))
                                .customFont(size: 25)
                            
                            Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", viewModel.baseAmount))
                                .customFont(size: 20, weight: .semibold, design: .rounded)
                            
                            Text((viewModel.baseAmount == 1 ? baseCurrencyName : baseCurrencyNamePlural) ?? "")
                                .customFont(size: 20, weight: .semibold, design: .rounded)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }.alignView(to: .leading)
                        
                        HStack {
                            Image(systemName: "arrow.turn.down.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.secondary)
                            
                            Text(countryFlag(countryCode: String(destinationCurrencyCountryCode?.dropLast() ?? "US")))
                                .customFont(size: 35)
                            
                            Text(String(format: "%.\(destinationCurrencyDecimalDigit ?? 2)f", (viewModel.baseAmount * CGFloat(currencyValue))))
                                .customFont(size: 25, weight: .semibold, design: .rounded)
                            
                            Text(destinationCurrencyCountryCode ?? "")
                                .customFont(size: 25, weight: .semibold, design: .rounded)
                        }.alignView(to: .leading)
                        
                        if (viewModel.baseAmount * CGFloat(currencyValue)).rounded(toPlaces: destinationCurrencyDecimalDigit ?? 2) < 0.01 {
                            Label("The converted value can be a zero if the amount before conversion is too small.", systemImage: "info.circle")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .alignView(to: .leading)
                    .padding()
                    .background(Material.ultraThin)
                    .cornerRadius(15)
                }.scaleButtonStyle(scaleAmount: 0.98, opacityAmount: 1)
            }.padding(.horizontal)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
            .environmentObject(ViewModel())
    }
}
