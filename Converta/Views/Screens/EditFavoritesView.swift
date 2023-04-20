//
//  EditFavoritesView.swift
//  Converta
//
//  Created by Ernest Dainals on 25/02/2023.
//

import SwiftUI

struct EditFavoritesView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    let searchTextFieldColor: Color
    let needToolbar: Bool
    let showHelpButton: Bool
    
    init(searchTextFieldColor: Color, needToolbar: Bool = true, showHelpButton: Bool) {
        self.searchTextFieldColor = searchTextFieldColor
        self.needToolbar = needToolbar
        self.showHelpButton = showHelpButton
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if viewModel.favoriteCurrencies.isEmpty {
                        VStack(alignment: .leading) {
                            Text("You don't have any favorite currencies.")
                        }
                    }
                    
                    ForEach(viewModel.favoriteCurrencies, id: \.self) { rawValue in
                        let currencyCode = CurrencyCode(rawValue: rawValue)
                        
                        Button {
                            withAnimation {
                                viewModel.favoriteCurrencies = viewModel.favoriteCurrencies.compactMap { item in
                                    if item == rawValue {
                                        return nil
                                    } else {
                                        return item
                                    }
                                }
                                
                                HapticManager.shared.impact(style: .rigid)
                            }
                        } label: {
                            HStack {
                                Text(countryFlag(countryCode: String(currencyCode?.rawValue.dropLast() ?? "US")))
                                    .customFont(size: 30)
                                
                                Text(viewModel.currentAPIResponse_Currencies?.data[currencyCode?.rawValue ?? "USD"]?.name ?? "Loading...")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }.padding(.vertical, 3)
                        }
                    }
                } header: {
                    Text("Favorites")
                } footer: {
                    if viewModel.favoriteCurrencies.isEmpty { Label("Unlike your Library, your favorite currencies do not sync with your iCloud.", systemImage: "info.circle") }
                }
                
                Section("Do Not Include") {
                    let data: [CurrencyCode] = CurrencyCode.allCases.compactMap { code in
                        if viewModel.favoriteCurrencies.contains(code.rawValue) {
                            return nil
                        } else {
                            return code
                        }
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(searchText.isEmpty ? .primary : .accentColor)
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
                                    .foregroundColor(.accentColor)
                            }.scaleButtonStyle(scaleAmount: 0.9, opacityAmount: 1)
                        }
                        
                        if showHelpButton {
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
                    }
                    .padding(15)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(searchTextFieldColor)
                    }
                    .listRowInsets(.init(top: 12, leading: 10, bottom: 10, trailing: 10))
                    .listRowSeparator(.hidden)
                    
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
                            
                            Text("You can only search with currency codes.")
                                .font(.footnote)
                                .padding(.horizontal)
                        }.foregroundColor(.secondary).padding(.vertical).alignView(to: .center).listRowSeparator(.hidden)
                    }
                    
                    ForEach(data.filter { $0.rawValue.hasPrefix(searchText.uppercased()) }, id: \.self) { currency in
                        Button {
                            withAnimation {
                                viewModel.favoriteCurrencies.append(currency.rawValue)
                                searchText.removeAll()
                                hideKeyboard()
                                HapticManager.shared.impact(style: .soft)
                            }
                        } label: {
                            HStack {
                                Text(countryFlag(countryCode: String(currency.rawValue.dropLast() )))
                                    .customFont(size: 30)
                                
                                Text(viewModel.currentAPIResponse_Currencies?.data[currency.rawValue ]?.name ?? "Loading...")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.green)
                            }.padding(.vertical, 3)
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("Edit Favorites")
            .toolbar {
                if needToolbar {
                    Button("Done") {
                        dismiss()
                        HapticManager.shared.impact(style: .soft)
                    }.fontWeight(.semibold)
                }
            }
            .background(Color(.systemGray6))
        }
    }
}

struct EditFavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        EditFavoritesView(searchTextFieldColor: Color(.systemGray6), showHelpButton: true)
            .environmentObject(ViewModel())
    }
}
