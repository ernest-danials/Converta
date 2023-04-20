//
//  ContentView.swift
//  Converta for Mac
//
//  Created by Ernest Dainals on 19/03/2023.
//

import SwiftUI

struct ContentView: View {
    var window = NSScreen.main?.visibleFrame
    @EnvironmentObject var viewModel: ViewModel
    @Namespace var animation
    
    let initialView: TabViewItems
    
    init(initialView: TabViewItems = .Home) { self.initialView = initialView }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                VStack(spacing: 22) {
                    VStack(alignment: .leading) {
                        Text("Welcome To")
                            .customFont(size: 25, weight: .semibold)
                        
                        Text("Converta")
                            .customFont(size: 40, weight: .heavy)
                            .foregroundColor(.brandPurple3)
                    }.padding(.top, 65)
                    
                    ForEach(TabViewItems.allCases, id: \.self) { item in
                        TabButton(tabItem: item, animation: animation)
                    }
                    
                    Spacer()
                }.frame(width: 220).padding(.leading, 10)
                
                Divider()
            }.background(BlurWindow())
            
            switch viewModel.selectedView {
            case .Home:
                HomeView()
            case .Library:
                LibraryView()
            case .Settings:
                SettingsView()
            }
        }
        .ignoresSafeArea()
        .frame(minWidth: window!.width / 1.5, minHeight: window!.height - 200)
        .task { withAnimation { viewModel.changeSelectedView(to: initialView) } }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
