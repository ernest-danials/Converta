//
//  ContentView.swift
//  Converta
//
//  Created by Ernest Dainals on 15/02/2023.
//

import SwiftUI

struct AppTabView: View {
    @EnvironmentObject var viewModel: ViewModel
    @StateObject var historicalRatesViewModel = HistoricalRatesViewModel()
    @StateObject var cryptoCurrencyViewModel = CryptoCurrencyViewModel()
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            if viewModel.hasErrorOccured {
                ErrorOccuredView()
            } else {
                TabView {
                    NewHomeScreen(cryptoCurrencyViewModel: cryptoCurrencyViewModel)
                        .onAppear { HapticManager.shared.impact(style: .soft) }
                        .tabItem { Label(TabViewItems.Home.rawValue, systemImage: TabViewItems.Home.getImageName()) }
                        .overlay(alignment: .bottom) {
                            if viewModel.isShowingHomeAmountZeroLabel { ValueZeroLabel }
                        }

                    LibraryView()
                        .onAppear { HapticManager.shared.impact(style: .soft) }
                        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                        .tabItem { Label(TabViewItems.Library.rawValue, systemImage: TabViewItems.Library.getImageName()) }
                    
                    HistoricalRatesView(subViewModel: historicalRatesViewModel)
                        .onAppear { HapticManager.shared.impact(style: .soft) }
                        .tabItem { Label(TabViewItems.Historical.rawValue, systemImage: TabViewItems.Historical.getImageName()) }
                        .overlay(alignment: .bottom) {
                            if viewModel.isShowingHistoricalViewAmountZeroLabel { ValueZeroLabel }
                        }
                    
                    CurrencyCodesView()
                        .onAppear { HapticManager.shared.impact(style: .soft) }
                        .tabItem { Label(TabViewItems.CurrencyCodes.rawValue, systemImage: TabViewItems.CurrencyCodes.getImageName()) }
                    
                    SettingsView()
                        .onAppear { HapticManager.shared.impact(style: .soft) }
                        .tabItem { Label(TabViewItems.Settings.rawValue, systemImage: TabViewItems.Settings.getImageName()) }
                }
                .setupForBanner(showWhen: viewModel.isShowingHomeEditBaseCurrencyView, minHeight: 35, buttonColor: .brandPurple3, dismissAction: dismissHomeEditBaseCurrency, bannerContent: EditHomeBaseCurrencyView())
                .setupForBanner(showWhen: viewModel.isShowingHomeInfoView, minHeight: 50, buttonColor: .brandPurple3, dismissAction: { viewModel.isShowingHomeInfoView = false }, bannerContent: HomeInfoView())
                .setupForBanner(showWhen: viewModel.isShowingEditHistoricalRateBaseCurrencyView, minHeight: 35, buttonColor: .brandPurple3, dismissAction: dismissHistoricalEditBaseCurrency, bannerContent: EditHistoricalViewBaseCurrencyView(subViewModel: historicalRatesViewModel, date: .now.dayBefore))
                .setupForBanner(showWhen: viewModel.isShowingEditCryptoBaseCurrencyView, minHeight: 35, buttonColor: .brandPurple3, dismissAction: dismissCryptoEditBaseCurrency, bannerContent: EditCryptoCurrencyViewBaseCurrencyView(subViewModel: cryptoCurrencyViewModel))
                .overlay { currencyDetailViewScreen }
                .overlay { historicalCurrencyDetailViewScreen }
            }
        }
        .preferredColorScheme(viewModel.colorScheme == "Device Settings" ? nil : AppearanceMode(rawValue: viewModel.colorScheme)?.getColorScheme())
        .overlay { if !viewModel.hasSeenOnboarding || viewModel.isShowingOnboarding { OnBoardingView() } }
        .task {
            viewModel.initiateFunctions(getData: true)
            cryptoCurrencyViewModel.getCryptoCurrencyData()
        }
        .overlay { if viewModel.isLoading() { LoadingView() } }
        .tint(viewModel.isLoading() ? .secondary : .brandPurple3)
    }
    
    var currencyDetailViewScreen: some View {
        ZStack {
            if viewModel.isShowingCurrencyDetailView {
                Color.black.opacity(0.8)
                    .onTapGesture { viewModel.hideCurrencyDetail() }
                    .transition(.opacity)
            }
            
            if viewModel.isShowingCurrencyDetailView { currencyDetailView }
        }.ignoresSafeArea()
    }
    
    var historicalCurrencyDetailViewScreen: some View {
        ZStack {
            if viewModel.isShowingCurrencyDetailViewOnHistorical {
                Color.black.opacity(0.8)
                    .onTapGesture { viewModel.hideCurrencyDetailOnHistorical() }
                    .transition(.opacity)
            }
            
            if viewModel.isShowingCurrencyDetailViewOnHistorical { historicalCurrencyDetailView }
        }.ignoresSafeArea()
    }
    
    var currencyDetailView: some View {
        ZStack {
            let baseCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? ""]??.decimalDigits
            let baseCurrencyName = viewModel.currentAPIResponse_Currencies?.data[viewModel.baseCurrency?.rawValue ?? ""]??.name
            let baseCurrencyCode = viewModel.baseCurrency
            let baseAmount = viewModel.baseAmount
            let selectedCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.selectedCurrencyForDetail?.rawValue ?? ""]??.decimalDigits
            let selectedCurrencyName = viewModel.currentAPIResponse_Currencies?.data[viewModel.selectedCurrencyForDetail?.rawValue ?? ""]??.name
            let selectedCurrencyValue = (viewModel.currentAPIResponse_Latest?.data[viewModel.selectedCurrencyForDetail?.rawValue ?? ""]?.value ?? 1.00)
            let shareItem = "\(countryFlag(countryCode: String(baseCurrencyCode?.rawValue.dropLast() ?? "US"))) " + String(format: "%.\(baseCurrencyDecimalDigit ?? 2)f", baseAmount) + " " + (baseCurrencyCode?.rawValue ?? "USD") + " → " + countryFlag(countryCode: String(viewModel.selectedCurrencyForDetail?.rawValue.dropLast() ?? "US")) + " " + String(format: "%.\(selectedCurrencyDecimalDigit ?? 2)f", (baseAmount * CGFloat(selectedCurrencyValue))) + " " + (viewModel.selectedCurrencyForDetail?.rawValue ?? "USD")
            
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    VStack {
                        Text(baseCurrencyName ?? "")
                            .customFont(size: 18, weight: .semibold)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            Text(countryFlag(countryCode: String(baseCurrencyCode?.rawValue.dropLast() ?? "US")))
                                .customFont(size: 57)
                            
                            Text(String(format: "%.\(baseCurrencyDecimalDigit ?? 2)f", baseAmount) + " " + (baseCurrencyCode?.rawValue ?? "USD"))
                                .customFont(size: 45, weight: .bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                        }
                    }
                    
                    Image(systemName: "arrow.down.app.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.brandPurple3)
                        .padding(.bottom).padding(.bottom)
                    
                    VStack {
                        Text(selectedCurrencyName ?? "")
                            .customFont(size: 18, weight: .semibold)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            Text(countryFlag(countryCode: String(viewModel.selectedCurrencyForDetail?.rawValue.dropLast() ?? "US")))
                                .customFont(size: 57)
                            
                            Text(String(format: "%.\(selectedCurrencyDecimalDigit ?? 2)f", (baseAmount * CGFloat(selectedCurrencyValue))) + " " + (viewModel.selectedCurrencyForDetail?.rawValue ?? "USD"))
                                .customFont(size: 45, weight: .bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                        }
                    }
                }
                .alignView(to: .center)
                .frame(maxWidth: 500)
                .padding(40)
                .padding(.bottom, 30)
                .background(Material.regular)
                .cornerRadius(15)
                .padding(.horizontal)
                .overlay(alignment: .topTrailing) {
                    Button {
                        viewModel.hideCurrencyDetail()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                            .foregroundColor(.brandPurple3)
                    }
                    .scaleButtonStyle()
                    .padding()
                    .padding(.trailing, 15)
                }
                
                ShareLink(item: ConstantStrings.shareBaseText.rawValue + Date.now.homeInfoDisplay + ".\n\n" + shareItem) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .fontWeight(.semibold)
                        
                        Text("Share")
                            .customFont(size: 18, weight: .semibold)
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.brandPurple4)
                    .cornerRadius(15, corners: [.bottomRight, .topLeft])
                }
                .scaleButtonStyle(scaleAmount: 1.0, opacityAmount: 0.75)
                .padding(.trailing)
            }
        }.transition(.opacity.combined(with: .offset(y: 40)))
    }
    
    var historicalCurrencyDetailView: some View {
        ZStack {
            let baseCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[historicalRatesViewModel.baseCurrency.rawValue]??.decimalDigits
            let baseCurrencyName = viewModel.currentAPIResponse_Currencies?.data[historicalRatesViewModel.baseCurrency.rawValue]??.name
            let baseCurrencyCode = historicalRatesViewModel.baseCurrency
            let baseAmount = historicalRatesViewModel.baseAmount
            let selectedCurrencyDecimalDigit = viewModel.currentAPIResponse_Currencies?.data[viewModel.selectedCurrencyForDetailOnHistorical?.rawValue ?? ""]??.decimalDigits
            let selectedCurrencyName = viewModel.currentAPIResponse_Currencies?.data[viewModel.selectedCurrencyForDetailOnHistorical?.rawValue ?? ""]??.name
            let selectedCurrencyValue = (historicalRatesViewModel.currentAPIResponse?.data[viewModel.selectedCurrencyForDetailOnHistorical?.rawValue ?? ""]?.value ?? 1.00)
            let shareItem = "\(countryFlag(countryCode: String(baseCurrencyCode.rawValue.dropLast()))) " + String(format: "%.\(baseCurrencyDecimalDigit ?? 2)f", baseAmount) + " " + (baseCurrencyCode.rawValue) + " → " + countryFlag(countryCode: String(viewModel.selectedCurrencyForDetailOnHistorical?.rawValue.dropLast() ?? "US")) + " " + String(format: "%.\(selectedCurrencyDecimalDigit ?? 2)f", (baseAmount * CGFloat(selectedCurrencyValue))) + " " + (viewModel.selectedCurrencyForDetailOnHistorical?.rawValue ?? "USD")
            
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    VStack {
                        Text(baseCurrencyName ?? "")
                            .customFont(size: 18, weight: .semibold)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            Text(countryFlag(countryCode: String(baseCurrencyCode.rawValue.dropLast())))
                                .customFont(size: 57)
                            
                            Text(String(format: "%.\(baseCurrencyDecimalDigit ?? 2)f", baseAmount) + " " + (baseCurrencyCode.rawValue))
                                .customFont(size: 45, weight: .bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                        }
                    }
                    
                    Image(systemName: "arrow.down.app.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.brandPurple3)
                        .padding(.bottom).padding(.bottom)
                    
                    VStack {
                        Text(selectedCurrencyName ?? "")
                            .customFont(size: 18, weight: .semibold)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            Text(countryFlag(countryCode: String(viewModel.selectedCurrencyForDetailOnHistorical?.rawValue.dropLast() ?? "US")))
                                .customFont(size: 57)
                            
                            Text(String(format: "%.\(selectedCurrencyDecimalDigit ?? 2)f", (baseAmount * CGFloat(selectedCurrencyValue))) + " " + (viewModel.selectedCurrencyForDetailOnHistorical?.rawValue ?? "USD"))
                                .customFont(size: 45, weight: .bold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                        }
                    }
                }
                .alignView(to: .center)
                .frame(maxWidth: 500)
                .padding(40)
                .padding(.bottom, 30)
                .background(Material.regular)
                .cornerRadius(15)
                .padding(.horizontal)
                .overlay(alignment: .topTrailing) {
                    Button {
                        viewModel.hideCurrencyDetailOnHistorical()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                            .foregroundColor(.brandPurple3)
                    }
                    .scaleButtonStyle(opacityAmount: 1.0)
                    .padding()
                    .padding(.trailing, 15)
                }
                
                ShareLink(item: ConstantStrings.shareBaseText.rawValue.dropLast(5) + ".\n\n" + shareItem + "\n\n" + "This result used currency data from \(historicalRatesViewModel.date.formatted(date: .abbreviated, time: .omitted))") {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .fontWeight(.semibold)
                        
                        Text("Share")
                            .customFont(size: 18, weight: .semibold)
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.brandPurple4)
                    .cornerRadius(15, corners: [.bottomRight, .topLeft])
                }
                .scaleButtonStyle(scaleAmount: 1.0, opacityAmount: 0.75)
                .padding(.trailing)
            }
        }.transition(.opacity.combined(with: .offset(y: 40)))
    }
    
    var ValueZeroLabel: some View {
        Label("The converted values can appear as zero if the amount before conversion is too small.", systemImage: "info.circle")
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding()
            .background(Material.ultraThin)
            .cornerRadius(15)
            .shadow(radius: 3)
            .padding()
            .frame(maxHeight: 100)
            .minimumScaleFactor(0.5)
            .transition(.opacity.combined(with: .offset(y: 10)))
    }
    
    func dismissHomeEditBaseCurrency() {
        viewModel.isShowingHomeAmountZeroLabel = false
        viewModel.isShowingHomeEditBaseCurrencyView = false
    }
    
    func dismissHistoricalEditBaseCurrency() {
        viewModel.isShowingHistoricalViewAmountZeroLabel = false
        viewModel.isShowingEditHistoricalRateBaseCurrencyView = false
    }
    
    func dismissCryptoEditBaseCurrency() {
        viewModel.isShowingEditCryptoBaseCurrencyView = false
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
            .environmentObject(ViewModel())
    }
}
