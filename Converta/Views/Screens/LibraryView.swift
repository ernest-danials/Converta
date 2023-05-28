//
//  LibraryView.swift
//  Converta
//
//  Created by Ernest Dainals on 07/03/2023.

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: []) private var items: FetchedResults<LibraryItem>
    
    @State private var isShowingCreateNewItemView: Bool = false
    
    @State private var baseCurrencySearchText: String = ""
    @State private var destinationCurrencySearchText: String = ""
    
    @State private var newItemBaseCurrency: CurrencyCode = CurrencyCode.allCases.first!
    @State private var newItemDestinationCurrency: CurrencyCode = CurrencyCode.allCases.first!
    
    @State private var isInEdit: Bool = false
    
    @State private var selectedItemForDelete: LibraryItem? = nil
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if items.isEmpty {
                        itemEmptyView
                    } else {
                        Button {
                            withAnimation {
                                self.isInEdit = false
                                isShowingCreateNewItemView = true
                                HapticManager.shared.impact(style: .soft)
                            }
                        } label: {
                            Label("Add Item to Library", systemImage: "plus")
                                .customFont(size: 18, weight: .bold)
                                .foregroundColor(.brandWhite)
                                .alignView(to: .center)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accentColor))
                        }.scaleButtonStyle(opacityAmount: 1.0).padding([.horizontal, .bottom])
                    }
                    
                    LazyVGrid(columns: [.init(.adaptive(minimum: 400))], spacing: horizontalSizeClass == .compact ? 10 : 30) {
                        ForEach(items, id: \.id) { item in
                            NavigationLink {
                                LibraryCurrencyDetailView(baseCurrency: CurrencyCode(rawValue: item.baseCurrencyCode!) ?? .USDollar, destinationCurrency: CurrencyCode(rawValue: item.destinationCurrencyCode!) ?? .USDollar)
                                    .onAppear { HapticManager.shared.impact(style: .soft) }
                            } label: {
                                listRow(item: item)
                            }.scaleButtonStyle(scaleAmount: isInEdit ? 1.0 : 0.95)
                        }
                    }
                }.padding(.bottom)
            }
            .navigationTitle("Library")
            .toolbar {
                if !items.isEmpty {
                    Button(isInEdit ? "Done" : "Edit") {
                        withAnimation {
                            self.isInEdit.toggle()
                            HapticManager.shared.impact(style: .soft)
                        }
                    }.fontWeight(.semibold)
                }
            }
        }.sheet(isPresented: $isShowingCreateNewItemView) { createNewItemView }
    }
    
    var itemEmptyView: some View {
        VStack {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.secondary)
                .frame(width: 60, height: 60)
            
            Text("You don't have any items in your Library.")
                .customFont(size: 23, weight: .semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button {
                withAnimation {
                    self.isInEdit = false
                    isShowingCreateNewItemView = true
                    HapticManager.shared.impact(style: .soft)
                }
            } label: {
                Label("Create New Item", systemImage: "plus")
                    .customFont(size: 18, weight: .bold)
                    .foregroundColor(.brandWhite)
                    .padding()
                    .padding(.horizontal, 5)
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accentColor))
            }.scaleButtonStyle(opacityAmount: 1.0).padding()
        }.padding().padding(.top)
    }
    
    var createNewItemView: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink {
                        selectBaseCurrencyView(baseCurrencySearchText: $baseCurrencySearchText, newItemBaseCurrency: $newItemBaseCurrency)
                    } label: {
                        HStack {
                            Text(countryFlag(countryCode: String(newItemBaseCurrency.rawValue.dropLast())))
                                .customFont(size: 30)
                            
                            Text(viewModel.currentAPIResponse_Currencies?.data[newItemBaseCurrency.rawValue]??.name ?? "US Dollar")
                                .fontWeight(.semibold)
                        }
                    }.padding(.vertical, 2)
                } header: {
                    Text("Convert From")
                }
                
                Section {
                    NavigationLink {
                        selectDestinationCurrencyView(destinationCurrencySearchText: $destinationCurrencySearchText, newItemDestinationCurrency: $newItemDestinationCurrency)
                    } label: {
                        HStack {
                            Text(countryFlag(countryCode: String(newItemDestinationCurrency.rawValue.dropLast())))
                                .customFont(size: 30)
                            
                            Text(viewModel.currentAPIResponse_Currencies?.data[newItemDestinationCurrency.rawValue]??.name ?? "US Dollar")
                                .fontWeight(.semibold)
                        }
                    }.padding(.vertical, 2)
                } header: {
                    Text("Convert To")
                }
                
                if newItemBaseCurrency == newItemDestinationCurrency {
                    Text("Base currency and destination currency cannot be same.")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Add Item to Library")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        self.isShowingCreateNewItemView = false
                        self.newItemBaseCurrency = CurrencyCode.allCases.first!
                        self.newItemDestinationCurrency = CurrencyCode.allCases.first!
                        HapticManager.shared.impact(style: .rigid)
                    }.fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        withAnimation {
                            createNewItem(baseCurrencyCode: newItemBaseCurrency, destinationCurrencyCode: newItemDestinationCurrency)
                            self.isShowingCreateNewItemView = false
                            self.newItemBaseCurrency = CurrencyCode.allCases.first!
                            self.newItemDestinationCurrency = CurrencyCode.allCases.first!
                            HapticManager.shared.impact(style: .soft)
                        }
                    }.fontWeight(.semibold).disabled(newItemBaseCurrency == newItemDestinationCurrency)
                }
            }
        }
        .interactiveDismissDisabled().presentationDetents([.medium, .large]).presentationDragIndicator(.hidden)
    }
    
    func listRow(item: LibraryItem, padding: Edge.Set = .horizontal) -> some View {
        HStack {
            if isInEdit {
                Button {
                    if selectedItemForDelete == item {
                        withAnimation {
                            deleteItem(item: item)
                            HapticManager.shared.notification(type: .warning)
                        }
                    } else {
                        withAnimation {
                            self.selectedItemForDelete = item
                            HapticManager.shared.impact(style: .rigid)
                        }
                    }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: "trash.fill")
                            .imageScale(.large)
                            .fontWeight(selectedItemForDelete == item ? .semibold : .regular)
                        
                        Text(selectedItemForDelete == item ? "Sure?" : "Delete")
                            .customFont(size: 15, weight: selectedItemForDelete == item ? .bold : .medium)
                    }.foregroundColor(.red)
                }.scaleButtonStyle().padding(.trailing)
            }
            
            HStack {
                Text(countryFlag(countryCode: String(item.baseCurrencyCode?.dropLast() ?? "US")))
                    .customFont(size: isInEdit ? 35 : 40)
                
                Text(item.baseCurrencyCode ?? "")
                    .customFont(size: 30, weight: .semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            
            Image(systemName: "arrow.right.square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: isInEdit ? 25 : 35, height: isInEdit ? 25 : 35)
                .foregroundColor(.accentColor)
                .padding()
            
            HStack {
                Text(countryFlag(countryCode: String(item.destinationCurrencyCode?.dropLast() ?? "US")))
                    .customFont(size: isInEdit ? 35 : 40)
                
                Text(item.destinationCurrencyCode ?? "")
                    .customFont(size: 30, weight: .semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
        }.alignView(to: .center).padding().background(Material.ultraThin).cornerRadius(15).padding(padding)
    }
    
    private func createNewItem(baseCurrencyCode: CurrencyCode, destinationCurrencyCode: CurrencyCode) {
        withAnimation {
            let newItem = LibraryItem(context: moc)
            newItem.id = UUID()
            newItem.baseCurrencyCode = baseCurrencyCode.rawValue
            newItem.destinationCurrencyCode = destinationCurrencyCode.rawValue
            
            do {
                try moc.save()
            } catch {
                let error = error as NSError
                fatalError("An error has occured. Error: \(error)")
            }
        }
    }
    
    private func deleteItem(item: LibraryItem) {
        withAnimation {
            moc.delete(item)
            
            do {
                try moc.save()
            } catch {
                let error = error as NSError
                fatalError("An error has occured. Error: \(error)")
            }
            
            if items.isEmpty {
                self.isInEdit = false
            }
        }
    }
}

struct selectBaseCurrencyView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ViewModel
    @Binding var baseCurrencySearchText: String
    @Binding var newItemBaseCurrency: CurrencyCode
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(baseCurrencySearchText.isEmpty ? .primary : .accentColor)
                    .fontWeight(baseCurrencySearchText.isEmpty ? .regular : .semibold)
                
                TextField("Search with currency code", text: $baseCurrencySearchText)
                    .submitLabel(.search)
                
                if !baseCurrencySearchText.isEmpty {
                    Button {
                        withAnimation {
                            self.baseCurrencySearchText.removeAll()
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
            .padding(.horizontal, 6)
            .padding(.bottom, 3)
            
            if CurrencyCode.allCases.filter({ $0.rawValue.hasPrefix(baseCurrencySearchText.uppercased()) }).isEmpty {
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
            
            if !viewModel.favoriteCurrencies.isEmpty && baseCurrencySearchText.isEmpty {
                Text("Your Favourite Currencies")
                    .customFont(size: 20, weight: .semibold)
                    .alignView(to: .leading)
                    .padding(.horizontal)
                
                ForEach(viewModel.favoriteCurrencies, id: \.self) { code in
                    Button {
                        withAnimation {
                            self.newItemBaseCurrency = CurrencyCode(rawValue: code) ?? .USDollar
                            dismiss()
                            HapticManager.shared.impact(style: .soft)
                        }
                    } label: {
                        HStack {
                            Text(countryFlag(countryCode: String(code.dropLast())))
                                .customFont(size: 40)
                            
                            Text(viewModel.currentAPIResponse_Currencies?.data[code]??.name ?? "US Dollar")
                                .customFont(size: 20, weight: .semibold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if newItemBaseCurrency == CurrencyCode(rawValue: code) {
                                Image(systemName: "checkmark.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.accentColor)
                            }
                        }.padding(.vertical, 2).padding(.horizontal)
                    }
                    
                    Divider()
                }
            }
            
            if !viewModel.favoriteCurrencies.isEmpty && baseCurrencySearchText.isEmpty {
                Text("All Currencies")
                    .customFont(size: 20, weight: .semibold)
                    .alignView(to: .leading)
                    .padding([.horizontal, .top])
            }
            
            ForEach(CurrencyCode.allCases.filter { $0.rawValue.hasPrefix(baseCurrencySearchText.uppercased()) }, id: \.self) { code in
                Button {
                    withAnimation {
                        self.newItemBaseCurrency = code
                        dismiss()
                        HapticManager.shared.impact(style: .soft)
                    }
                } label: {
                    HStack {
                        Text(countryFlag(countryCode: String(code.rawValue.dropLast())))
                            .customFont(size: 40)
                        
                        Text(viewModel.currentAPIResponse_Currencies?.data[code.rawValue]??.name ?? "US Dollar")
                            .customFont(size: 20, weight: .semibold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if newItemBaseCurrency == code {
                            Image(systemName: "checkmark.circle")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                        }
                    }.padding(.vertical, 2).padding(.horizontal)
                }
                
                Divider()
            }
        }.navigationTitle("Convert From").alignView(to: .center).background(Color(.systemGray6))
    }
}

struct selectDestinationCurrencyView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ViewModel
    @Binding var destinationCurrencySearchText: String
    @Binding var newItemDestinationCurrency: CurrencyCode
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(destinationCurrencySearchText.isEmpty ? .primary : .accentColor)
                    .fontWeight(destinationCurrencySearchText.isEmpty ? .regular : .semibold)
                
                TextField("Search with currency code", text: $destinationCurrencySearchText)
                    .submitLabel(.search)
                
                if !destinationCurrencySearchText.isEmpty {
                    Button {
                        withAnimation {
                            self.destinationCurrencySearchText.removeAll()
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
            .padding(.horizontal, 6)
            .padding(.bottom, 3)
            
            if CurrencyCode.allCases.filter({ $0.rawValue.hasPrefix(destinationCurrencySearchText.uppercased()) }).isEmpty {
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
            
            if !viewModel.favoriteCurrencies.isEmpty && destinationCurrencySearchText.isEmpty {
                Text("Your Favourite Currencies")
                    .customFont(size: 20, weight: .semibold)
                    .alignView(to: .leading)
                    .padding(.horizontal)
                
                ForEach(viewModel.favoriteCurrencies, id: \.self) { code in
                    Button {
                        withAnimation {
                            self.newItemDestinationCurrency = CurrencyCode(rawValue: code) ?? .USDollar
                            dismiss()
                            HapticManager.shared.impact(style: .soft)
                        }
                    } label: {
                        HStack {
                            Text(countryFlag(countryCode: String(code.dropLast())))
                                .customFont(size: 40)
                            
                            Text(viewModel.currentAPIResponse_Currencies?.data[code]??.name ?? "US Dollar")
                                .customFont(size: 20, weight: .semibold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if newItemDestinationCurrency == CurrencyCode(rawValue: code) {
                                Image(systemName: "checkmark.circle")
                                    .imageScale(.large)
                                    .foregroundColor(.accentColor)
                            }
                        }.padding(.vertical, 2).padding(.horizontal)
                    }
                    
                    Divider()
                }
            }
            
            if !viewModel.favoriteCurrencies.isEmpty && destinationCurrencySearchText.isEmpty {
                Text("All Currencies")
                    .customFont(size: 20, weight: .semibold)
                    .alignView(to: .leading)
                    .padding([.horizontal, .top])
            }
            
            ForEach(CurrencyCode.allCases.filter { $0.rawValue.hasPrefix(destinationCurrencySearchText.uppercased()) }, id: \.self) { code in
                Button {
                    withAnimation {
                        self.newItemDestinationCurrency = code
                        dismiss()
                        HapticManager.shared.impact(style: .soft)
                    }
                } label: {
                    HStack {
                        Text(countryFlag(countryCode: String(code.rawValue.dropLast())))
                            .customFont(size: 40)
                        
                        Text(viewModel.currentAPIResponse_Currencies?.data[code.rawValue]??.name ?? "US Dollar")
                            .customFont(size: 20, weight: .semibold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.4)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if newItemDestinationCurrency == code {
                            Image(systemName: "checkmark.circle")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                        }
                    }.padding(.vertical, 2).padding(.horizontal)
                }
                
                Divider()
            }
        }.navigationTitle("Convert From").alignView(to: .center).background(Color(.systemGray6))
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
            .environmentObject(ViewModel())
    }
}
