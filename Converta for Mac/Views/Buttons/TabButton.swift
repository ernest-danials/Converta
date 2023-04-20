//
//  TabButton.swift
//  Converta for Mac
//
//  Created by Ernest Dainals on 19/03/2023.
//

import SwiftUI

struct TabButton: View {
    @EnvironmentObject var viewModel: ViewModel
    let tabItem: TabViewItems
    let animation: Namespace.ID
    var body: some View {
        Button {
            viewModel.changeSelectedView(to: tabItem)
        } label: {
            HStack {
                Image(systemName: tabItem.getImageName())
                    .font(.title)
                    .symbolVariant(.fill)
                    .foregroundColor(viewModel.selectedView == tabItem ? .primary : .secondary)
                    .frame(width: 30)
                
                Text(tabItem.rawValue)
                    .font(.title2)
                    .fontWeight(viewModel.selectedView == tabItem ? .semibold : .regular)
                    .foregroundColor(viewModel.selectedView == tabItem ? .primary : .secondary)
                    .animation(.none)
                
                Spacer()
                
                ZStack {
                    Capsule()
                        .fill(Color.clear)
                        .frame(width: 3, height: 20)
                    
                    if viewModel.selectedView == tabItem {
                        Capsule()
                            .fill(Color.primary)
                            .frame(width: 3, height: 20)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                    }
                }
            }.padding(.horizontal)
        }.buttonStyle(.plain)
    }
}

