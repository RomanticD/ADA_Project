//
//  OperationPanel.swift
//  CurrencyExchangeSys
//
//  Created by Romantic D on 2023/11/18.
//

import SwiftUI

struct OperationPanel: View {
    @Binding var animated : Bool
    @Binding var selectedCurrency : [String]
    var screen = NSScreen.main?.visibleFrame
    
    var body: some View {
        VStack{
            Button(action: {
                withAnimation (.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.5)) {
                    animated.toggle()
                }
            }, label: {
                Text("Get Result")
            })
        }
        .frame(width: (screen!.width / 1.8) / 2)
    }
}

#Preview {
    OperationPanel(animated: .constant(false), selectedCurrency: .constant([]))
}
