//
//  BannerAd.swift
//  Converta
//
//  Created by Ernest Dainals on 18/06/2023.
//

import SwiftUI
import GoogleMobileAds

struct BannerAd: UIViewRepresentable {
    var unitID: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> some GADBannerView {
        let adView = GADBannerView(adSize: GADAdSizeBanner)
        
        adView.adUnitID = unitID
        adView.rootViewController = UIApplication.shared.getRootViewController()
        adView.delegate = context.coordinator
        adView.load(GADRequest())
        
        return adView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
          print("bannerViewDidReceiveAd")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewDidDismissScreen")
        }
    }
}

extension UIApplication {
    func getRootViewController() -> UIViewController {
        guard let screen = self.connectedScenes.first as? UIWindowScene else { return .init() }
        
        guard let root = screen.windows.first?.rootViewController else { return .init() }
        
        return root
    }
}

extension BannerAd {
    func setBannerType(to style : BannerAdStyle) -> some View {
        switch style {
        case .banner:
            return self.frame(width: 320, height: 50)
        case .bigBanner:
            return self.frame(width: 320, height: 100)
        case .rectangle:
            return self.frame(width: 300, height: 250)
        }
    }
}

enum BannerAdStyle { case banner, bigBanner, rectangle }
