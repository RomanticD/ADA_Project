//
//  CurrencyTag.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/19.
//

import SwiftUI

struct CurrencyTag: View {
    let currency: String
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedCurrency : [String]
    @State var isPressed =  false
    
    var isSelected: Bool {
        selectedCurrency.contains(currency)
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed.toggle()
            }
            
            if isSelected {
                selectedCurrency.removeAll(where: { $0 == currency })
            } else {
                selectedCurrency.append(currency)
            }
        }) {
            Text(currency)
                .foregroundColor(isSelected ? Color.white : Color(hex: "2a0845"))
                .font(.system(size: 12))
                .padding()
                .lineLimit(1)
                .background(isSelected ? .indigo.opacity(0.6) : colorScheme == .dark ? Color(hex: "AAAAAA") : Color.white.opacity(0.5))
                .frame(height: 20)
                .cornerRadius(10)
                .overlay(Capsule().stroke(Color(hex: "2c3e50").opacity(0.6), lineWidth: 1))
        }
        .frame(width: 60)
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? CGSize(width: 1.2, height: 1.2) : CGSize(width: 1.0, height: 1.0))
    }
}

#Preview {
    CurrencyTag(currency: "CNY", selectedCurrency: .constant([]))
}
