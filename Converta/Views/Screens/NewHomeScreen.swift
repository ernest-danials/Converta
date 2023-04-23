//
//  NewHomeScreen.swift
//  Converta
//
//  Created by Ernest Dainals on 05/03/2023.
//

import SwiftUI

struct NewHomeScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var isShowingEditFavoritesView: Bool = false
    @State private var searchText: String = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                convertingFromView
                
                favoritesView
                
                allCurrenciesView.padding(.bottom)
                
                if viewModel.isShowingHomeAmountZeroLabel { Spacer(minLength: 90) }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            viewModel.isShowingHomeInfoView = true
                            HapticManager.shared.impact(style: .soft)
                        }
                    } label: {
                        Image(systemName: "info.circle")
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)
                    }.scaleButtonStyle(scaleAmount: 0.9, opacityAmount: 1.0)
                }
            }
        }.sheet(isPresented: $isShowingEditFavoritesView) { EditFavoritesView(searchTextFieldColor: Color(.systemGray6), showHelpButton: false) }
    }
    
    var convertingFromView: some View {
        VStack(alignment: .leading) {
            Text("Converting From")
                .customFont(size: 23, weight: .bold)
                .alignView(to: .leading)
            
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
                        Text(countryFlag(countryCode: String(viewModel.baseCurrency?.rawValue.dropLast(1) ?? "US")))
                            .customFont(size: 40, weight: .bold, design: .rounded)
                        
                        HStack(spacing: 5) {
                            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.decimalDigits
                            
                            Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", viewModel.baseAmount))
                                .customFont(size: 20, weight: .bold, design: .rounded)
                            
                            Text(viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.code ?? "")
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
            
            if viewModel.favoriteCurrencies.filter({ $0 != viewModel.baseCurrency?.rawValue }).isEmpty {
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
                ForEach(viewModel.favoriteCurrencies.filter { $0 != viewModel.baseCurrency?.rawValue }, id: \.self) { code in
                    let destinationCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[code]?.decimalDigits
                    let destinationCurrencyName = viewModel.currentAPIResponse_Currencies?.data[code]?.name
                    let currencyValue = (viewModel.currentAPIResponse_Latest?.data[code]?.value ?? 1.00)
                    
                    Button {
                        viewModel.showCurrencyDetail(currency: CurrencyCode(rawValue: code) ?? .USDollar)
                    } label: {
                        CurrencyCard(code: code, destinationCurrencyName: destinationCurrencyName ?? "US Dollar", destinationCurrencyDecimalDigit: destinationCurrencyDecimalDigit ?? 2, currencyValue: currencyValue)
                    }
                    .scaleButtonStyle(scaleAmount: 0.95, opacityAmount: 1.0)
                    .padding(5)
                    .onAppear {
                        if (viewModel.baseAmount * CGFloat(currencyValue)).rounded(toPlaces: destinationCurrencyDecimalDigit ?? 2) < 0.01 {
                            withAnimation {
                                viewModel.isShowingHomeAmountZeroLabel = true
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
                        Text(countryFlag(countryCode: String(viewModel.baseCurrency?.rawValue.dropLast(1) ?? "US")))
                            .customFont(size: 40, weight: .bold, design: .rounded)
                        
                        HStack(spacing: 5) {
                            let currentCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.decimalDigits
                            
                            Text(String(format: "%.\(currentCurrencyDecimalDigit ?? 2)f", viewModel.baseAmount))
                                .customFont(size: 20, weight: .bold, design: .rounded)
                            
                            Text(viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? "USD"]?.code ?? "")
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
                }.foregroundColor(.secondary).padding(.vertical).padding(.bottom)
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 0) {
                ForEach(data.filter { $0.rawValue.hasPrefix(searchText.uppercased()) }, id: \.self) { code in
                    let destinationCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[code.rawValue]?.decimalDigits
                    let destinationCurrencyName = viewModel.currentAPIResponse_Currencies?.data[code.rawValue]?.name
                    let currencyValue = (viewModel.currentAPIResponse_Latest?.data[code.rawValue]?.value ?? 1.00)
                    
                    Button {
                        viewModel.showCurrencyDetail(currency: code)
                    } label: {
                        CurrencyCard(code: code.rawValue, destinationCurrencyName: destinationCurrencyName ?? "US Dollar", destinationCurrencyDecimalDigit: destinationCurrencyDecimalDigit ?? 2, currencyValue: currencyValue)
                    }
                    .scaleButtonStyle(scaleAmount: 0.95, opacityAmount: 1.0)
                    .padding(5)
                    .onAppear {
                        if (viewModel.baseAmount * CGFloat(currencyValue)).rounded(toPlaces: destinationCurrencyDecimalDigit ?? 2) < 0.01 {
                            withAnimation {
                                viewModel.isShowingHomeAmountZeroLabel = true
                            }
                        }
                    }
                }
            }.padding(.horizontal)
        }
    }
}

struct NewHomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
            .environmentObject(ViewModel())
    }
}
