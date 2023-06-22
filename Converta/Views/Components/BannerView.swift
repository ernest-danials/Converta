//
//  BannerView.swift
//  Newscroll
//
//  Created by Ernest Dainals on 13/02/2023.
//

import SwiftUI

struct BannerView<Content>: View where Content: View {
    let minHeight: CGFloat
    let closeButtonText: String
    let dismissAction: () -> Void
    let buttonColor: Color
    let hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle
    let content: () -> Content
    
    init(minHeight: CGFloat, closeButtonText: String, buttonColor: Color, hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .soft, dismissAction: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.minHeight = minHeight
        self.closeButtonText = closeButtonText
        self.dismissAction = dismissAction
        self.buttonColor = buttonColor
        self.content = content
        self.hapticStyle = hapticStyle
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: minHeight / 2)
            
            content()
                .padding(.top)
            
            Spacer()
                .frame(height: minHeight / 2)
            
            Button {
                withAnimation(.spring()) {
                    dismissAction()
                }
                
                HapticManager.shared.impact(style: hapticStyle)
            } label: {
                Text(closeButtonText)
                    .customFont(size: 20, weight: .semibold)
                    .foregroundColor(.white)
                    .padding()
                    .alignView(to: .center)
                    .background(buttonColor.gradient)
                    .cornerRadius(20)
            }.scaleButtonStyle().padding()
        }
        .frame(minHeight: minHeight)
        .padding(.bottom)
        .background(Color(.systemGray6))
        .cornerRadius(35, corners: [.topLeft, .topRight])
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        BannerView(minHeight: 300, closeButtonText: "Preview", buttonColor: .accentColor) {
            
        } content: {
            Text("Preview")
        }
    }
}
