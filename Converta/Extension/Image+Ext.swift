//
//  Image+Ext.swift
//  Converta
//
//  Created by Ernest Dainals on 18/03/2023.
//

import SwiftUI

extension Image {
    func flipped(_ axis: Axis = .horizontal, anchor: UnitPoint = .center) -> some View {
        switch axis {
        case .horizontal:
            return scaleEffect(CGSize(width: -1, height: 1), anchor: anchor)
        case .vertical:
            return scaleEffect(CGSize(width: 1, height: -1), anchor: anchor)
        }
    }
}
