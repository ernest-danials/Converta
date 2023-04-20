//
//  ContentView.swift
//  Converta for Apple Watch Watch App
//
//  Created by Ernest Dainals on 26/03/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: []) private var items: FetchedResults<LibraryItem>
    var body: some View {
        if !viewModel.hasErrorOccured {
            NavigationStack {
                if !items.isEmpty {
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                LibraryItemDetailView(baseCurrencyCode: CurrencyCode(rawValue: item.baseCurrencyCode ?? "USD") ?? .USDollar, destinationCurrencyCode: CurrencyCode(rawValue: item.destinationCurrencyCode ?? "USD") ?? .USDollar)
                            } label: {
                                listRow(item: item)
                            }
                        }
                    }.navigationTitle("Library")
                } else {
                    VStack(spacing: 6) {
                        Image(systemName: "tray.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        
                        Text("Your Library is Empty")
                            .customFont(size: 20, weight: .semibold)
                            .lineLimit(1)
                        
                        Text("You can add items to your Library on your iPhone")
                            .customFont(size: 10)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }.minimumScaleFactor(0.4).padding(.horizontal).navigationTitle("Library")
                }
            }.task { viewModel.initiateFuctionsForWatchOS() }
        } else {
            ScrollView {
                Image(systemName: "wifi.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
                Text("Sorry, an error has occured")
                    .customFont(size: 18, weight: .semibold)
                    .multilineTextAlignment(.center)
                
                Button {
                    viewModel.initiateFuctionsForWatchOS()
                } label: {
                    Label("Retry", systemImage: "arrow.clockwise")
                        .fontWeight(.bold)
                }.buttonStyle(.borderedProminent).buttonBorderShape(.capsule).padding(.top)
            }
        }
    }
    
    func listRow(item: LibraryItem) -> some View {
        HStack {
            HStack(spacing: 5) {
                Text(countryFlag(countryCode: String(item.baseCurrencyCode?.dropLast() ?? "US")))
                    .customFont(size: 15)
                
                Text(item.baseCurrencyCode ?? "USD")
                    .customFont(size: 15, weight: .semibold)
                    .lineLimit(1)
            }.minimumScaleFactor(0.4)
            
            Spacer()
            
            Image(systemName: "arrow.right.square.fill").foregroundColor(.accentColor).minimumScaleFactor(0.4)
            
            Spacer()
            
            HStack(spacing: 5) {
                Text(countryFlag(countryCode: String(item.destinationCurrencyCode?.dropLast() ?? "US")))
                    .customFont(size: 15)
                
                Text(item.destinationCurrencyCode ?? "USD")
                    .customFont(size: 15, weight: .semibold)
                    .lineLimit(1)
            }.minimumScaleFactor(0.4)
        }.frame(height: 55).padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
