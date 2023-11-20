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
    @Binding var rateData : [CurrencyExchangeData]
    @State var matrix : [[Double]] = []
    var screen = NSScreen.main?.visibleFrame
    
    var body: some View {
        VStack{
            Button(action: {
                withAnimation (.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.5)) {
                    animated.toggle()
                }
                
                matrix = exchangeRateDataToMatrix(data: rateData)
            }, label: {
                Text("Get Result")
            })
            
            ForEach(0..<matrix.count, id: \.self) { row in
                            HStack {
                                ForEach(0..<matrix[row].count, id: \.self) { col in
                                    Text(String( matrix[row][col]))
                                        .padding(5)
                                        .frame(width: 100)
                                        .border(Color.gray)
                                        
                                }
                            }
                        }
        }
        .frame(width: (screen!.width / 1.5) / 2)
    }
}

#Preview {
    OperationPanel(animated: .constant(false), selectedCurrency: .constant([]), rateData: .constant(defaultRateData))
}
