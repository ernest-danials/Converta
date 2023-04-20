//
//  View+Ext.swift
//  Converta
//
//  Created by Ernest Dainals on 15/02/2023.
//

import SwiftUI

extension View {
    func alignView(to: HorizontalAlignment) -> some View {
        var result: some View {
            HStack {
                if to != .leading {
                    Spacer()
                }
                
                self
                
                if to != .trailing {
                    Spacer()
                }
            }
        }
        
        return result
    }
    
    func alignViewVertically(to: VerticalAlignment) -> some View {
        var result: some View {
            VStack {
                if to != .top {
                    Spacer()
                }
                
                self
                
                if to != .bottom {
                    Spacer()
                }
            }
        }
        
        return result
    }
    
    func customFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.font(.system(size: size, weight: weight, design: design))
    }
    
    #if os(iOS)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    #endif
    
    #if os(iOS) || os(watchOS)
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    #endif
    
    #if os(iOS)
    func alertTextField(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (String) -> (), secondaryAction: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = hintText
        }
        
        alert.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        
        alert.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            if let text = alert.textFields?[0].text {
                primaryAction(text)
            } else {
                primaryAction("")
            }
        }))
        
        rootController().present(alert, animated: true)
    }
    
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    func setupForBanner(showWhen isShowingBanner: Bool, minHeight: CGFloat, closeButtonText: String = "Done", buttonColor: Color, dismissAction: @escaping () -> Void, bannerContent: any View) -> some View {
        ZStack(alignment: .bottom) {
            self.disabled(isShowingBanner)
            
            if isShowingBanner {
                Color.black
                    .opacity(0.7)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            dismissAction()
                            HapticManager.shared.impact(style: .soft)
                        }
                    }
                    .transition(.opacity)
            }
            
            if isShowingBanner {
                BannerView(minHeight: minHeight, closeButtonText: closeButtonText, buttonColor: buttonColor, dismissAction: dismissAction) {
                    AnyView(bannerContent)
                }.transition(.move(edge: .bottom)).zIndex(1)
            }
        }.ignoresSafeArea()
    }
    #endif
    
    func countryFlag(countryCode: String) -> String {
      return String(String.UnicodeScalarView(
         countryCode.unicodeScalars.compactMap(
           { UnicodeScalar(127397 + $0.value) })))
    }
}

extension View {
    @inlinable
    public func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}

#if os(iOS) || os(watchOS)
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif
