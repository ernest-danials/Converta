//
//  OnBoardingView.swift
//  Converta
//
//  Created by Ernest Dainals on 15/03/2023.
//

import SwiftUI

struct OnBoardingView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        TabView {
            welcomeToConvertaView

            homeViewInfoView

            editBaseCurrency
            
            editFavoritesView

            libraryView
            
            dismissView
        }
        .edgesIgnoringSafeArea(.vertical)
        .tabViewStyle(.page(indexDisplayMode: .always))
        .background(Material.ultraThin)
    }
    
    var welcomeToConvertaView: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Welcome to")
                    .customFont(size: 35, weight: .semibold)
                
                Text("Converta!")
                    .customFont(size: 43, weight: .heavy)
                    .foregroundColor(.brandPurple3)
            }.alignView(to: .leading).padding(.bottom)
            
            Text("👋")
                .customFont(size: 80)
                .padding(.top, 150)
            
            Text("Let me introduce Converta to you.")
                .customFont(size: 25, weight: .semibold)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            swipeLeftToContinueLabel
        }.padding()
    }
    
    var homeViewInfoView: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack(alignment: .leading) {
                    Text("At Home,")
                        .customFont(size: 35, weight: .heavy)
                    
                    Text("You can convert to all of supported currencies.")
                        .customFont(size: 20, weight: .medium)
                        .opacity(0.8)
                        .padding(.bottom)
                    
                    Image("HomeView")
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(15)
                        .alignView(to: .center)
                    
                    Spacer()
                }.alignView(to: .leading).padding(.bottom).padding()
                
                swipeLeftToContinueLabel
            }
        }
    }
    
    var editFavoritesView: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack(alignment: .leading) {
                    Text("Also, you can select favourite currencies")
                        .customFont(size: 35, weight: .heavy)
                    
                    Text("They are pinned at various locations within the app.")
                        .customFont(size: 20, weight: .medium)
                        .opacity(0.8)
                        .padding(.bottom)
                    
                    Image("EditFavoritesView")
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(15)
                        .alignView(to: .center)
                    
                    Spacer()
                }.alignView(to: .leading).padding(.bottom).padding()
                
                swipeLeftToContinueLabel
            }
        }
    }
    
    var editBaseCurrency: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack(alignment: .leading) {
                    Text("You can edit base currency here")
                        .customFont(size: 35, weight: .heavy)
                    
                    Text("You can also change the base amount too.")
                        .customFont(size: 20, weight: .medium)
                        .opacity(0.8)
                        .padding(.bottom)
                    
                    Image("EditBaseCurrencyView")
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(15)
                        .alignView(to: .center)
                    
                    Spacer()
                }.alignView(to: .leading).padding(.bottom).padding()
                
                swipeLeftToContinueLabel
            }
        }
    }
    
    var libraryView: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack(alignment: .leading) {
                    Text("On your Library,")
                        .customFont(size: 35, weight: .heavy)
                    
                    Text("You can save both base currency and destination currency at the same time to use them later.\n\nLibrary syncs with all of your devices using iCloud.")
                        .customFont(size: 20, weight: .medium)
                        .opacity(0.8)
                        .padding(.bottom)
                    
                    Image("LibraryView")
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(15)
                        .alignView(to: .center)
                    
                    Divider().padding(.vertical)
                    
                    Image("LibraryDetailView")
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(15)
                        .alignView(to: .center)
                    
                    Spacer()
                }.alignView(to: .leading).padding(.bottom).padding()
                
                swipeLeftToContinueLabel
            }
        }
    }
    
    var dismissView: some View {
        VStack {
            Text("🙏").customFont(size: 90)
            
            Text("And that's it!")
                .customFont(size: 30, weight: .heavy)
            
            Text("Thank you for using Converta!")
                .customFont(size: 20, weight: .medium)
            
            Button {
                withAnimation {
                    if viewModel.hasSeenOnboarding == false { viewModel.hasSeenOnboarding = true }
                    if viewModel.isShowingOnboarding { viewModel.isShowingOnboarding = false }
                    HapticManager.shared.impact(style: .soft)
                }
            } label: {
                Text("Dismiss")
                    .customFont(size: 20, weight: .semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accentColor))
            }.scaleButtonStyle(opacityAmount: 1).padding()
        }
    }
    
    var swipeLeftToContinueLabel: some View {
        HStack {
            Text("Swipe left to continue")
            
            Image(systemName: "chevron.right")
        }
        .customFont(size: 18, weight: .semibold)
        .foregroundColor(.secondary)
        .padding()
        .background(Color(.systemGray4).opacity(0.8))
        .cornerRadius(15)
        .padding(.bottom, 30)
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
            .environmentObject(ViewModel())
    }
}
