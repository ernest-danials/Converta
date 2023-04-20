//
//  Keypad.swift
//  Converta
//
//  Created by Ernest Dainals on 17/02/2023.
//

import SwiftUI

struct NumberKeypad: View {
    @Binding var value: String
    let showPeriodButton: Bool
    let size: CGFloat
    let paddingSize: CGFloat
    let showDeleteButton: Bool
    let showResetButton: Bool
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
            ForEach(1...9, id: \.self) { value in
                KeypadButton(value: "\(value)", text: $value, size: size, paddingSize: paddingSize)
            }
            
            if showPeriodButton {
                KeypadButton(value: ".", text: $value, size: size, paddingSize: paddingSize)
                    .opacity(value.contains(".") ? 0.4 : 1.0)
            } else {
                if !showResetButton {
                    KeypadButton(value: "", text: $value, size: size, paddingSize: paddingSize).opacity(0).disabled(true)
                }
            }
            
            if showResetButton {
                KeypadButton(value: "reset", text: $value, size: size, paddingSize: paddingSize)
                    .disabled(value.isEmpty)
                    .opacity(value.isEmpty ? 0.4 : 1)
            } 
            
            KeypadButton(value: "0", text: $value, size: size, paddingSize: paddingSize)
            
            if showDeleteButton {
                KeypadButton(value: "delete", text: $value, size: size, paddingSize: paddingSize)
            }
        }
    }
}

struct KeypadButton: View {
    var value: String
    @Binding var text: String
    let size: CGFloat
    let paddingSize: CGFloat
    var body: some View {
        Button {
            if !text.contains(".") {
                #if os(iOS)
                if (text.count >= 11) && (value != "reset") && (value != "delete") {
                    #if os(iOS)
                    HapticManager.shared.impact(style: .rigid)
                    #elseif os(watchOS)
                    WKInterfaceDevice.current().play(.failure)
                    #endif
                } else {
                    if value == "." && text.contains(".") {
                        #if os(iOS)
                        HapticManager.shared.impact(style: .rigid)
                        #elseif os(watchOS)
                        WKInterfaceDevice.current().play(.failure)
                        #endif
                    } else {
                        updateValue()
                    }
                }
                
                #elseif os(watchOS)
                if (text.count >= 7) && (value != "reset") && (value != "delete") {
                    #if os(iOS)
                    HapticManager.shared.impact(style: .rigid)
                    #elseif os(watchOS)
                    WKInterfaceDevice.current().play(.failure)
                    #endif
                } else {
                    if value == "." && text.contains(".") {
                        #if os(iOS)
                        HapticManager.shared.impact(style: .rigid)
                        #elseif os(watchOS)
                        WKInterfaceDevice.current().play(.failure)
                        #endif
                    } else {
                        updateValue()
                    }
                }
                
                #endif
            } else {
                if value == "." && text.contains(".") {
                    #if os(iOS)
                    HapticManager.shared.impact(style: .rigid)
                    #elseif os(watchOS)
                    WKInterfaceDevice.current().play(.failure)
                    #endif
                } else {
                    updateValue()
                }
            }
        } label: {
            VStack {
                if value == "delete" {
                    Image(systemName: "delete.left.fill")
                        .foregroundColor(.red)
                        .font(.system(size: size))
                } else if value == "reset" {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .imageScale(.large)
                } else {
                    Text(value)
                        .customFont(size: size)
                        .fontWeight(.semibold)
                }
            }.padding(paddingSize)
        }.scaleButtonStyle(scaleAmount: value == "." ? 1 : 0.85, opacityAmount: 0.5)
    }
    
    func updateValue() {
        if text.isEmpty {
            if value == "delete" || value == "." {
                #if os(iOS)
                HapticManager.shared.impact(style: .rigid)
                #elseif os(watchOS)
                WKInterfaceDevice.current().play(.failure)
                #endif
            } else {
                text.append(value)
                
                #if os(iOS)
                HapticManager.shared.impact(style: .soft)
                #elseif os(watchOS)
                WKInterfaceDevice.current().play(.click)
                #endif
            }
        } else {
            if value == "delete" {
                if text.count != 0 {
                    text.removeLast()
                }
                
                #if os(iOS)
                HapticManager.shared.impact(style: .rigid)
                #elseif os(watchOS)
                WKInterfaceDevice.current().play(.click)
                #endif
            } else if value == "reset" {
                withAnimation { text.removeAll() }
                
                #if os(iOS)
                HapticManager.shared.impact(style: .rigid)
                #elseif os(watchOS)
                WKInterfaceDevice.current().play(.click)
                #endif
            } else {
                text.append(value)
                    
                #if os(iOS)
                HapticManager.shared.impact(style: .soft)
                #elseif os(watchOS)
                WKInterfaceDevice.current().play(.click)
                #endif
            }
        }
    }
}

struct NumberKeypad_Previews: PreviewProvider {
    static var previews: some View {
        NumberKeypad(value: .constant("preview"), showPeriodButton: true, size: 20, paddingSize: 5, showDeleteButton: true, showResetButton: false)
    }
}
